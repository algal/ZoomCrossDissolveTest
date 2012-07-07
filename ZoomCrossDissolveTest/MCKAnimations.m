//
//  MCKAnimations.m
//  ZoomCrossDissolveTest
//
//  Created by Alexis Gallagher on 2012-07-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MCKAnimations.h"
#import "MCKAnimationDelegate.h"

#define ANIMATION_DURATION ((NSTimeInterval) 0.5)



@implementation MCKAnimations

/**
 Replaces originalView with a plain UIView holding a snapshot.
 
 @param originalView view to be replaced
 @return replacement view
 
 TODO: Look into using shouldRasterize instead of manual snapshotting.
 
 */

+(UIView*) replaceView:(UIView*)originalView
{
  UIView * srcView = originalView;
  // snapshot srcView
  UIGraphicsBeginImageContextWithOptions(srcView.layer.bounds.size,NO,0.0);
  [srcView.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *oldImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndPDFContext();
  // assign its image to a replacement view
  UIView * srcReplacementView = [[UIView alloc] initWithFrame:srcView.frame];
  srcReplacementView.layer.contents = (id) [oldImage CGImage];
  // swap
  [srcView.superview insertSubview:srcReplacementView aboveSubview:srcView];
  [srcView.superview setNeedsDisplayInRect:srcReplacementView.frame];
  [srcView removeFromSuperview];
  return srcReplacementView;  
}

/**
 Zooming fade from one layer to another sharing a coordinate system.
 
 @param startLayer
 @param destLayer
 @param aDelegate a CAAnimation delegate
 
 Both layers are snapshotted. First layer is animated and mutated to new
 values for position,bounds,contents. Layers can be either siblings in a layer 
 hierarchy, or the backing layers of sibling UIViews.
 
 TODO: Look into using shouldRasterize instead of manual snapshotting.
 
 */

+(void) zoomFadeLayer:(CALayer*)startLayer 
       toSiblingLayer:(CALayer*)destLayer
    animationDelegate:(id)aDelegate
{
  // start values
  CGPoint oldPos = startLayer.position;
  CGRect oldBounds = startLayer.bounds;
  UIGraphicsBeginImageContextWithOptions(startLayer.bounds.size,NO,0.0);
  [startLayer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *oldImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  // new values
  CGPoint newPos = destLayer.position;
  CGRect newBounds = destLayer.bounds;
  UIGraphicsBeginImageContextWithOptions(destLayer.bounds.size,NO,0.0);
  [destLayer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  // preventing implicit animations every time we change layer property values
  [CATransaction setDisableActions:YES];
  // change the layer property values to their new final values
  startLayer.position = newPos;
  startLayer.bounds = newBounds;
  startLayer.contents = (id) [newImage CGImage];
  
  // now construct explicit animations..
  
  // animate position
  CABasicAnimation * animPos = [CABasicAnimation animationWithKeyPath:@"position"];
  animPos.fromValue = [NSValue valueWithCGPoint:oldPos];
  animPos.toValue   = [NSValue valueWithCGPoint:newPos];
  animPos.duration  = (CFTimeInterval) ANIMATION_DURATION;
  
  // animate bounds
  CABasicAnimation * animBounds = [CABasicAnimation animationWithKeyPath:@"bounds"];
  animBounds.fromValue = [NSValue valueWithCGRect:oldBounds];
  animBounds.toValue = [NSValue valueWithCGRect:newBounds];
  animBounds.duration = (CFTimeInterval) ANIMATION_DURATION;
  
  // animate image
  CABasicAnimation * animImage = [CABasicAnimation animationWithKeyPath:@"contents"];
  animImage.fromValue = (id)[oldImage CGImage];
  animImage.toValue   = (id)[newImage CGImage];
  animImage.duration  = (CFTimeInterval) ANIMATION_DURATION;
  
  // collect the animations into one group (maybe unnecessary?)
  CAAnimationGroup * animationGroup = [[CAAnimationGroup alloc] init];
  animationGroup.animations = [NSArray arrayWithObjects:animPos, 
                               animBounds,
                               animImage,
                               nil ];
  animationGroup.duration = ANIMATION_DURATION;
  
  if (aDelegate) {
    NSLog(@"adding delegate object to animation group object");
    animationGroup.delegate = aDelegate;
  }
  
  // add them to the layer.
  [startLayer addAnimation:animationGroup forKey:@"groupOfAnimation"];
}

/**
 Zoom-fades one view into another, removing the former, revealing the latter.
 
 @param srcView view to be zoomed, cross-dissolved into destView, and removed.
 @param destView hidden view to be revealed as srcView has zoom-fades into it.
 
 Creates the illusion of srcView continuously transforming into destView, by
 "zoom-fading" -- i.e., simultaneously animation position and bounds while
 cross-dissolving contents. 
 
 */
+(void) destrucitvelyZoomFadeView:(UIView*) srcView
                           toView:(UIView*)destView
{
  // replace srcView with its image
  /* (since we don't want indirectly to animate UIView properties */
  srcView = [[self class] replaceView:srcView];
  
  // make srcView a sibling of destView
  srcView.frame = [srcView.superview convertRect:srcView.frame 
                                          toView:destView.superview];
  [srcView removeFromSuperview];
  [destView.superview insertSubview:srcView aboveSubview:destView];
  
  destView.hidden = NO;
  // zoomfade via the layers ...
  [[self class] zoomFadeLayer:srcView.layer 
               toSiblingLayer:destView.layer 
            animationDelegate:
   [MCKAnimationDelegate 
    MCKAnimationDelegateWithDidStartBlock:^(CAAnimation *anim) {
      NSLog(@"animation starting");
      destView.hidden = YES;
      return;
    } 
    DidStopFinishedBlock:^(CAAnimation *anim, BOOL f) {
      // .. then remove the srcView
      NSLog(@"animation finished. removing view");
      destView.hidden = NO;
      [srcView removeFromSuperview];
      return;
    }]
   ];
  
  return;
}

/** Snapshot */
+(UIImage*) imageFromLayer:(CALayer*) aLayer {
  UIGraphicsBeginImageContextWithOptions(aLayer.bounds.size,NO,0.0);
  [aLayer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndPDFContext();
  return image;
}

+(void) saveImageToDisk:(UIImage*)anImage 
{  
  NSString * sandboxDirectory = NSHomeDirectory();
  NSString * pngPath = [sandboxDirectory stringByAppendingPathComponent:@"Documents/Test.jpg"];
  NSData *imgData = UIImagePNGRepresentation(anImage);
  [imgData writeToFile:pngPath atomically:YES];
  NSLog(@"wrote image to file %@",pngPath);
  return;
}

@end

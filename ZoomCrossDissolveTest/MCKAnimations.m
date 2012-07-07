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

+(void) destructivelyZoomFadeView:(UIView*) srcView
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
  UIImage * newImage = [[self class] imageFromLayer:destView.layer];
  destView.hidden = YES;
  
  CALayer * startLayer = srcView.layer;
  CALayer * destLayer = destView.layer;
  //  id aDelegate = nil;
  id aDelegate = [MCKAnimationDelegate 
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
                  }];
  //
  
  // start values
  CGPoint oldPos = startLayer.position;
  CGRect oldBounds = startLayer.bounds;
  UIImage *oldImage = [[self class] imageFromLayer:startLayer];
  
  // new values
  CGPoint newPos = destLayer.position;
  CGRect newBounds = destLayer.bounds;
  
  
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
  
  return;
}


#pragma mark snapshotters

/** Snapshot */
+(UIImage*) imageFromLayer:(CALayer*) aLayer {
  UIGraphicsBeginImageContextWithOptions(aLayer.bounds.size,NO,0.0);
  [aLayer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}


+ (UIImage*)imageFromViewShiftedOutsideSuperview:(UIView*)v {
  UIImage * snapshot;
  if (v.hidden == NO) {
    snapshot = [MCKAnimations imageFromLayer:v.layer];
  } 
  else {
    // offset to outside the superview
    CGRect oldFrame = v.frame;
    
    v.frame = CGRectStandardize(
                                CGRectMake(0.0f - CGRectGetWidth(v.frame), 
                                           CGRectGetMinY(v.frame), 
                                           CGRectGetWidth(v.frame), 
                                           CGRectGetHeight(v.frame))
                                );
    v.hidden = NO; // unhide it
    snapshot = [MCKAnimations imageFromLayer:v.layer]; 
    // restore
    v.hidden = YES;
    v.frame = oldFrame;
  }
  return snapshot;
}

+ (UIImage*)imageFromViewShiftedOutsideWindow:(UIView*)v {
  UIImage * snapshot;
  if (v.hidden == NO) {
    snapshot = [MCKAnimations imageFromLayer:v.layer];
  } 
  else {
    // cache view's hidden, frame, and slot in view hierarchy
    BOOL oldHidden = v.hidden;
    CGRect oldFrame = v.frame;
    UIView * oldSuperview = v.superview;
    NSUInteger oldSubviewIndex = [v.superview.subviews indexOfObject:v];
    
    // remove and insert into UIWindow, offscren
    UIWindow * win = [[UIApplication sharedApplication] keyWindow];
    [v removeFromSuperview];
    v.frame = CGRectOffset(v.frame, 0.0f - CGRectGetWidth(v.frame), 0);
    [win addSubview:v];
    // reveal and snapshot
    v.hidden = NO;
    snapshot = [MCKAnimations imageFromLayer:v.layer];
    
    // restore 
    [v removeFromSuperview];
    v.frame = oldFrame;
    [oldSuperview insertSubview:v atIndex:oldSubviewIndex];
    v.hidden = oldHidden;
  }
  return snapshot;
}

+(UIImage*) imageFromViewShiftedOffscreen:(UIView*)v {
  UIImage * snapshot;
  if (v.hidden == NO) {
    snapshot = [MCKAnimations imageFromLayer:v.layer];
  } 
  else {
    // cache view's hidden, frame, and slot in view hierarchy
    BOOL oldHidden = v.hidden;
    CGRect oldFrame = v.frame;
    
    // offset offscreen (outside bounds of the UIWindow)
    UIView * win = [[UIApplication sharedApplication] keyWindow];
    CGRect frameInWinCoords = [win convertRect:v.frame fromView:v.superview];
    frameInWinCoords = CGRectOffset(frameInWinCoords, 
                                    0.0f - CGRectGetWidth(frameInWinCoords), 0);
    v.frame = [v.superview convertRect:frameInWinCoords fromView:win];
    
    // reveal and snapshot
    v.hidden = NO;
    snapshot = [MCKAnimations imageFromLayer:v.layer];
    
    // restore 
    v.frame = oldFrame;
    v.hidden = oldHidden;
  }
  return snapshot;
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

//
//  ViewController.m
//  ZoomCrossDissolveTest
//
//  Created by Alexis Gallagher on 2012-03-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "CALayer+LayerDebugging.h"
#import "MCKAnimationDelegate.h"

#define ANIMATION_DURATION ((CFTimeInterval) 1.0)

@interface ViewController ()
@property (assign) CGRect initialBounds;
@property (assign) CGPoint initialPosition;
@property (strong) UIImage * initialImage;
@end

@implementation ViewController
@synthesize switchAB;
@synthesize imageViewA;
@synthesize imageViewB;
@synthesize imageView;
@synthesize viewOne;
@synthesize viewTwo;

@synthesize initialBounds, initialPosition,initialImage;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)resetAnimatableView
{
  self.imageView.layer.position = self.initialPosition;
  self.imageView.layer.bounds = self.initialBounds;
  self.imageView.layer.contents = (id) [self.initialImage CGImage];
  [self.imageView setNeedsDisplay];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
//  self.imageView.image = [UIImage imageNamed:@"o1_300x402.jpg"];
//  self.imageView.image = [UIImage imageNamed:@"o2_150x201.jpg"];

  self.initialPosition = self.imageView.layer.position;
  self.initialBounds = self.imageView.layer.bounds;
  self.initialImage = [UIImage imageNamed:@"o2_150x201.jpg"];

  [self resetAnimatableView];
}

- (void)viewDidUnload
{
  [self setImageView:nil];
  [self setImageViewA:nil];
  [self setImageViewB:nil];
  [self setSwitchAB:nil];
  [self setViewOne:nil];
  [self setViewTwo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  return YES;
}
#pragma mark helper

+(void) animateLayer:(CALayer*) theLayer 
             toImage:(UIImage*) toImage
       toNewPosition:(CGPoint) toPosition
         toNewBounds:(CGRect) toBounds
{
  // cache start values
  CGPoint oldPos = theLayer.position;
  CGRect oldBounds = theLayer.bounds;
  UIGraphicsBeginImageContextWithOptions(theLayer.bounds.size,NO,0.0);
  [theLayer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *oldImage = UIGraphicsGetImageFromCurrentImageContext();
  
  // preventing implicit animations from being generated everty time we change layer property values
  [CATransaction setDisableActions:YES];
  // change the layer property values to their new final values
  theLayer.bounds = toBounds;
  theLayer.position = toPosition;
  theLayer.contents = (id) [toImage CGImage];

  // now construct explicit animations..

  // animate position
  CABasicAnimation * animPos = [CABasicAnimation animationWithKeyPath:@"position"];
  animPos.fromValue = [NSValue valueWithCGPoint:oldPos];
  animPos.toValue   = [NSValue valueWithCGPoint:toPosition];
  animPos.duration  = (CFTimeInterval) ANIMATION_DURATION;
  
  // animate bounds
  CABasicAnimation * animBounds = [CABasicAnimation animationWithKeyPath:@"bounds"];
  animBounds.fromValue = [NSValue valueWithCGRect:oldBounds];
  animBounds.toValue = [NSValue valueWithCGRect:toBounds];
  animBounds.duration = (CFTimeInterval) ANIMATION_DURATION;
  
  // animate image
  CABasicAnimation * animImage = [CABasicAnimation animationWithKeyPath:@"contents"];
  animImage.fromValue = (id)[oldImage CGImage];
  animImage.toValue   = (id)[toImage CGImage];
  animImage.duration  = (CFTimeInterval) ANIMATION_DURATION;

  // collect the animations into one group (maybe unnecessary?)
  CAAnimationGroup * animationGroup = [[CAAnimationGroup alloc] init];
  animationGroup.animations = [NSArray arrayWithObjects:animPos, animBounds, animImage,nil];
  animationGroup.duration = ANIMATION_DURATION;
  
  // add them to the layer.
  [theLayer addAnimation:animationGroup forKey:@"groupOfAnimation"];

  return;
}

+(void) animateLayer:(CALayer*) theLayer 
           fromImage:(UIImage*) fromImage 
        atStartPosition:(CGPoint) fromPos
             toImage:(UIImage*) toImage
          toEndPosition:(CGPoint) toPos
{
  // animation position
  CABasicAnimation * animPos = [CABasicAnimation animationWithKeyPath:@"position"];
  animPos.fromValue = [NSValue valueWithCGPoint:fromPos];
  animPos.toValue   = [NSValue valueWithCGPoint:toPos];
  animPos.duration  = (CFTimeInterval) ANIMATION_DURATION;
  [theLayer addAnimation:animPos forKey:@"animation-positionX"];
  
  // animation 
  CABasicAnimation * animImage = [CABasicAnimation animationWithKeyPath:@"contents"];
  animImage.fromValue = (id)[fromImage CGImage];
  animImage.toValue   = (id)[toImage CGImage];
  animImage.duration  = (CFTimeInterval) ANIMATION_DURATION;
  [theLayer addAnimation:animImage forKey:@"animation-contents"];
  
  // update model values
  theLayer.position = toPos;
  theLayer.contents = (id) [toImage CGImage];
  
  return;
}

/**
 Replaces originalView with a UIView holding the same image.
 
 @param originalView view to be replaced
 @return replacement view
 */

+(UIView*) replaceView:(UIView*)originalView
{
  UIView * srcView = originalView;
  // snapshot srcView
  UIGraphicsBeginImageContextWithOptions(srcView.layer.bounds.size,NO,0.0);
  [srcView.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *oldImage = UIGraphicsGetImageFromCurrentImageContext();
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
 
 Both layers are snapshotted. First layer is animated and mutated to new
 values for position,bounds,contents. Layers can either be siblings under
 the same UIView, or both the backing layers of sibling UIViews.
 
 */

+(void)                  zoomFadeLayer:(CALayer*)startLayer 
                        toSiblingLayer:(CALayer*)destLayer
                     animationDelegate:(id)aDelegate
{
  // start values
  CGPoint oldPos = startLayer.position;
  CGRect oldBounds = startLayer.bounds;
  UIGraphicsBeginImageContextWithOptions(startLayer.bounds.size,NO,0.0);
  [startLayer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *oldImage = UIGraphicsGetImageFromCurrentImageContext();

  // new values
  CGPoint newPos = destLayer.position;
  CGRect newBounds = destLayer.bounds;
  UIGraphicsBeginImageContextWithOptions(destLayer.bounds.size,NO,0.0);
  [destLayer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

  // preventing implicit animations from being generated everty time we change layer property values
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
 Performing a zooming cross dissolve of one
 view into the position of the other.
 
 Removes sourceView and replaces it with a blank
 view with its image. does animations on that view.
 */
+(void) zoomDissolveView:(UIView*) srcView
                  toView:(UIView*)destView
{
  // make srcView a sibling of destView
  srcView.frame = [srcView.superview convertRect:srcView.frame 
                                          toView:destView.superview];
  [srcView removeFromSuperview];
  [destView.superview insertSubview:srcView aboveSubview:destView];

  // zoomfade via the layers ...
  [[self class] zoomFadeLayer:srcView.layer 
               toSiblingLayer:destView.layer 
            animationDelegate:
   [MCKAnimationDelegate MCKAnimationDelegateHelperWithStopFinishedBlock:
    ^(CAAnimation *anim, BOOL flag) {
      // .. then remove the srcView
      NSLog(@"animation finished. removing view");
      [srcView removeFromSuperview];
      return;
    }]];
  
  return;
}

#pragma mark actions

-(IBAction)toggleAB:(UISwitch*)sender {
  BOOL newHidden = ! sender.on;
  self.imageViewA.hidden = newHidden;
  self.imageViewB.hidden = newHidden;
}

- (IBAction)shiftLayer:(id)sender {
  NSLog(@"self.viewOne.layer.position=%@",NSStringFromCGPoint(self.viewOne.layer.position));
  NSLog(@"self.viewOne.frame.origin=%@",NSStringFromCGPoint(self.viewOne.frame.origin));

  NSLog(@"increasing layer.position.x by +20");
  self.viewOne.layer.position = CGPointApplyAffineTransform(self.viewOne.layer.position, CGAffineTransformMakeTranslation(20, 0)); // x += 20

  NSLog(@"increasing layer.position.y by +20");
  self.viewOne.layer.position = CGPointApplyAffineTransform(self.viewOne.layer.position, CGAffineTransformMakeTranslation(0, 20)); // y += 20

  NSLog(@"self.viewOne.layer.position=%@",NSStringFromCGPoint(self.viewOne.layer.position));
  NSLog(@"self.viewOne.frame.origin=%@",NSStringFromCGPoint(self.viewOne.frame.origin));
}
- (IBAction)logLayer:(id)sender {
  NSLog(@"[self.viewOne.layer debugLayerTree]=%@",[self.viewOne.layer debugLayerTree] );
}

- (IBAction)viewDissolve:(id)sender {
  NSLog(@"beginning viewDissolve");
//  self.viewOne = [[self class] replaceView:self.viewOne]; // to work with a plain UIView
  [[self class] zoomDissolveView:self.viewOne toView:self.viewTwo];
}

- (IBAction)mutateAnchorPoint:(id)sender {
  NSLog(@"[self.viewOne.layer debugLayerTree]=%@",[self.viewOne.layer debugLayerTree] );
  NSLog(@"mutating anchorPoint to 0,0");
  self.viewOne.layer.anchorPoint=CGPointMake(0,0);
  NSLog(@"[self.viewOne.layer debugLayerTree]=%@",[self.viewOne.layer debugLayerTree] );
}

-(IBAction)buttonPushed:(UIButton*)sender {
  
  if (sender.tag == 100) {
    /*
     // UIKit-based cross-dissolve transition of image
     [UIView transitionWithView:self.view
     duration:3.0f
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^{
     self.imageView.image = self.imageViewA.image;
     } completion:^(BOOL finished) {
     NSLog(@"transition completed. interrupted=%@", (finished ? @"NO" : @"NO"));
     }];
     
     // UIKit-based animation of UIImageView frame
     [UIView animateWithDuration:3.0f
     delay:0.0f
     options:UIViewAnimationOptionCurveEaseIn
     animations:^{
     self.imageView.frame = self.imageViewA.frame;
     
     return;
     } completion:^(BOOL finished) {
     NSLog(@"animation completed. interrupted=%@", (finished ? @"NO" : @"NO"));
     }];
     */    
    
    /*
     // layer-based animation of position & cross-dissolve of contents
     // setup the animation
     UIImage * fromImage = self.imageView.image;
     UIImage * toImage = self.imageViewA.image;
     
     CALayer * imageLayer = self.imageView.layer;
     
     CGFloat fromX = imageLayer.position.x;
     CGFloat toX = fromX - 100;
     
     // animation position
     CABasicAnimation * animPos = [CABasicAnimation animationWithKeyPath:@"position.x"];
     animPos.fromValue = [NSNumber numberWithFloat:fromX];
     animPos.toValue   = [NSNumber numberWithFloat:toX];
     animPos.duration  = (CFTimeInterval) ANIMATION_DURATION;
     [imageLayer addAnimation:animPos forKey:@"animation-positionX"];
     
     // animation 
     CABasicAnimation * animImage = [CABasicAnimation animationWithKeyPath:@"contents"];
     animImage.fromValue = (id)[fromImage CGImage];
     animImage.toValue   = (id)[toImage CGImage];
     animImage.duration  = (CFTimeInterval) ANIMATION_DURATION;
     [imageLayer addAnimation:animImage forKey:@"animation-contents"];
     
     // update model values
     imageLayer.position = CGPointMake(toX,imageLayer.position.y);
     imageLayer.contents = (id) [toImage CGImage];
     */    
    
    
    /*   
     // layer-based animation of position & cross-dissolve of contents
     CGPoint oldPos = self.imageView.layer.position;
     CGPoint newPos = CGPointMake(oldPos.x - 100, oldPos.y);
     
     [[self class] animateLayer:self.imageView.layer
     fromImage:self.imageView.image
     atStartPosition:self.imageView.layer.position
     toImage:self.imageViewA.image
     toEndPosition:newPos];
     
     */
    
    // layer-based animation of position, bounds & cross-dissolve of contents
    CGPoint oldPos = self.imageView.layer.position;
    CGPoint newPos = CGPointMake(oldPos.x - 400, oldPos.y);
    
    CGRect oldBounds = self.imageView.layer.bounds;
    CGRect newBounds = CGRectInset(oldBounds, 40, 40);
    
    [[self class] animateLayer:self.imageView.layer
                       toImage:self.imageViewA.image
                 toNewPosition:newPos 
                   toNewBounds:newBounds];
    
    //    [self.view setNeedsLayout];
  } 
  else if (sender.tag == 200 ) {
    self.imageView.frame = self.imageViewB.frame;
    self.imageView.image = self.imageViewB.image;
    [self.view setNeedsLayout];
    [self.imageView setNeedsDisplay];
  } 
  else if (sender.tag == 300 ) {
    [self resetAnimatableView];
  } 
  else {
    NSLog(@"unrecognized");
  }
  
}

@end

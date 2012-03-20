//
//  ViewController.m
//  ZoomCrossDissolveTest
//
//  Created by Alexis Gallagher on 2012-03-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#import <QuartzCore/QuartzCore.h>

#define ANIMATION_DURATION ((CFTimeInterval) 5.0)

@implementation ViewController
@synthesize switchAB;
@synthesize imageViewA;
@synthesize imageViewB;
@synthesize imageView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
//  self.imageView.image = [UIImage imageNamed:@"o1_300x402.jpg"];
  self.imageView.image = [UIImage imageNamed:@"o2_150x201.jpg"];
  //  [self.imageView setNeedsDisplay];
}

- (void)viewDidUnload
{
  [self setImageView:nil];
  [self setImageViewA:nil];
  [self setImageViewB:nil];
  [self setSwitchAB:nil];
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
  // animation position
  CABasicAnimation * animPos = [CABasicAnimation animationWithKeyPath:@"position"];
  animPos.fromValue = nil;
  animPos.toValue   = [NSValue valueWithCGPoint:toPosition];
  animPos.duration  = (CFTimeInterval) ANIMATION_DURATION;
  [theLayer addAnimation:animPos forKey:@"animation-positionX"];
  
  // animate bounds
  CABasicAnimation * animBounds = [CABasicAnimation animationWithKeyPath:@"bounds"];
  animBounds.fromValue = nil;
  animBounds.toValue = [NSValue valueWithCGRect:toBounds];
  animBounds.duration = (CFTimeInterval) ANIMATION_DURATION;
  [theLayer addAnimation:animBounds forKey:@"animation-bounds"];
  
  // animate image
  CABasicAnimation * animImage = [CABasicAnimation animationWithKeyPath:@"contents"];
  animImage.fromValue = nil;
  animImage.toValue   = (id)[toImage CGImage];
  animImage.duration  = (CFTimeInterval) ANIMATION_DURATION;
  [theLayer addAnimation:animImage forKey:@"animation-contents"];
  
//  // update model values
//  theLayer.bounds = toBounds;
//  theLayer.position = toPosition;
//  theLayer.contents = (id) [toImage CGImage];
  
  return;
}

+(void) animateLayer:(CALayer*) theLayer 
           fromImage:(UIImage*) fromImage 
        atStartFrame:(CGRect) fromFrame 
             toImage:(UIImage*) toImage
          toEndFrame:(CGRect) toFrame
{
  // animation position
  CABasicAnimation * animPos = [CABasicAnimation animationWithKeyPath:@"frame"];
  animPos.fromValue = [NSValue valueWithCGRect:fromFrame];
  animPos.toValue   = [NSValue valueWithCGRect:toFrame];
  animPos.duration  = (CFTimeInterval) ANIMATION_DURATION;
  [theLayer addAnimation:animPos forKey:@"animation-positionX"];
  
  // animate image
  CABasicAnimation * animImage = [CABasicAnimation animationWithKeyPath:@"contents"];
  animImage.fromValue = (id)[fromImage CGImage];
  animImage.toValue   = (id)[toImage CGImage];
  animImage.duration  = (CFTimeInterval) ANIMATION_DURATION;
  [theLayer addAnimation:animImage forKey:@"animation-contents"];
  
  // update model values
  theLayer.frame = toFrame;
  theLayer.contents = (id) [toImage CGImage];
  
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


#pragma mark actions

-(IBAction)toggleAB:(UISwitch*)sender {
  BOOL newHidden = ! sender.on;
  self.imageViewA.hidden = newHidden;
  self.imageViewB.hidden = newHidden;
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
 // layer-based animation of frame & cross-dissolve of contents
    CGRect oldFrame = self.imageView.layer.frame;
    CGRect newFrame = CGRectOffset(oldFrame, -100, 0);

    [[self class] animateLayer:self.imageView.layer
                     fromImage:self.imageView.image
                  atStartFrame:self.imageView.layer.frame
                       toImage:self.imageViewA.image
                    toEndFrame:newFrame];
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
    CGPoint newPos = CGPointMake(oldPos.x - 100, oldPos.y);
    
    CGRect oldBounds = self.imageView.layer.bounds;
    CGRect newBounds = CGRectInset(oldBounds, 30, 30);
    
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
    self.imageView.frame = CGRectMake(239, 616, 261, 234);
  } 
  else {
    NSLog(@"unrecognized");
  }
  
}


@end

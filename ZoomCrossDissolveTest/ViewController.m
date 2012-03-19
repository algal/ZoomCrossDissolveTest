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

    // layer-based animation of position
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

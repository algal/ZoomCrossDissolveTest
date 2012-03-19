//
//  ViewController.m
//  ZoomCrossDissolveTest
//
//  Created by Alexis Gallagher on 2012-03-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

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
  
  self.imageView.image = [UIImage imageNamed:@"o1_300x402.jpg"];
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
    self.imageView.frame = self.imageViewA.frame;
    [self.view setNeedsLayout];
  } else if (sender.tag == 200 ) {
    self.imageView.frame = self.imageViewB.frame;
    [self.view setNeedsLayout];
  } else if (sender.tag == 300 ) {
    self.imageView.frame = CGRectMake(239, 616, 261, 234);
  } else {
    NSLog(@"unrecognized");
  }
  
}

@end

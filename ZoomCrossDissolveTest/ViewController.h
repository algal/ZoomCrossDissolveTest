//
//  ViewController.h
//  ZoomCrossDissolveTest
//
//  Created by Alexis Gallagher on 2012-03-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@property (strong, nonatomic) IBOutlet UISwitch *switchAB;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewA;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewB;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;


@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewTwo;

@end

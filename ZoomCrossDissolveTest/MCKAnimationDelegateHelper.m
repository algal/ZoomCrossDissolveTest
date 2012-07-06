//
//  MCKAnimationDelegateHelper.m
//  ZoomCrossDissolveTest
//
//  Created by Alexis Gallagher on 2012-07-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MCKAnimationDelegateHelper.h"

@implementation MCKAnimationDelegateHelper
@synthesize animationDidStopFinishedBlock;

+(MCKAnimationDelegateHelper*) 
MCKAnimationDelegateHelperWithStopFinishedBlock:(didStopFinishedBlock_t)b {
  MCKAnimationDelegateHelper * x = [[MCKAnimationDelegateHelper alloc] init];
  x.animationDidStopFinishedBlock = b;
  return x;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
  animationDidStopFinishedBlock(anim,flag);
}
@end

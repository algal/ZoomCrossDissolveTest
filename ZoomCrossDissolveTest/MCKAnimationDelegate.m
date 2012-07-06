//
//  MCKAnimationDelegateHelper.m
//  ZoomCrossDissolveTest
//
//  Created by Alexis Gallagher on 2012-07-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MCKAnimationDelegate.h"

@implementation MCKAnimationDelegate
@synthesize animationDidStopFinishedBlock;

+(MCKAnimationDelegate*) 
MCKAnimationDelegateWithStopFinishedBlock:(didStopFinishedBlock_t)b {
  MCKAnimationDelegate * x = [[MCKAnimationDelegate alloc] init];
  x.animationDidStopFinishedBlock = b;
  return x;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
  animationDidStopFinishedBlock(anim,flag);
}
@end

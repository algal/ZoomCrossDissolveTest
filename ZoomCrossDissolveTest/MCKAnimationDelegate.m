//
//  MCKAnimationDelegateHelper.m
//  ZoomCrossDissolveTest
//
//  Created by Alexis Gallagher on 2012-07-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MCKAnimationDelegate.h"

@implementation MCKAnimationDelegate
@synthesize animationDidStopFinishedBlock = _animationDidStopFinishedBlock;
@synthesize animationDidStartBlock = _animationDidStartBlock;

+(MCKAnimationDelegate*) 
MCKAnimationDelegateWithDidStopFinishedBlock:(didStopFinishedBlock_t)b {
  MCKAnimationDelegate * x = [[MCKAnimationDelegate alloc] init];
  x.animationDidStopFinishedBlock = b;
  return x;
}

+(MCKAnimationDelegate*) MCKAnimationDelegateWithDidStartBlock:(didStartBlock_t)startBlock
                                          DidStopFinishedBlock:(didStopFinishedBlock_t)stopBlock
{
  MCKAnimationDelegate * x = [[MCKAnimationDelegate alloc] init];
  x.animationDidStartBlock = startBlock;
  x.animationDidStopFinishedBlock = stopBlock;
  return x;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  _animationDidStopFinishedBlock(anim,flag);
}
-(void)animationDidStart:(CAAnimation *)anim {
  _animationDidStartBlock(anim);
}
@end

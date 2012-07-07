//
//  MCKAnimationDelegateHelper.h
//  ZoomCrossDissolveTest
//
//  Created by Alexis Gallagher on 2012-07-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


typedef void (^didStartBlock_t) (CAAnimation*);
typedef void (^didStopFinishedBlock_t) (CAAnimation*,BOOL);

@interface MCKAnimationDelegate : NSObject
@property (strong) didStopFinishedBlock_t animationDidStopFinishedBlock;
@property (strong) didStartBlock_t animationDidStartBlock;

/**
 Returns fresh object implementing applicationDidStop:finished:
 
 @param aBlock block implementing of the method
 @return MCKAnimationDelegate object, a delegate for a CAAnimation
 
 */
+(MCKAnimationDelegate*) MCKAnimationDelegateWithDidStopFinishedBlock:(didStopFinishedBlock_t)aBlock;

/**
 Returns fresh object implementing applicationDidStop:finished:
 
 @param aBlock block implementing of the method
 @return MCKAnimationDelegate object, a delegate for a CAAnimation
 
 */
+(MCKAnimationDelegate*) MCKAnimationDelegateWithDidStartBlock:(didStartBlock_t)startBlock
                                          DidStopFinishedBlock:(didStopFinishedBlock_t)stopBlock;


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;

@end

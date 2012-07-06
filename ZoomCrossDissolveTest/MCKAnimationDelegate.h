//
//  MCKAnimationDelegateHelper.h
//  ZoomCrossDissolveTest
//
//  Created by Alexis Gallagher on 2012-07-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


//typedef void (^animationDidStartBlock_t) (CAAnimation*);
typedef void (^didStopFinishedBlock_t) (CAAnimation*,BOOL);

@interface MCKAnimationDelegate : NSObject
@property (strong) didStopFinishedBlock_t animationDidStopFinishedBlock;

/**
 Returns fresh object implementing applicationDidStop:finished:
 
 @param aBlock block implementing of the method
 @return MCKAnimationDelegate object, a delegate for a CAAnimation
 
 */
+(MCKAnimationDelegate*) MCKAnimationDelegateWithStopFinishedBlock:(didStopFinishedBlock_t)aBlock;

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;

@end

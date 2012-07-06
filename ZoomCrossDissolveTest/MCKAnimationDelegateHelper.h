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
typedef void (^animationDidStopFinishedBlock_t) (CAAnimation*,BOOL);

@interface MCKAnimationDelegateHelper : NSObject
@property (strong) animationDidStopFinishedBlock_t animationDidStopFinishedBlock;

+(MCKAnimationDelegateHelper*) MCKAnimationDelegateHelperWithStopFinishedBlock:(animationDidStopFinishedBlock_t)b;

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;

@end

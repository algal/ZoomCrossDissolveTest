//
//  MCKAnimations.h
//  ZoomCrossDissolveTest
//
//  Created by Alexis Gallagher on 2012-07-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface MCKAnimations : NSObject

/**
 Replaces originalView with a plain UIView holding a snapshot.
 
 @param originalView view to be replaced
 @return replacement view
 */

+(UIView*) replaceView:(UIView*)originalView;

/**
 Zooming fade from one layer to another sharing a coordinate system.
 
 @param startLayer
 @param destLayer
 @param aDelegate a CAAnimation delegate
 
 Both layers are snapshotted. First layer is animated and mutated to new
 values for position,bounds,contents. Layers can be either siblings in a layer 
 hierarchy, or the backing layers of sibling UIViews.
 
 */

+(void) zoomFadeLayer:(CALayer*)startLayer 
       toSiblingLayer:(CALayer*)destLayer
    animationDelegate:(id)aDelegate;

/**
 Performing a zooming fade of one into another, removing the former.
 */
+(void) destrucitvelyZoomFadeView:(UIView*) srcView
                           toView:(UIView*)destView;



@end

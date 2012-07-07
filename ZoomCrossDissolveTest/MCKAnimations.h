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
 Zoomfades from one view to a hidden view, removing the former.
 
 @param srcView starting view, to be removed after animation
 @param destView (hidden) view representing new appearance
 
 Performs a morph (i.e., shape tween) from srcView to destView by 
 animating position, bounds, and contents.
 
 */
+(void) destructivelyZoomFadeView:(UIView*) srcView
                           toView:(UIView*)destView;


/** snapshot layer to UIImage */
+(UIImage*) imageFromLayer:(CALayer*) aLayer;

//
// snapshot hidden views with elaborate measures to 
// to prevent them ever becoming visible
//
/** Snapshot, shifting view outside its superview */
+ (UIImage*)imageFromViewShiftedOutsideSuperview:(UIView*)v;

/** Snapshot, shifting view offscreen and into UIWindow */
+ (UIImage*)imageFromViewShiftedOutsideWindow:(UIView*)v;

/** Snapshot, shifting view offscreen */
+(UIImage*) imageFromViewShiftedOffscreen:(UIView*)v;

+(void) saveImageToDisk:(UIImage*)anImage;

@end

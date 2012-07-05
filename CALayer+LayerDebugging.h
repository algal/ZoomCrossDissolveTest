//
//  CALayer+LayerDebugging.h
//  Vyana
//
//  Created by Mark Lilback on 9/7/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (LayerDebugging)
-(NSString*)debugDescription;
-(NSString*)debugLayerTree;
@end
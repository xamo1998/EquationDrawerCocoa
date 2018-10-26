//
//  Ecuation.h
//  EcuationDrawer
//
//  Created by xamo on 10/11/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EcuationData.h"
@interface Ecuation : NSObject{
    
    
    NSBezierPath *bezierPath;
}
@property NSColor *color;
@property EcuationData *ecuationData;
@property int termCount;
@property float *terms;
-(float) valueAt:(float)x;
-(void) drawInRect: (NSRect) bounds
withGraphicsContext:(NSGraphicsContext *)context;
@end

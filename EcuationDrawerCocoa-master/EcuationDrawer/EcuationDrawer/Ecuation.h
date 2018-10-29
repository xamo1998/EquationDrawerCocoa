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
@property NSString *name, *displayName;
@property NSMutableArray *params, *paramValues;
-(float) valueAt:(float)x;
-(void) drawInRect: (NSRect) bounds
withGraphicsContext:(NSGraphicsContext *)context;
@end

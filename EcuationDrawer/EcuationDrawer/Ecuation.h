//
//  Ecuation.h
//  EcuationDrawer
//
//  Created by xamo on 10/11/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Ecuation : NSObject{
    
    
    NSBezierPath *bezierPath;
}
@property NSColor *color;
@property NSString *name;
@property NSString *ecuation;
@property int termCount;
@property float *terms;
-(float) valueAt:(float)x;
-(void) drawInRect: (NSRect) bounds
withGraphicsContext:(NSGraphicsContext *)context;
@end

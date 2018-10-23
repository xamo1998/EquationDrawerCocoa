//
//  Ecuation.h
//  EcuationDrawer
//
//  Created by xamo on 10/11/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Ecuation : NSObject{
    
    float *terms;
    int termCount;
    
    NSBezierPath *bezierPath;
}
@property NSColor *color;
@property NSString *name;
@property NSString *ecuation;
-(float) valueAt:(float)x;
-(void) drawInRect: (NSRect) bounds
withGraphicsContext:(NSGraphicsContext *)context;
@end

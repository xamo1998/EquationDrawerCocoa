//
//  Ecuation.h
//  EcuationDrawer
//
//  Created by xamo on 10/11/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EquationData.h"
#import "Math/EquationSolver.h"
#import "Math/EquationParser.h"
@interface Equation : NSObject{
    EquationParser *parser;
    EquationSolver *solver;
    NSBezierPath *bezierPath;
}
@property NSColor *color;
@property float lineWidth;
@property NSString *equationToSolve,*name, *displayName;
@property NSMutableArray *params, *paramValues;
- (id)initWithEquationToSolve:(NSString *)equationToSolve
                   withParams:(NSMutableArray *)params
              withParamValues:(NSMutableArray *)paramValues;
-(float) valueAt:(float)x;
-(void) drawInRect: (NSRect) bounds
withGraphicsContext:(NSGraphicsContext *)context
      withFuncRect:(NSRect)funcRect
          withHops:(int)hops;
@end

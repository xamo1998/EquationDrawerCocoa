//
//  EquationSolver.h
//  EcuationDrawer
//
//  Created by alumno5 on 29/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Operation.h"
@interface EquationSolver : NSObject{
    
}

@property NSMutableArray *operations, *equationSplitted, *finalEquationSplitted;
- (id)initWithEquationSplitted:(NSMutableArray *) equationSplitted;
- (float) getYWithXValue:(float) xValue;
- (int) getIndexOfRaisedSymbol:(NSMutableArray *) equation;
- (int) getIndexOfAddition:(NSMutableArray *) equation;
- (int) getIndexOfMultiplier:(NSMutableArray *) equation;
- (int) getIndexOfOperation;
- (NSPoint) getIndexOfDeepestParetheses;
- (void) initOperations;
- (bool)isNumber:(NSString *)number;
- (bool)isXRaised:(NSString *)number;
- (float) getValueParsedWithValue:(NSString *)value
                       withXValue:(float)xValue;
- (float) getValueFromIndexWithPosition:(NSPoint)position
                             withXValue:(float)xValue;
-(float) operate2TermsWithOperation:(NSString *)operation
                         withValue1:(NSString *)value1
                         withValue2:(NSString *)value2
                         withXValue:(float)xValue;

@end

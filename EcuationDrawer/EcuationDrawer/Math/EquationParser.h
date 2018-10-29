//
//  EquationParser.h
//  EcuationDrawer
//
//  Created by alumno5 on 29/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Operation.h"
@interface EquationParser : NSObject{
    
}
@property NSString *equationToSolve;
@property NSMutableArray *equationSplitted, *terms, *termValues, *posibleTerms;
-(id)initWithEquationToSolve:(NSString *)equationToSolve
                withTermValues:(NSMutableArray *)termValues
                      withTerm:(NSMutableArray *)terms;
-(void)parseEquation;
-(void)giveTermValues;
-(void)searchOperations;
-(void)createListOfPosibleTerms;
-(int)getIndexOfRaisedWithFirstValue:(int)i
                 withEquationToSolve:(NSString *)equationToSolve;
-(bool)isNumber:(NSString *)number;

@end

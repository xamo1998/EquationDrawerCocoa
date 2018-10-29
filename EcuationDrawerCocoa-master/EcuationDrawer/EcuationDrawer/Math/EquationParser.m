//
//  EquationParser.m
//  EcuationDrawer
//
//  Created by alumno5 on 29/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "EquationParser.h"

@implementation EquationParser
- (id)initWithEquationToSolve:(NSString *)equationToSolve
                withTermValues:(NSMutableArray *)termValues
                      withTerm:(NSMutableArray *)terms{
    self=[super init];
    if(!self){
        
    }
    self.equationToSolve=equationToSolve;
    self.terms=terms;
    self.termValues=termValues;
    self.equationSplitted=[[NSMutableArray alloc]init];
    [self createListOfPosibleTerms];
    [self parseEquation];
    NSLog(@"DONE!");
    NSLog(@"LIST: %@",_equationSplitted);
    return self;
}
-(void)parseEquation{
    //Miramos parentesis balanceados...
    NSRange range;
    for(int i=0; i<[_equationToSolve length]; i++){
        range.length=i;
        range.location=i+1;
        if([self isNumber:[_equationToSolve substringWithRange:range]]){
            int lastIndexOfNumber= [self getIndexOfRaisedWithFirstValue:i withEquationToSolve:_equationToSolve];
            range.location=lastIndexOfNumber;
            [_equationSplitted addObject:[_equationToSolve substringWithRange:range]];
            i=lastIndexOfNumber;
        }else{
            [_equationSplitted addObject:[_equationToSolve substringWithRange:range]];
        }
    }
    [self searchOperations];
    [self giveTermValues];
}
-(void)giveTermValues{
    for(int i=0; i< [_equationSplitted count]; i++){
        NSString *splitValue= [_equationSplitted objectAtIndex:i];
        for(int j=0; j< [_terms count]; j++){
            NSString *termValue= [_terms objectAtIndex:j];
            if([splitValue isEqualToString:termValue]){
                [_equationSplitted removeObjectAtIndex:i];
                [_equationSplitted insertObject:termValue atIndex:i];
            }
        }
    }
    
    for(int i=0; i< [_equationSplitted count]; i++){
        NSString *splitValue=[_equationSplitted objectAtIndex:i];
        for(int j=0; j< [_posibleTerms count]; j++){
            NSString *posibleTermValue=[_posibleTerms objectAtIndex:j];
            if([splitValue isEqualToString:posibleTermValue]){
                _equationSplitted=NULL;//Hemos encontrado un termino que no estaba declarado.
                return;
            }
        }
    }
}
-(void)searchOperations{
    NSMutableArray *operations = [[NSMutableArray alloc]init];
    [operations addObject:[[Operation alloc]initWithOperation:@"cos"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"sen"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"tan"]];
    bool operationFound=NO;
    int counter=0;
    int indexOfOperation=-1;
    for(int i=0; i<[operations count]; i++){
        NSLog(@"OP: ", [[operations objectAtIndex:i]operation]);
    }
}
-(void)createListOfPosibleTerms{
    
}
-(int)getIndexOfRaisedWithFirstValue:(int)i
                 withEquationToSolve:(NSString *)equationToSolve{
    return 0;
}
-(bool)isNumber:(NSString *)number{
    if([number isEqualToString:@"."]) return YES;
    //double number=[number doubleValue];
    //NSLog(number);
    
    
}

@end

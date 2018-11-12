//
//  EquationParser.m
//  EcuationDrawer
//
//  Created by alumno5 on 29/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "EquationParser.h"
#import "BalancedParentheses.h"

@implementation EquationParser
- (id)initWithEquationToSolve:(NSString *)equationToSolve
                withTermValues:(NSMutableArray *)termValues
                      withTerm:(NSMutableArray *)terms{
    self=[super init];
    if(self){
        self.equationToSolve=equationToSolve;
        self.terms=terms;
        self.termValues=termValues;
        self.equationSplitted=[[NSMutableArray alloc]init];
        [self createListOfPosibleTerms];
        [self parseEquation];  
    }
    return self;
}
-(void)parseEquation{
    BalancedParentheses *bp= [[BalancedParentheses alloc]init];
    NSMutableArray *temp=[[NSMutableArray alloc]init];
    NSRange r;
    r.length=1;
    for(int i=0; i<[_equationToSolve length];i++){
        r.location=i;
        [temp addObject:[NSString stringWithFormat:@"%c",[_equationToSolve characterAtIndex:i]] ];
    }
    if(![bp areParenthesesBalanced:temp]){
        _equationSplitted=NULL;
        return;
    }
    NSRange range;
    for(int i=0; i<[_equationToSolve length]; i++){
        range.length=1;
        range.location=i;
        [_equationSplitted addObject:[_equationToSolve substringWithRange:range]];
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
                [_equationSplitted insertObject:[_termValues objectAtIndex:j] atIndex:i];
            }
        }
    }
    for(int i=0; i< [_equationSplitted count]; i++){
        NSString *splitValue=[NSString stringWithFormat:@"%@",[_equationSplitted objectAtIndex:i]];
        for(int j=0; j< [_posibleTerms count]; j++){
            NSString *posibleTermValue=[NSString stringWithFormat:@"%@",[_posibleTerms objectAtIndex:j]];
            if([splitValue isEqualToString:posibleTermValue]){
                _equationSplitted=NULL;
                return;
            }
        }
    }
}
-(void)searchOperations{
    NSMutableArray *operations = [[NSMutableArray alloc]init];
    [operations addObject:[[Operation alloc]initWithOperation:@"senh"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"sinh"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"cosh"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"tanh"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"tagh"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"tgh"]];
    
    [operations addObject:[[Operation alloc]initWithOperation:@"cos"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"sen"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"sin"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"tag"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"tan"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"tg"]];
    
    [operations addObject:[[Operation alloc]initWithOperation:@"sqrt"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"abs"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"log"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"ln"]];
    
    int counter=0;
    int indexOfOperation=-1;
    NSString * splitValue;
    NSString *letterOfOperation;
    for(int i=0; i<[operations count]; i++){
        while([[self toString:_equationSplitted]containsString:[[operations objectAtIndex:i]splitted]]){
            for(int j=0; j<[_equationSplitted count]; j++){
                splitValue=[_equationSplitted objectAtIndex:j];
                letterOfOperation=[[[operations objectAtIndex:i]letters]objectAtIndex:counter];
                if([splitValue isEqualToString:letterOfOperation]){
                    counter++;
                    if(counter==[[[operations objectAtIndex:i]letters]count]){
                        indexOfOperation=j+1-[[[operations objectAtIndex:i]letters]count];
                        counter=0;
                    }
                }else{
                    counter=0;
                }
            }
            for(int j=0; j<[[[operations objectAtIndex:i]letters]count]; j++){
                [_equationSplitted removeObjectAtIndex:indexOfOperation];
            }
            [_equationSplitted insertObject:[[operations objectAtIndex:i]operation] atIndex:indexOfOperation];
        }
    }
    
}
-(NSMutableString *) toString:(NSMutableArray *)list{
    NSMutableString *string=[NSMutableString string];
    for(int i=0 ; i<[list count]; i++){
        [string appendString:[NSString stringWithFormat:@"%@, ",[list objectAtIndex:i]]];
    }
    return string;
}

-(void)createListOfPosibleTerms{
    _posibleTerms= [[NSMutableArray alloc]init];
    for(char a='a'; a<='w'; a++){
        [_posibleTerms addObject:[NSString stringWithFormat:@"%c",a]];
    }
}



@end

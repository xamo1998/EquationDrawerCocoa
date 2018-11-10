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
    NSLog(@"%@",_equationSplitted);
    return self;
}
-(void)parseEquation{
    //Miramos parentesis balanceados...
    
    NSRange range;
    for(int i=0; i<[_equationToSolve length]; i++){
        range.length=1;
        range.location=i;
        if([self isNumber:[_equationToSolve substringWithRange:range]]){
            int lastIndexOfNumber= [self getIndexOfRaisedWithFirstValue:i withEquationToSolve:_equationToSolve];
            NSLog(@"LAST INDEX: %d---%d",i, lastIndexOfNumber);
            range.length=lastIndexOfNumber-i;
            [_equationSplitted addObject:[_equationToSolve substringWithRange:range]];
            //NSLog(@"1.-INTRODUZCO: %@", [_equationToSolve substringWithRange:range]);
            i=lastIndexOfNumber;
            range.location=i;
            range.length=1;
        }//else{
            range.location=i;
            range.length=1;
            [_equationSplitted addObject:[_equationToSolve substringWithRange:range]];
            //NSLog(@"2.-INTRODUZCO: %@", [_equationToSolve substringWithRange:range]);
            
        //}
    }
    NSLog(@"ACABé");
    [self searchOperations];
    NSLog(@"HOLLL");
    NSLog([self toString:_equationSplitted]);
    [self giveTermValues];
    NSLog([self toString:_equationSplitted]);
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
    //NSLog([self toString:_equationSplitted]);
    for(int i=0; i< [_equationSplitted count]; i++){
        NSString *splitValue=[NSString stringWithFormat:@"%@",[_equationSplitted objectAtIndex:i]];
        for(int j=0; j< [_posibleTerms count]; j++){
            NSString *posibleTermValue=[NSString stringWithFormat:@"%@",[_posibleTerms objectAtIndex:j]];
            if([splitValue isEqualToString:posibleTermValue]){
                //NSLog(@"Found: %@",posibleTermValue);
                _equationSplitted=NULL;//Hemos encontrado un termino que no estaba declarado.
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
    [operations addObject:[[Operation alloc]initWithOperation:@"cos"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"sen"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"sin"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"tag"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"tan"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"sqrt"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"abs"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"log"]];
    [operations addObject:[[Operation alloc]initWithOperation:@"ln"]];
    bool operationFound=NO;
    int counter=0;
    int indexOfOperation=-1;
    NSString * splitValue;
    NSString *letterOfOperation;
    NSLog([self toString:_equationSplitted]);
    for(int i=0; i<[operations count]; i++){
        while([[self toString:_equationSplitted]containsString:[[operations objectAtIndex:i]splitted]]){
            //NSLog(@"Hay una operacion");
            for(int j=0; j<[_equationSplitted count]; j++){
                splitValue=[_equationSplitted objectAtIndex:j];
                letterOfOperation=[[[operations objectAtIndex:i]letters]objectAtIndex:counter];
                if([splitValue isEqualToString:letterOfOperation]){
                    //NSLog(@"He encontrado la letra: %@ en la POS: i:%d;j:%d",splitValue,i,j);
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
            //NSLog(@"MODIFICADA OP");
            //NSLog([self toString:_equationSplitted]);
        }
    }
    
    NSLog([self toString:_equationSplitted]);
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
-(int)getIndexOfRaisedWithFirstValue:(int)i
                 withEquationToSolve:(NSString *)equationToSolve{
    int counter=1;
    NSRange range;
    range.location=i+1;
    range.length=1;
    if([[equationToSolve substringWithRange:range]isEqualTo:@"("])return i+1;
    if([[equationToSolve substringWithRange:range]isEqualTo:@")"])return i+1;
    if([[equationToSolve substringWithRange:range]isEqualTo:@"+"])return i+1;
    if([[equationToSolve substringWithRange:range]isEqualTo:@"-"])return i+1;
    if([[equationToSolve substringWithRange:range]isEqualTo:@"*"])return i+1;
    if([[equationToSolve substringWithRange:range]isEqualTo:@"/"])return i+1;
    if([[equationToSolve substringWithRange:range]isEqualTo:@""])return i+1;
    
    if([equationToSolve length]<(i+2)) return i+1;
    for(int j=i+2; j< [equationToSolve length]; j++){
        int temp=j;
        
        range.location=temp;
        range.length=1;
        while(temp<[equationToSolve length] && [self isNumber:[equationToSolve substringWithRange:range]]){
            temp++;
            range.location=temp;
        }
        return temp;
    }
    return -1;
}
-(bool)isNumber:(NSString *)number{
    if([number isEqualToString:@"."]) return YES;
    //double number=[number doubleValue];
    //NSLog(number);
    if([number isEqualTo:@"("]) return false;
    if([number isEqualTo:@")"]) return false;
    if([number isEqualTo:@"-"]) return false;
    if([number isEqualTo:@"+"]) return false;
    if([number isEqualTo:@"*"]) return false;
    if([number isEqualTo:@"/"]) return false;
    if([number isEqualTo:@"^"]) return false;
    if([number isEqualToString:@"e"])return NO;
    NSScanner *scanner;
    return [[NSScanner scannerWithString:number] scanDecimal:NULL];
}

@end

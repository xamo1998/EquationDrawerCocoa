//
//  Modelo.m
//  EcuationDrawer
//
//  Created by Alumno on 23/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "Modelo.h"

@implementation Modelo
@class EcuationData;
@synthesize ecuationData;
@synthesize ecuations;
-(id)init{
    self=[super init];
    if(!self){
        
    }
    ecuationData=[[NSMutableArray alloc]init];
    ecuations=[[NSMutableArray alloc]init];
    [self createTitleOfEcuations];
    return self;
}

-(void)createTitleOfEcuations{
    [ecuationData addObject:[[EcuationData alloc]initWithName:@"a * sen(b*x)" withTerms:[self getArrayOfTerms:@"a",@"b",nil]]];
    EcuationData *data =[ecuationData objectAtIndex:0];
    NSLog(@"LIST: %@",[data terms]);
    [ecuationData addObject:[[EcuationData alloc]initWithName:@"a * cos(b*x)" withTerms:[self getArrayOfTerms:@"a",@"b",nil]]];
    [ecuationData addObject:[[EcuationData alloc]initWithName:@"a * x^n" withTerms:[self getArrayOfTerms:@"a",@"n",nil]]];
    [ecuationData addObject:[[EcuationData alloc]initWithName:@"a * x + b" withTerms:[self getArrayOfTerms:@"a",@"b",nil]]];
    [ecuationData addObject:[[EcuationData alloc]initWithName:@"a * x^2 + b*x + c" withTerms:[self getArrayOfTerms:@"a",@"b",@"c",nil]]];
    [ecuationData addObject:[[EcuationData alloc]initWithName:@"a / (b*x)" withTerms:[self getArrayOfTerms:@"a",@"b",nil]]];

}
-(NSMutableArray *)getArrayOfTerms:(id)terms,...{
    NSMutableArray *arguments=[[NSMutableArray alloc]initWithArray:nil];
    id eachObject;
    va_list argumentList;
    if(terms){
        [arguments addObject:terms];
        va_start(argumentList, terms);
        while((eachObject = va_arg(argumentList, id))){
            [arguments addObject: eachObject];
        }
        va_end(argumentList);
    }
    NSLog(@"LIST DENTRO: %@",arguments);
    return arguments;
}

@end

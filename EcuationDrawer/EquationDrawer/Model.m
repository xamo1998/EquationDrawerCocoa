//
//  Modelo.m
//  EcuationDrawer
//
//  Created by Alumno on 23/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "Model.h"

@implementation Model
@class EquationData;
@synthesize equationData;
@synthesize equations;
-(id)init{
    self=[super init];
    if(self){
        self.backgroundColor=[NSColor whiteColor];
        self.hops=4000;
        self.lineWidth=0.6;
        self.grid=true;
        self.tickMarks=true;
        self.funcRect=NSMakeRect(-100,-100,200,200);
        equationData=[[NSMutableArray alloc]init];
        _drawedEquations=[[NSMutableArray alloc]init];
        equations=[[NSMutableArray alloc]init];
        [self createTitleOfEcuations];    
    }
    
    return self;
}

-(void)createTitleOfEcuations{
    [equationData addObject:[[EquationData alloc]initWithName:@"a*sen(b*x)" withTerms:[self getArrayOfTerms:@"a",@"b",nil]]];
    [equationData addObject:[[EquationData alloc]initWithName:@"a*cos(b*x)" withTerms:[self getArrayOfTerms:@"a",@"b",nil]]];
    [equationData addObject:[[EquationData alloc]initWithName:@"a*x^n" withTerms:[self getArrayOfTerms:@"a",@"n",nil]]];
    [equationData addObject:[[EquationData alloc]initWithName:@"a*x+b" withTerms:[self getArrayOfTerms:@"a",@"b",nil]]];
    [equationData addObject:[[EquationData alloc]initWithName:@"a*x^2+b*x+c" withTerms:[self getArrayOfTerms:@"a",@"b",@"c",nil]]];
    [equationData addObject:[[EquationData alloc]initWithName:@"a/(b*x)" withTerms:[self getArrayOfTerms:@"a",@"b",nil]]];

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
    return arguments;
}

-(float)getWidthOfGraphicsLine{return (float)(_lineWidth);}
-(float)getWidthOfGridLine{return (float)(0.3);}

@end

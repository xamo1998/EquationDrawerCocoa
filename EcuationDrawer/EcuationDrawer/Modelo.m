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
    self.backgroundColor=[NSColor whiteColor];
    self.hops=4000;
    self.lineWidth=0.6;
    self.grid=true;
    self.numbers=true;
    self.tickMarks=true;
    self.funcRect=NSMakeRect(-100,-100,200,200);
    ecuationData=[[NSMutableArray alloc]init];
    _drawedEquations=[[NSMutableArray alloc]init];
    ecuations=[[NSMutableArray alloc]init];
    [self createTitleOfEcuations];
    return self;
}

-(void)createTitleOfEcuations{
    [ecuationData addObject:[[EcuationData alloc]initWithName:@"a*sen(b*x)" withTerms:[self getArrayOfTerms:@"a",@"b",nil]]];
    EcuationData *data =[ecuationData objectAtIndex:0];
    //NSLog(@"LIST: %@",[data terms]);
    [ecuationData addObject:[[EcuationData alloc]initWithName:@"a*cos(b*x)" withTerms:[self getArrayOfTerms:@"a",@"b",nil]]];
    [ecuationData addObject:[[EcuationData alloc]initWithName:@"a*x^n" withTerms:[self getArrayOfTerms:@"a",@"n",nil]]];
    [ecuationData addObject:[[EcuationData alloc]initWithName:@"a*x+b" withTerms:[self getArrayOfTerms:@"a",@"b",nil]]];
    [ecuationData addObject:[[EcuationData alloc]initWithName:@"a*x^2+b*x+c" withTerms:[self getArrayOfTerms:@"a",@"b",@"c",nil]]];
    [ecuationData addObject:[[EcuationData alloc]initWithName:@"a/(b*x)" withTerms:[self getArrayOfTerms:@"a",@"b",nil]]];

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
    //NSLog(@"LIST DENTRO: %@",arguments);
    return arguments;
}

-(float)getWidthOfGraphicsLine{return (float)(_lineWidth);}
-(float)getWidthOfGridLine{return (float)(0.3);}
-(float)getTextSize{return (float)(3.5);}
-(float)getXOffsetForNumbers{return (float)(1.0);}
-(float)getYOffsetForNumbers{return (float)(9.0);}
-(float)getStepValue{return (float)(8.0);}
/*
-(float)getWidthOfGraphicsLine{return (float)(self.funcRect.size.height*_lineWidth)/200;}
-(float)getWidthOfGridLine{return (float)(self.funcRect.size.height*0.3)/200;}
-(float)getTextSize{return (float)(self.funcRect.size.height*3.5)/200;}
-(float)getXOffsetForNumbers{return (float)(self.funcRect.size.height*1)/200;}
-(float)getYOffsetForNumbers{return (float)(self.funcRect.size.height*9)/200;}
-(float)getStepValue{return (float)(self.funcRect.size.height/8);}*/

@end

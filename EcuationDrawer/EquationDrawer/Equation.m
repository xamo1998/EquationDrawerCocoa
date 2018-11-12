//
//  Ecuation.m
//  EcuationDrawer
//
//  Created by xamo on 10/11/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "Equation.h"
#define NaN -99999998
@implementation Equation
@synthesize name;
@synthesize displayName;
- (id)initWithEquationToSolve:(NSString *)equationToSolve
                   withParams:(NSMutableArray *)params
              withParamValues:(NSMutableArray *)paramValues{
    self=[super init];
    if(self){
        self.equationToSolve=equationToSolve;
        self.paramValues=paramValues;
        self.params=params;
        NSLog(@"TRYING: %@",_equationToSolve);
        parser=[[EquationParser alloc]initWithEquationToSolve:_equationToSolve withTermValues:_paramValues withTerm:_params];
        solver=[[EquationSolver alloc]initWithEquationSplitted:[parser equationSplitted]];
        bezierPath=[[NSBezierPath alloc]init];    
    } 
    return self;    
}

-(void)drawInRect:(NSRect)bounds withGraphicsContext:(NSGraphicsContext *)context withFuncRect:(NSRect)funcRect withHops:(int)hops{
    NSPoint point, previousPoint;
    float distance = funcRect.size.width/hops;
    [bezierPath removeAllPoints];
    [context saveGraphicsState];
    
    [bezierPath setLineWidth:_lineWidth];
    [_color setStroke];
    point.x=funcRect.origin.x;
    point.y=[self valueAt:point.x];
    
    [bezierPath moveToPoint:point];
    while(point.x<=funcRect.origin.x+funcRect.size.width){
        point.y=[self valueAt:point.x];
        if(point.y!=NaN){
            if((previousPoint.y>0 && point.y<0 && (previousPoint.y-point.y)>1) || (previousPoint.y<0 && point.y>0 && (point.y-previousPoint.y)>1)){
                [bezierPath moveToPoint:point];
            }else{
                [bezierPath lineToPoint:point];
            }
        }else{
            [bezierPath moveToPoint:point];
        }
        previousPoint.x=point.x;
        previousPoint.y=point.y;
        point.x+=distance;  
    }
    [bezierPath stroke];
    [context restoreGraphicsState];
}

-(float)valueAt:(float)x{
    return [solver getYWithXValue:x];
}



@end

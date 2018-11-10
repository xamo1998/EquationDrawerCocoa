//
//  Ecuation.m
//  EcuationDrawer
//
//  Created by xamo on 10/11/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "Ecuation.h"
#define NaN -99999998
@implementation Ecuation
@synthesize name;
@synthesize displayName;
- (id)initWithEquationToSolve:(NSString *)equationToSolve
                   withParams:(NSMutableArray *)params
              withParamValues:(NSMutableArray *)paramValues{
    self=[super init];
    if(!self){
        
    }
    self.lineWidth=0.6;
    self.equationToSolve=equationToSolve;
    self.paramValues=paramValues;
    self.params=params;
    NSLog(@"TRYING: %@",_equationToSolve);
    parser=[[EquationParser alloc]initWithEquationToSolve:_equationToSolve withTermValues:_paramValues withTerm:_params];
    solver=[[EquationSolver alloc]initWithEquationSplitted:[parser equationSplitted]];
    bezierPath=[[NSBezierPath alloc]init];
    return self;
    
}

-(void)drawInRect:(NSRect)bounds withGraphicsContext:(NSGraphicsContext *)context withFuncRect:(NSRect)funcRect withHops:(int)hops{
    NSPoint point, previousPoint;
    float distance = funcRect.size.width/hops;
    [bezierPath removeAllPoints];
    [context saveGraphicsState];
    
    /*NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:bounds.size.width/2 yBy:bounds.size.height/2];
    [transform scaleXBy:bounds.size.width/funcRect.size.width yBy:bounds.size.height/funcRect.size.height];
    [transform concat];*/
    [bezierPath setLineWidth:_lineWidth];
    [_color setStroke];
    point.x=funcRect.origin.x;
    point.y=[self valueAt:point.x];
    
    [bezierPath moveToPoint:point];
    while(point.x<=funcRect.origin.x+funcRect.size.width){
        point.y=[self valueAt:point.x];
        if(point.y!=NaN){
            NSLog(@"X:%f    Y:%f",point.x,point.y);
            if((previousPoint.y>0 && point.y<0 && (previousPoint.y-point.y)>5) || (previousPoint.y<0 && point.y>0 && (point.y-previousPoint.y)>5)){
                [bezierPath moveToPoint:point];
            }else{
                [bezierPath lineToPoint:point];
            }
        }else{
            NSLog(@"NaN");
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
    //NSLog(@"SOLVER: R:%f, DOY:%f",x,[solver getYWithXValue:x]);
    return [solver getYWithXValue:x];
}



@end

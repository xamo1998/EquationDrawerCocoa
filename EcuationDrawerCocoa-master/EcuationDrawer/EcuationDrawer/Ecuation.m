//
//  Ecuation.m
//  EcuationDrawer
//
//  Created by xamo on 10/11/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "Ecuation.h"
#define HOPS (500)
static NSRect funcRect = {-10,-10,20,20};

@implementation Ecuation
@synthesize termCount;
@synthesize terms;
- (id)init{
    self=[super init];
    if(!self){
        
    }
    bezierPath=[[NSBezierPath alloc]init];
    return self;
    
}

-(void)drawInRect:(NSRect)bounds withGraphicsContext:(NSGraphicsContext *)context{
    NSPoint point;
    float distance = funcRect.size.width/HOPS;
    [bezierPath removeAllPoints];
    [context saveGraphicsState];
    
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:bounds.size.width/2 yBy:bounds.size.height/2];
    [transform scaleXBy:bounds.size.width/funcRect.size.width yBy:bounds.size.height/funcRect.size.height];
    [transform concat];
    [bezierPath setLineWidth:0.1];
    //[color setStroke];
    point.x=funcRect.origin.x;
    point.y=[self valueAt:point.x];
    [bezierPath moveToPoint:point];
    while(point.x<=funcRect.origin.x+funcRect.size.width){
        point.y=[self valueAt:point.x];
        [bezierPath lineToPoint:point];
        point.x+=distance;
    }
    [bezierPath stroke];
    [context restoreGraphicsState];
}
@end

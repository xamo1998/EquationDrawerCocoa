//
//  Chart.m
//  EcuationDrawer
//
//  Created by xamo on 10/2/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "Chart.h"

@implementation Chart

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
    [self drawAxisWithGrid:YES withNumbers:YES withTickMarks:YES withStepValue:5];
    NSRect bounds =[self bounds];
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    [graphicsController drawPolynomialsInBounds:bounds withGC:context];
    /*NSRect rectY= NSMakeRect(10, 10, 1, 10000);
    NSRect rectX= NSMakeRect(10, 10, 10000, 1);
    NSBezierPath *pathX= [NSBezierPath bezierPathWithRect:rectX];
    NSBezierPath *pathY= [NSBezierPath bezierPathWithRect:rectY];
    [pathX fill];
    [pathY fill];*/
}


-(void)drawAxisWithGrid:(bool)grid withNumbers:(bool)numbers withTickMarks:(bool)tickMarks withStepValue:(float)stepValue{
    
    NSRect bounds=[self bounds];
    float maxHeight=bounds.size.height;
    float maxWidth=bounds.size.width;
    
    NSPoint maxPoint;
    maxPoint.x=maxWidth;
    maxPoint.y=maxHeight;
    [self drawGrid:10 withMaxPoint:maxPoint];

    NSRect rectX= NSMakeRect(0, maxHeight/2, maxWidth,3);
    NSRect rectY= NSMakeRect(maxWidth/2, 0, 3, maxHeight);
    NSBezierPath *pathX=[NSBezierPath bezierPathWithRect:rectX];
    NSBezierPath *pathY=[NSBezierPath bezierPathWithRect:rectY];
    [pathX stroke];
    [pathY stroke];
    [[NSColor blackColor]set];
    [pathX fill];
    [pathY fill];
    
}

-(void)drawNumbers:(float)stepValue withMaxPoint:(NSPoint)maxPoint{
    int contadorNumbers=0;
    for(int i=(maxPoint.x/2)+stepValue; i<maxPoint.x;i+=stepValue){ //Grid Vertical Positivo
        contadorNumbers++;
        if(contadorNumbers%5==0){
            NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",i-(maxPoint.x/2)] attributes:NULL];
            [string drawAtPoint:NSMakePoint(i, maxPoint.y/2 +5)]; //+5 bc of spacing
        }
    }
    contadorNumbers=0;
    for(int i=(maxPoint.x/2)-stepValue; i>0;i-=stepValue){ //Grid Vertical Negativo
        contadorNumbers++;
        if(contadorNumbers%5==0){
            NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",i-(maxPoint.x/2)] attributes:NULL];
            [string drawAtPoint:NSMakePoint(i, maxPoint.y/2 +5)];
        }
    }
    contadorNumbers=0;
    for(int i=(maxPoint.y/2)+stepValue; i<maxPoint.y;i+=stepValue){
        contadorNumbers++;
        if(contadorNumbers%5==0){
            NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",i-(maxPoint.y/2)] attributes:NULL];
            [string drawAtPoint:NSMakePoint(maxPoint.x/2 +5, i)];
        }
    }
    contadorNumbers=0;
    for(int i=(maxPoint.y/2)-stepValue; i>0;i-=stepValue){
        contadorNumbers++;
        if(contadorNumbers%5==0){
            NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",i-(maxPoint.y/2)] attributes:NULL];
            [string drawAtPoint:NSMakePoint(maxPoint.x/2 +5, i)];
        }
    }}

-(void)drawGrid:(float)stepValue withMaxPoint:(NSPoint)maxPoint{
    NSRect rectX, rectY;
    NSBezierPath *pathY, *pathX;
    int contadorDarkGrey=0;
    for(int i=(maxPoint.x/2)+stepValue; i<maxPoint.x;i+=stepValue){ //Grid Vertical Positivo
        contadorDarkGrey++;
        rectY=NSMakeRect(i, 0, 1, maxPoint.y);
        pathY=[NSBezierPath bezierPathWithRect:rectY];
        contadorDarkGrey%5==0 ? [[NSColor darkGrayColor]set] : [[NSColor gridColor]set];
        [pathY fill];
        
    }
    contadorDarkGrey=0;
    for(int i=(maxPoint.x/2)-stepValue; i>0;i-=stepValue){ //Grid Vertical Negativo
        contadorDarkGrey++;
        rectY=NSMakeRect(i, 0, 1, maxPoint.y);
        pathY=[NSBezierPath bezierPathWithRect:rectY];
        contadorDarkGrey%5==0 ? [[NSColor darkGrayColor]set] : [[NSColor gridColor]set];
        
        [pathY fill];
    }
    contadorDarkGrey=0;
    for(int i=(maxPoint.y/2)+stepValue; i<maxPoint.y;i+=stepValue){
        contadorDarkGrey++;
        rectX=NSMakeRect(0, i, maxPoint.x, 1);
        pathX=[NSBezierPath bezierPathWithRect:rectX];
        contadorDarkGrey%5==0 ? [[NSColor darkGrayColor]set] : [[NSColor gridColor]set];
        [pathX fill];
    }
    contadorDarkGrey=0;
    for(int i=(maxPoint.y/2)-stepValue; i>0;i-=stepValue){
        contadorDarkGrey++;
        rectX=NSMakeRect(0, i, maxPoint.x, 1);
        pathX=[NSBezierPath bezierPathWithRect:rectX];
        contadorDarkGrey%5==0 ? [[NSColor darkGrayColor]set] : [[NSColor gridColor]set];
        [pathX fill];
    }
    [self drawNumbers:stepValue withMaxPoint:maxPoint];
}

@end

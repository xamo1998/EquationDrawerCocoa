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
    [[graphicsController getBackgroundColor]set];
    [NSBezierPath fillRect:[self bounds]];
    [[NSColor redColor]set];
    
    
    
    [[NSBezierPath bezierPathWithRect:NSMakeRect(_startDraggedPoint.x, _startDraggedPoint.y, _endDraggedPoint.x-_startDraggedPoint.x, _endDraggedPoint.y-_startDraggedPoint.y)]fill];
    
    [self drawAxisWithGrid:[graphicsController isGridEnabled] withNumbers:[graphicsController isNumbersEnabled] withTickMarks:[graphicsController isTickMarksEnabled] withStepValue:1];
    
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

-(void)mouseDown:(NSEvent *)event{
    _startDraggedPoint=[event locationInWindow];
    NSRect funcRect=[graphicsController getFuncRect];
    float x,y;
    x=_startDraggedPoint.x*(funcRect.size.width/_bounds.size.width)+funcRect.origin.x;
    y=_startDraggedPoint.y*(funcRect.size.height/_bounds.size.height)+funcRect.origin.y;
    _finalStartDraggedPoint.x=x;
    _finalStartDraggedPoint.y=y;
    NSLog(@"W:%f__H:%f====X:%f__Y:%f",funcRect.size.width,funcRect.size.height,x,y);
}
-(void)scrollWheel:(NSEvent *)event{
    //NSLog(@"%f",[event deltaY]);
    NSRect funcRect=[graphicsController getFuncRect];
    if([event deltaY]<0){//Hago Zoom
        [graphicsController setFuncRect:NSMakeRect(funcRect.origin.x*0.9, funcRect.origin.y*0.9, funcRect.size.width*0.9, funcRect.size.height*0.9)];
    }else if([event deltaY]>0){
        [graphicsController setFuncRect:NSMakeRect(funcRect.origin.x*1.1, funcRect.origin.y*1.1, funcRect.size.width*1.1, funcRect.size.height*1.1)];
        
    }
    //NSLog(@"aaaannn");
}
-(void)mouseDragged:(NSEvent *)event{
    _endDraggedPoint=[event locationInWindow];
    NSRect funcRect=[graphicsController getFuncRect];
    float x,y;
    x=_endDraggedPoint.x*(funcRect.size.width/_bounds.size.width)+funcRect.origin.x;
    y=_endDraggedPoint.y*(funcRect.size.height/_bounds.size.height)+funcRect.origin.y;
    _finalEndDraggedPoint.x=x;
    _finalEndDraggedPoint.y=y;
    [self setNeedsDisplay:true];
}
-(void)viewWillMoveToWindow:(NSWindow *)newWindow{
    NSTrackingArea* trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options: (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingMouseMoved) owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

-(NSImage *)imageRepresentation{
    NSSize mySize= self.bounds.size;
    NSSize imgSize= NSMakeSize(mySize.width, mySize.height);
    NSBitmapImageRep *bir=[self bitmapImageRepForCachingDisplayInRect:[self bounds]];
    [bir setSize:imgSize];
    [self cacheDisplayInRect:[self bounds] toBitmapImageRep:bir];
    NSImage * image =[[NSImage alloc]initWithSize:imgSize];
    [image addRepresentation:bir];
    return image;
    //return [[NSImage alloc]initWithData:[self dataWithPDFInsideRect:[self bounds]]];
    /*[image lockFocus];
    CGContextRef ctx=[NSGraphicsContext currentContext].graphicsPort;
    [self.layer renderInContext:ctx];
    [image unlockFocus];
    return image;*/
}

-(void)mouseMoved:(NSEvent *)event{
    //NSLog(@"AAA");
    NSPoint point=[event locationInWindow];
    NSRect funcRect=[graphicsController getFuncRect];
    float x,y;
    x=point.x*(funcRect.size.width/_bounds.size.width)+funcRect.origin.x;
    y=point.y*(funcRect.size.height/_bounds.size.height)+funcRect.origin.y;
    [xValue setStringValue:[NSString stringWithFormat:@"X: %.3f",x]];
    [yValue setStringValue:[NSString stringWithFormat:@"Y: %.3f",y]];
}

-(void)mouseUp:(NSEvent *)event{
    float height, width;
    if(_startDraggedPoint.x>0 && _endDraggedPoint.x>0){
        NSRect funcRect=[graphicsController getFuncRect];
        _startDraggedPoint.x=_startDraggedPoint.y=0;
        _endDraggedPoint.x=_endDraggedPoint.y=0;
        if(_finalEndDraggedPoint.x-_finalStartDraggedPoint.x>0)
            if(_finalEndDraggedPoint.y-_finalStartDraggedPoint.y>0)
                [graphicsController setFuncRect:NSMakeRect(_finalStartDraggedPoint.x, _finalStartDraggedPoint.y, _finalEndDraggedPoint.x-_finalStartDraggedPoint.x, _finalEndDraggedPoint.y-_finalStartDraggedPoint.y)];
            else{
                NSLog(@"Checking");
                height=_finalStartDraggedPoint.y-_finalEndDraggedPoint.y;
                width=_finalEndDraggedPoint.x-_finalStartDraggedPoint.x;
                [graphicsController setFuncRect:NSMakeRect(_finalStartDraggedPoint.x, _finalEndDraggedPoint.y, width, height)];
            }
        
        else{
            if(_finalEndDraggedPoint.y-_finalStartDraggedPoint.y>0){
                height=_finalEndDraggedPoint.y-_finalStartDraggedPoint.y;
                width=_finalStartDraggedPoint.x-_finalEndDraggedPoint.x;
                [graphicsController setFuncRect:NSMakeRect(_finalEndDraggedPoint.x, _finalStartDraggedPoint.y, width, height)];
            }else{
                height=_finalStartDraggedPoint.y-_finalEndDraggedPoint.y;
                width=_finalStartDraggedPoint.x-_finalEndDraggedPoint.x;
                [graphicsController setFuncRect:NSMakeRect(_finalEndDraggedPoint.x, _finalEndDraggedPoint.y, width, height)];
            }
        }
            
    }
}
-(void)drawAxisWithGrid:(bool)grid withNumbers:(bool)numbers withTickMarks:(bool)tickMarks withStepValue:(float)stepValue{
    NSRect funcRect=[graphicsController getFuncRect];
    float maxHeight=funcRect.size.height;
    float maxWidth=funcRect.size.width;
    
    NSPoint maxPoint;
    maxPoint.x=maxWidth;
    maxPoint.y=maxHeight;
    
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:-funcRect.origin.x*(_bounds.size.width)/funcRect.size.width yBy:-funcRect.origin.y*(_bounds.size.height)/funcRect.size.height];
    
    [transform scaleXBy:_bounds.size.width/funcRect.size.width yBy:_bounds.size.height/funcRect.size.height];
    [transform concat];
    
    
    if(grid)
        [self drawGrid:[graphicsController getStepValue] withMaxPoint:maxPoint];
    if(tickMarks)
        [self drawTickMarks];
    if(numbers)
        [self drawNumbers];
    
    
    //Dibujamos los ejes
    NSRect rectX, rectY;
    NSBezierPath *pathY, *pathX;
    float lineWidth=[graphicsController getWidthOfGridLine];
    [[NSColor blackColor]set];
    float xMin, xMax, yMin, yMax;
    xMin=funcRect.origin.x;
    yMin=funcRect.origin.y;
    xMax=funcRect.size.width-(-xMin);
    yMax=funcRect.size.height-(-yMin);
    float widthConstantY=funcRect.size.height/200;
    float widthConstantX=funcRect.size.width/200;
    NSLog(@"xMin:%.2f__xMax:%.2f\nyMin:%.2f__yMax:%.2f",xMin,xMax,yMin,yMax);
    //Eje Y:
    if(xMin<0 && xMax<=0)
        rectY=NSMakeRect(xMax, yMin,lineWidth*widthConstantX,yMax+(-yMin));
    if(xMin<0 && xMax>0)
        rectY=NSMakeRect(0, yMin, lineWidth*widthConstantX, yMax+(-yMin));
    if(xMin>=0 && xMax>0)
        rectY=NSMakeRect(xMin, yMin, lineWidth*widthConstantX, yMax+(-yMin));
    //Eje X:
    if(yMin<0 && yMax<=0)
        rectX=NSMakeRect(xMin, yMax, xMax+(-xMin), lineWidth*widthConstantY);
    if(yMin<0 && yMax>0)
        rectX=NSMakeRect(xMin, 0, xMax+(-xMin), lineWidth*widthConstantY);
    if(yMin>0 && yMax>0)
        rectX=NSMakeRect(xMin, yMin, xMax+(-xMin), lineWidth*widthConstantY);
    
    pathX=[NSBezierPath bezierPathWithRect:rectX];
    pathY=[NSBezierPath bezierPathWithRect:rectY];
    [pathX fill];
    [pathY fill];

}

-(void)drawTickMarks{
    NSRect rectX, rectY;
    NSBezierPath *pathY, *pathX;
    int contadorDarkGrey=0;
    float lineWidth=[graphicsController getWidthOfGridLine];
    NSRect funcRect=[graphicsController getFuncRect];
    float stepValueX=(funcRect.size.width)/14.0;
    float stepValueY=(funcRect.size.height)/10.0;
    //===========================
    float xMin, xMax, yMin, yMax;
    xMin=funcRect.origin.x;
    yMin=funcRect.origin.y;
    xMax=funcRect.size.width-(-xMin);
    yMax=funcRect.size.height-(-yMin);
    float widthConstantY=funcRect.size.height/200;
    float widthConstantX=funcRect.size.width/200;
    NSLog(@"xMin:%.2f__xMax:%.2f\nyMin:%.2f__yMax:%.2f",xMin,xMax,yMin,yMax);
    
    
    [[NSColor blackColor]set];
    //Eje X:
    float yPosition;
    if(xMin>=0){
        if(funcRect.origin.y<=0 && yMax>0) yPosition=0;
        else if(funcRect.origin.y>0) yPosition=funcRect.origin.y;
        else yPosition=yMax;
        for(float i=xMin+stepValueX; i<=funcRect.size.width+xMin;i+=stepValueX){ //Grid Vertical Positivo
            NSLog(@"a");
            rectY=NSMakeRect(i, yPosition-(stepValueY/8), lineWidth*funcRect.size.width/200, 2*stepValueY/8);
            pathY=[NSBezierPath bezierPathWithRect:rectY];
            [pathY fill];
        }
    }if(xMin<0 && xMax>0){
        
        if(funcRect.origin.y<=0 && yMax>0) yPosition=0;
        else if(funcRect.origin.y>0) yPosition=funcRect.origin.y;
        else yPosition=yMax;
        for(float i=stepValueX; i<=funcRect.size.width;i+=stepValueX){ //Grid Vertical Positivo
            rectY=NSMakeRect(i, yPosition-(stepValueY/8), lineWidth*funcRect.size.width/200, 2*stepValueY/8);
            pathY=[NSBezierPath bezierPathWithRect:rectY];
            [pathY fill];
            
        }
        for(float i=-stepValueX; i>=funcRect.origin.x;i-=stepValueX){ //Grid Vertical Positivo
            rectY=NSMakeRect(i, yPosition-(stepValueY/8), lineWidth*funcRect.size.width/200, 2*stepValueY/8);
            pathY=[NSBezierPath bezierPathWithRect:rectY];
            [pathY fill];
            
        }
    }if(xMax<=0){
        
        if(funcRect.origin.y<=0 && yMax>0) yPosition=0;
        else if(funcRect.origin.y>0) yPosition=funcRect.origin.y;
        else yPosition=yMax;
        for(float i=xMax-stepValueX; i>=funcRect.origin.x;i-=stepValueX){ //Grid Vertical Positivo
            rectY=NSMakeRect(i, yPosition-(stepValueY/8), lineWidth*funcRect.size.width/200, 2*stepValueY/8);
            pathY=[NSBezierPath bezierPathWithRect:rectY];
            [pathY fill];
            
        }
        
    }
    
    //Eje Y
    
    float xPosition;
    if(yMin>=0){
        if(funcRect.origin.x<=0 && xMax>0) xPosition=0;
        else if(funcRect.origin.x>0) xPosition=funcRect.origin.x;
        else xPosition=xMax;
        for(float i=yMin+stepValueY; i<=funcRect.size.height+yMin;i+=stepValueY){ //Grid Vertical Positivo
            rectX=NSMakeRect(xPosition-(stepValueX/8),i, 2*stepValueX/8,lineWidth*funcRect.size.height/200);
            pathX=[NSBezierPath bezierPathWithRect:rectX];
            [pathX fill];
        }
    }if(yMin<0 && yMax>0){
        
        if(funcRect.origin.x<=0 && xMax>0) xPosition=0;
        else if(funcRect.origin.x>0) xPosition=funcRect.origin.x;
        else xPosition=xMax;
        for(float i=stepValueY; i<=funcRect.size.height;i+=stepValueY){ //Grid Vertical Positivo
            rectX=NSMakeRect(xPosition-(stepValueX/8),i, 2*stepValueX/8,lineWidth*funcRect.size.height/200);
            pathX=[NSBezierPath bezierPathWithRect:rectX];
            [pathX fill];
            
        }
        for(float i=-stepValueY; i>=funcRect.origin.y;i-=stepValueY){ //Grid Vertical Positivo
            rectX=NSMakeRect(xPosition-(stepValueX/8),i,2*stepValueX/8 ,lineWidth*funcRect.size.height/200);
            pathX=[NSBezierPath bezierPathWithRect:rectX];
            [pathX fill];
            
        }
    }if(yMax<=0){
        
        if(funcRect.origin.x<=0 && xMax>0) xPosition=0;
        else if(funcRect.origin.x>0) xPosition=funcRect.origin.x;
        else xPosition=xMax;
        for(float i=yMax-stepValueY; i>=funcRect.origin.y;i-=stepValueY){ //Grid Vertical Positivo
            rectX=NSMakeRect(xPosition-(stepValueX/8),i, 2*stepValueX/8,lineWidth*funcRect.size.height/200);
            pathX=[NSBezierPath bezierPathWithRect:rectX];
            [pathX fill];
        }
    }
    
}
-(void)drawNumbers{
    int contadorNumbers=0;
    float textSize, offsetX, offsetY;
    NSRect rectX, rectY;
    NSBezierPath *pathY, *pathX;
    NSRect funcRect=[graphicsController getFuncRect];
    textSize=[graphicsController getTextSize];
    offsetX=[graphicsController getXOffsetForNumbers];
    offsetY=[graphicsController getYOffsetForNumbers];
    float stepValueX=(funcRect.size.width)/14.0;
    float stepValueY=(funcRect.size.height)/10.0;
    NSDictionary *attributesWidth=[NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica" size:textSize*funcRect.size.width/200], NSFontAttributeName, nil];
    NSDictionary *attributesHeight=[NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica" size:textSize*funcRect.size.height/200], NSFontAttributeName, nil];
    if(funcRect.origin.y<0){
        for(float i=stepValueX; i<=funcRect.size.width;i+=stepValueX){ //Grid Vertical Positivo
            NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",i]attributes:attributesWidth];
            //NSLog(@"HOLA %.2f",i-(maxPoint.x/2));
            [string drawAtPoint:NSMakePoint(i, 0)]; //+5 bc of spacing
        }
        
    }else{
        for(float i=funcRect.origin.x; i<=funcRect.size.width+funcRect.origin.x;i+=stepValueX){ //Grid Vertical Positivo
            NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",i]attributes:attributesWidth];
            //NSLog(@"HOLA %.2f",i-(maxPoint.x/2));
            [string drawAtPoint:NSMakePoint(i, 0)]; //+5 bc of spacing

        }
        
    }
    
    if(funcRect.origin.x<0){
        for(float i=-stepValueX; i>=funcRect.origin.x;i-=stepValueX){ //Grid Vertical Negativo
            NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",i]attributes:attributesWidth];
            //NSLog(@"HOLA %.2f",i-(maxPoint.x/2));
            [string drawAtPoint:NSMakePoint(i, 0)]; //+5 bc of spacing
        }
    }
    
    if(funcRect.origin.y<0){
        for(float i=stepValueY; i<=funcRect.size.height;i+=stepValueY){
            NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",i]attributes:attributesWidth];
            //NSLog(@"HOLA %.2f",i-(maxPoint.x/2));
            [string drawAtPoint:NSMakePoint(0, i)]; //+5 bc of spacing
        }
    }else{
        for(float i=funcRect.origin.y; i<=funcRect.size.height+funcRect.origin.y;i+=stepValueY){
            NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",i]attributes:attributesWidth];
            //NSLog(@"HOLA %.2f",i-(maxPoint.x/2));
            [string drawAtPoint:NSMakePoint(0, i)]; //+5 bc of spacing
        }
    }
    if(funcRect.origin.y<0){
        for(float i=-stepValueY; i>=funcRect.origin.y;i-=stepValueY){
            NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",i]attributes:attributesWidth];
            //NSLog(@"HOLA %.2f",i-(maxPoint.x/2));
            [string drawAtPoint:NSMakePoint(0, i)]; //+5 bc of spacing
        }
    }
    
    
}

-(void)drawGrid:(float)stepValue withMaxPoint:(NSPoint)maxPoint{
    NSRect rectX, rectY;
    NSBezierPath *pathY, *pathX;
    int contadorDarkGrey=0;
    float lineWidth=[graphicsController getWidthOfGridLine];
    NSRect funcRect=[graphicsController getFuncRect];
    float stepValueX=(funcRect.size.width)/14.0;
    float stepValueY=(funcRect.size.height)/10.0;
    
    float xMin, xMax, yMin, yMax;
    xMin=funcRect.origin.x;
    yMin=funcRect.origin.y;
    xMax=funcRect.size.width-(-xMin);
    yMax=funcRect.size.height-(-yMin);
    float widthConstantY=funcRect.size.height/200;
    float widthConstantX=funcRect.size.width/200;
    [[NSColor gridColor]set];
    
    //Eje X:
    float yPosition;
    float yEnd;
    if(xMin>=0){
        for(float i=xMin+stepValueX; i<=funcRect.size.width+xMin;i+=stepValueX){ //Grid Vertical Positivo
            rectY=NSMakeRect(i, yMin, lineWidth*funcRect.size.width/200, funcRect.size.height);
            pathY=[NSBezierPath bezierPathWithRect:rectY];
            [pathY fill];
        }
    }if(xMin<0 && xMax>0){
        for(float i=stepValueX; i<=funcRect.size.width;i+=stepValueX){ //Grid Vertical Positivo
            rectY=NSMakeRect(i, yMin, lineWidth*funcRect.size.width/200, funcRect.size.height);
            pathY=[NSBezierPath bezierPathWithRect:rectY];
            [pathY fill];
            
        }
        for(float i=-stepValueX; i>=funcRect.origin.x;i-=stepValueX){ //Grid Vertical Positivo
            rectY=NSMakeRect(i, yMin, lineWidth*funcRect.size.width/200, funcRect.size.height);
            pathY=[NSBezierPath bezierPathWithRect:rectY];
            [pathY fill];
            
        }
    }if(xMax<=0){
        for(float i=xMax-stepValueX; i>=funcRect.origin.x;i-=stepValueX){ //Grid Vertical Positivo
            rectY=NSMakeRect(i, yMin, lineWidth*funcRect.size.width/200, funcRect.size.height);
            pathY=[NSBezierPath bezierPathWithRect:rectY];
            [pathY fill];
            
        }
        
    }
    
    
    //Eje Y
    float xPosition;
    if(yMin>=0){
        for(float i=yMin+stepValueY; i<=funcRect.size.height+yMin;i+=stepValueY){ //Grid Vertical Positivo
            rectX=NSMakeRect(xMin,i, funcRect.size.width,lineWidth*funcRect.size.height/200);
            pathX=[NSBezierPath bezierPathWithRect:rectX];
            [pathX fill];
        }
    }if(yMin<0 && yMax>0){
        for(float i=stepValueY; i<=funcRect.size.height;i+=stepValueY){ //Grid Vertical Positivo
            rectX=NSMakeRect(xMin,i, funcRect.size.width,lineWidth*funcRect.size.height/200);
            pathX=[NSBezierPath bezierPathWithRect:rectX];
            [pathX fill];
        }
        for(float i=-stepValueY; i>=funcRect.origin.y;i-=stepValueY){ //Grid Vertical Positivo
            rectX=NSMakeRect(xMin,i,funcRect.size.width ,lineWidth*funcRect.size.height/200);
            pathX=[NSBezierPath bezierPathWithRect:rectX];
            [pathX fill];
        }
    }if(yMax<=0){
        for(float i=yMax-stepValueY; i>=funcRect.origin.y;i-=stepValueY){ //Grid Vertical Positivo
            rectX=NSMakeRect(xMin,i, funcRect.size.width,lineWidth*funcRect.size.height/200);
            pathX=[NSBezierPath bezierPathWithRect:rectX];
            [pathX fill];
        }
    }
}

@end

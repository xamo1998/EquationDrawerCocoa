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
    [self drawAxisWithGrid:[graphicsController isGridEnabled] withTickMarks:[graphicsController isTickMarksEnabled]];
    NSRect bounds =[self bounds];
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    [graphicsController drawPolynomialsInBounds:bounds withGC:context];
    
}
//Mouse Events
-(void)mouseDown:(NSEvent *)event{
    _startDraggedPoint=[event locationInWindow];
    NSRect funcRect=[graphicsController getFuncRect];
    float x,y;
    x=_startDraggedPoint.x*(funcRect.size.width/_bounds.size.width)+funcRect.origin.x;
    y=_startDraggedPoint.y*(funcRect.size.height/_bounds.size.height)+funcRect.origin.y;
    _finalStartDraggedPoint.x=x;
    _finalStartDraggedPoint.y=y;
}
-(void)scrollWheel:(NSEvent *)event{
    NSRect funcRect=[graphicsController getFuncRect];
    if([event deltaY]<0){//Hago Zoom
        [graphicsController setFuncRect:NSMakeRect(funcRect.origin.x*0.9, funcRect.origin.y*0.9, funcRect.size.width*0.9, funcRect.size.height*0.9)];
    }else if([event deltaY]>0){
        [graphicsController setFuncRect:NSMakeRect(funcRect.origin.x*1.1, funcRect.origin.y*1.1, funcRect.size.width*1.1, funcRect.size.height*1.1)];  
    }
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
-(void)mouseEntered:(NSEvent *)event{
    xValue.hidden=false;
    yValue.hidden=false;
    zoomIn.hidden=false;
    zoomOut.hidden=false;
}
-(void) mouseExited:(NSEvent *)event{
    xValue.hidden=true;
    yValue.hidden=true;
    zoomIn.hidden=true;
    zoomOut.hidden=true;
}

-(void)mouseMoved:(NSEvent *)event{
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

//Drawing methods
-(void)drawAxisWithGrid:(bool)grid withTickMarks:(bool)tickMarks{
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
        [self drawGrid];
    if(tickMarks)
        [self drawTickMarks];
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
    
    
    [[NSColor blackColor]set];
    //Eje X:
    float yPosition;
    if(xMin>=0){
        if(funcRect.origin.y<=0 && yMax>0) yPosition=0;
        else if(funcRect.origin.y>0) yPosition=funcRect.origin.y;
        else yPosition=yMax;
        for(float i=xMin+stepValueX; i<=funcRect.size.width+xMin;i+=stepValueX){ //Grid Vertical Positivo
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

-(void)drawGrid{
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

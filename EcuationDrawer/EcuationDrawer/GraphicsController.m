//
//  GraphicsController.m
//  EcuationDrawer
//
//  Created by Alumno on 23/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "GraphicsController.h"
#import "PreferencesWindow.h"

@implementation GraphicsController

extern NSString * ReloadImageViewNotification;
extern NSString * DrawGraphicNotification;
-(id)init{
    self=[super init];
    if(!self){
        
    }
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(handleDrawGraphic:)
                   name:DrawGraphicNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(handleReloadImage:)
                   name:ReloadImageViewNotification
                 object:nil];
    modelo=[[Modelo alloc]init];
    NSLog(@"VALUE: %f", sqrtf(-1.0f));
    return self;
}
-(NSColor *)getBackgroundColor{
    return [modelo backgroundColor];
}
- (void)showPreferences:(id)sender{
    if(!preferenceWindow)
        preferenceWindow=[[PreferencesWindow alloc]init];
    preferenceWindow.modelo=modelo;
    [preferenceWindow showWindow:self];
}
-(void) handleReloadImage:(NSNotification *)notification{
    preferenceWindow.currentView=chartView;
}
-(void) handleDrawGraphic:(NSNotification *)notification{
    //NSLog(@"Me ha llegado la notificacion");
    [chartView setNeedsDisplay:true];
}


-(void)drawPolynomialsInBounds:(NSRect)bounds withGC:(NSGraphicsContext *)context{
    //NSLog(@"RRTOLLL");
    //[self drawChartWithRect:bounds withGC:context];
    for(Ecuation *e in [modelo drawedEquations]){
        [e drawInRect:bounds withGraphicsContext:context withFuncRect:[modelo funcRect] withHops:[modelo hops]];
    }
}
-(NSRect)getFuncRect{
    return [modelo funcRect];
}
-(BOOL)windowShouldClose:(NSWindow *)sender{
    NSInteger response;
    response= NSRunAlertPanel(@"Cuidado",
                              @"¿Estas seguro de que quieres cerrar la aplicación?",
                              @"Si",
                              @"No",nil);
    if(response == NSAlertDefaultReturn)
        return true;
    else
        return false;
}
-(void)setFuncRect:(NSRect)funcRect{
    
    [modelo setFuncRect:funcRect];
    NSLog(@"RECT: %.2f__%.2f_____%.2f__%.2f",funcRect.origin.x, funcRect.origin.y, funcRect.size.width, funcRect.size.height);
    [preferenceWindow updateXandYValues];
    [preferenceWindow recalculateWidths];
    [chartView setNeedsDisplay:true];
}
-(void)zoomOut:(id)sender{
    NSRect current=[modelo funcRect];
    [modelo setFuncRect:NSMakeRect(current.origin.x*2, current.origin.y*2, current.size.width*2, current.size.height*2)];
    [preferenceWindow updateXandYValues];
    [chartView setNeedsDisplay:true];
}
-(void)zoomIn:(id)sender{
    /*NSRect current=[modelo funcRect];
    [modelo setFuncRect:NSMakeRect((float)current.origin.x/2, (float)current.origin.y/2, (float)current.size.width/2, (float)current.size.height/2)];
    [preferenceWindow updateXandYValues];
    [chartView setNeedsDisplay:true];*/
    
    
}
-(bool)isNumbersEnabled{return[modelo numbers];}
-(bool)isGridEnabled{return[modelo grid];}
-(bool)isTickMarksEnabled{return[modelo tickMarks];}
-(float)getWidthOfGridLine{return [modelo getWidthOfGridLine];}
-(float)getTextSize{return [modelo getTextSize];}
-(int)getHops{return [modelo hops];}
-(float)getXOffsetForNumbers{return [modelo getXOffsetForNumbers];}
-(float)getYOffsetForNumbers{return [modelo getYOffsetForNumbers];}
-(float)getStepValue{return [modelo getStepValue];}
@end

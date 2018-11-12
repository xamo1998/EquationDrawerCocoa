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
    if(self){
        NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(handleDrawGraphic:)
                       name:DrawGraphicNotification
                     object:nil];
        [center addObserver:self
                   selector:@selector(handleReloadImage:)
                       name:ReloadImageViewNotification
                     object:nil];
        modelo=[[Model alloc]init];
    }
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

-(void) handleDrawGraphic:(NSNotification *)notification{
    [chartView setNeedsDisplay:true];
}


-(void)drawPolynomialsInBounds:(NSRect)bounds withGC:(NSGraphicsContext *)context{
    for(Equation *e in [modelo drawedEquations]){
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
    [preferenceWindow updateXandYValues];
    [preferenceWindow recalculateWidths];
    [chartView setNeedsDisplay:true];
}
-(void)zoomOut:(id)sender{
    NSRect current=[modelo funcRect];
    [modelo setFuncRect:NSMakeRect(current.origin.x*2, current.origin.y*2, current.size.width*2, current.size.height*2)];
    [modelo setHops:[modelo hops]*1.50];
    [preferenceWindow updateXandYValues];
    [chartView setNeedsDisplay:true];
}
-(void)zoomIn:(id)sender{
    NSRect current=[modelo funcRect];
    [modelo setFuncRect:NSMakeRect((float)current.origin.x/2, (float)current.origin.y/2, (float)current.size.width/2, (float)current.size.height/2)];
    [modelo setHops:[modelo hops]/0.75];
    [preferenceWindow updateXandYValues];
    [chartView setNeedsDisplay:true];
    
    
}
-(bool)isGridEnabled{return[modelo grid];}
-(bool)isTickMarksEnabled{return[modelo tickMarks];}
-(float)getWidthOfGridLine{return [modelo getWidthOfGridLine];}
-(int)getHops{return [modelo hops];}
@end

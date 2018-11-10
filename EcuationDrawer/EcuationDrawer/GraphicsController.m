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
-(void)setFuncRect:(NSRect)funcRect{
    
    [modelo setFuncRect:funcRect];
    [preferenceWindow updateXandYValues];
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
    
    NSView *view=chartView;
    NSBitmapImageRep *rep=[view bitmapImageRepForCachingDisplayInRect:[view bounds]];
    [view cacheDisplayInRect:[view bounds] toBitmapImageRep:rep];
    //NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"yourfilename.dat"];
    NSArray *array= NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, true);
    NSLog([array objectAtIndex:0]);
    //NSFileManager *fileManager =[[NSFileManager alloc]init];
    NSData *data = [rep representationUsingType:NSPNGFileType  properties:nil];
    [data writeToFile:[NSString stringWithFormat:@"/Users/%@/Documents/view_fecha.png",NSUserName()] atomically:true];
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

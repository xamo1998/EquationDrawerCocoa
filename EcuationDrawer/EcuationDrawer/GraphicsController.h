//
//  GraphicsController.h
//  EcuationDrawer
//
//  Created by Alumno on 23/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PreferencesWindow.h"
#import "Math/EquationParser.h"
#import "Math/EquationSolver.h"
#import "Chart.h"
@class Chart;
@interface GraphicsController : NSObject<NSWindowDelegate>{
    PreferencesWindow *preferenceWindow;
    Modelo *modelo;
    IBOutlet Chart *chartView;
}
-(NSRect)getFuncRect;
-(void)setFuncRect:(NSRect)funcRect;
-(IBAction)zoomIn:(id)sender;
-(IBAction)zoomOut:(id)sender;
-(IBAction)showPreferences:(id)sender;
-(void)drawPolynomialsInBounds:(NSRect)bounds withGC:(NSGraphicsContext *)context;
-(float)getWidthOfGraphicsLine;
-(float)getWidthOfGridLine;
-(float)getTextSize;
-(bool)isNumbersEnabled;
-(bool)isGridEnabled;
-(bool)isTickMarksEnabled;
-(float)getXOffsetForNumbers;
-(float)getYOffsetForNumbers;
-(float)getStepValue;
-(int)getHops;
-(NSColor *)getBackgroundColor;
@end

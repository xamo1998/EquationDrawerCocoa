//
//  PreferencesWindow.h
//  EcuationDrawer
//
//  Created by Alumno on 23/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Model.h"
#import "Equation.h"
@class Equation;
@class Model;
@interface PreferencesWindow : NSWindowController<NSComboBoxDataSource,
                                                  NSComboBoxDelegate,
                                                  NSTableViewDataSource,
                                                  NSTableViewDelegate>{
    NSNotificationCenter *notificationCenter;
    NSMutableArray *termValues, *termsValuesInterpeterWindow;
    IBOutlet NSSlider *widthSlider;
    IBOutlet NSComboBox *ecuationComboBox, *fileFormatComboBox;
    IBOutlet NSButtonCell *grid, *numbers, *tickNumbers;
    IBOutlet NSTextField *nameTextField, *counterInterpeterWindow, *equationTextField, *nameTextFieldInterpeterWindow, *nameTextFieldPreferences;
    IBOutlet NSTextField *xStart, *yStart, *xEnd, *yEnd;
    IBOutlet NSButton *addGraphicButton,*removeGraphicButton,*drawGraphicButton, *moveToRight, *moveToLeft, *addInterpeterWindow,*removeGraphicButtonInterpeterWindow,*drawGraphicButtonInterpeterWindow,
        *moveToRightInterpeterWindow, *moveToLeftInterpeterWindow;
    IBOutlet NSColorWell *colorWell, *colorWellInterpeterWindow, *backgroundColor, *functionColorWell;
    IBOutlet NSTableView *ecuationTableView,*paramsTableView, *drawedEquations, *paramsInterpeterWindow, *equationsInterpeterWindow,*drawedEquationsInterpeterWindow,
                                                      *allEquationsTableView;
                                                      
}
@property Model *modelo;
@property NSView *currentView;
-(void)updateXandYValues;
-(void)recalculateWidths;
-(bool)checkCorrectEquation;

-(IBAction)addGraphic:(id)sender;
-(IBAction)visualPropertyListener:(id)sender;
-(IBAction)nameVisualPreferenceEditTextListener:(id)sender;
-(IBAction)representationValueListener:(id)sender;
-(IBAction)removeGraphic:(id)sender;
-(IBAction)drawGraphic:(id)sender;
-(IBAction)sendToLeft:(id)sender;
-(IBAction)sendToRight:(id)sender;
-(IBAction)exportImage:(id)sender;
-(IBAction)customParamsEditTextListener:(id)sender;
-(IBAction)changeColorListener:(id)sender;
-(IBAction)addGraphicInterpeterWindow:(id)sender;
-(IBAction)widthSliderListener:(id)sender;
-(IBAction)qualitySliderListener:(id)sender;
@end

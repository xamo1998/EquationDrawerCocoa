//
//  PreferencesWindow.h
//  EcuationDrawer
//
//  Created by Alumno on 23/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Modelo.h"
#import "Ecuation.h"
@class Ecuation;
@class Modelo;
@interface PreferencesWindow : NSWindowController<NSComboBoxDataSource,
                                                  NSComboBoxDelegate,
                                                  NSTableViewDataSource,
                                                  NSTableViewDelegate>{
    NSMutableArray *termValues;
    IBOutlet NSComboBox *ecuationComboBox;
    IBOutlet NSTextField *nameTextField;
    IBOutlet NSButton *addGraphicButton,*removeGraphicButton,*drawGraphicButton;
    IBOutlet NSColorWell *colorWell;
    IBOutlet NSTableView *ecuationTableView,*paramsTableView;
                                                      
}
@property Modelo *modelo;
-(IBAction)addGraphic:(id)sender;
-(IBAction)removeGraphic:(id)sender;
-(IBAction)drawGraphic:(id)sender;
@end

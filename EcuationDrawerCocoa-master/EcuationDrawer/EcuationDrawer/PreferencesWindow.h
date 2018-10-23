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
    
    IBOutlet NSComboBox *ecuationComboBox;
    IBOutlet NSTextField *paramATextField,*paramBTextField,*nameTextField;
    IBOutlet NSButton *addGraphicButton,*removeGraphicButton;
    IBOutlet NSColorWell *colorWell;
    IBOutlet NSTableView *ecuationTableView;
                                                      
}
@property Modelo *modelo;
-(IBAction)addGraphic:(id)sender;
-(IBAction)removeGraphic:(id)sender;

@end

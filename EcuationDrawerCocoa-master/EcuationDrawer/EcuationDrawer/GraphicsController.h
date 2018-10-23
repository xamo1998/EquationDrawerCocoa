//
//  GraphicsController.h
//  EcuationDrawer
//
//  Created by Alumno on 23/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PreferencesWindow.h"
@class PreferencesWindow;
@interface GraphicsController : NSObject{
    PreferencesWindow *preferenceWindow;
    Modelo *modelo;
}

-(IBAction)showPreferences:(id)sender;

@end

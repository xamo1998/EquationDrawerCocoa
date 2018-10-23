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

-(id)init{
    self=[super init];
    if(!self){
        
    }
    modelo=[[Modelo alloc]init];
    return self;
}

- (void)showPreferences:(id)sender{
    if(!preferenceWindow)
        preferenceWindow=[[PreferencesWindow alloc]init];
    preferenceWindow.modelo=modelo;
    [preferenceWindow showWindow:self];
}

@end

//
//  PreferencesWindow.m
//  EcuationDrawer
//
//  Created by Alumno on 23/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "PreferencesWindow.h"

@interface PreferencesWindow ()

@end

@implementation PreferencesWindow
@synthesize modelo;
- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(id)init{
    self=[super initWithWindowNibName:@"PreferencesWindow"];
    if(!self){
        
    }
    
    
    return self;
}

//Button Listeners
-(void)addGraphic:(id)sender{
    Ecuation *ecuation= [[Ecuation alloc]init];
    ecuation.name=[nameTextField stringValue];
    ecuation.color=[colorWell color];
    ecuation.ecuation=@"a*x + b*y";
    [[modelo ecuations]addObject:ecuation];
    [ecuationTableView reloadData];
    
}

//TableView Methods...

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return[[modelo ecuations]count];
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if([[tableView tableColumns]indexOfObject:tableColumn]==2){
        [cell setBackgroundColor:[[[modelo ecuations]objectAtIndex:row]color]];
    }
    [cell setDrawsBackground:YES];
}
-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if([[tableView tableColumns]indexOfObject:tableColumn]==0)//Name
        return [[[modelo ecuations]objectAtIndex:row]name];
    else if([[tableView tableColumns]indexOfObject:tableColumn]==1)
        return [[[modelo ecuations]objectAtIndex:row]ecuation];
    return NULL;
}

//Checks...
-(void)controlTextDidChange:(NSNotification *)obj{
    [self checkCorrectGraphic];
}

-(void) checkCorrectGraphic{
    if([paramATextField isEnabled] && [paramBTextField isEnabled]){ //Dos activados
        if([[paramATextField stringValue]length]>0 &&
           [[paramBTextField stringValue]length]>0 &&
           [[nameTextField stringValue]length]>0)
            [addGraphicButton setEnabled:YES];
        else
            [addGraphicButton setEnabled:NO];
    }else if([paramATextField isEnabled]){
        if([[paramATextField stringValue]length]>0 &&
           [[nameTextField stringValue]length]>0)
            [addGraphicButton setEnabled:YES];
        else
            [addGraphicButton setEnabled:NO];
    }else{
        if([[paramBTextField stringValue]length]>0 &&
           [[nameTextField stringValue]length]>0)
            [addGraphicButton setEnabled:YES];
        else
            [addGraphicButton setEnabled:NO];
    }
}


//ComboBox Methods...
-(void)comboBoxSelectionDidChange:(NSNotification *)notification{
    if([ecuationComboBox indexOfSelectedItem]<0){
        [paramATextField setStringValue:@""];
        [paramBTextField setStringValue:@""];
        [paramATextField setEnabled:NO];
        [paramBTextField setEnabled:NO];
    }else{
        NSInteger index=[ecuationComboBox indexOfSelectedItem];
        if([[[modelo ecuationTitles]objectAtIndex:index]containsString:@"a"]){
            [paramATextField setEnabled:YES];
        }
        else{
            [paramATextField setStringValue:@""];
            [paramATextField setEnabled:NO];
        }
        if([[[modelo ecuationTitles]objectAtIndex:index]containsString:@"b"]){
            [paramBTextField setEnabled:YES];
        }
        else{
            [paramBTextField setStringValue:@""];
            [paramBTextField setEnabled:NO];
        }
    }
    [self checkCorrectGraphic];
}



-(NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox{
    return [[modelo ecuationTitles]count];
}

-(id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index{
    return [[modelo ecuationTitles]objectAtIndex:index];
}

@end

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
    termValues=[[NSMutableArray alloc]init];
    
    return self;
}

//Button Listeners

-(void)drawGraphic:(id)sender{
    NSInteger index=[ecuationComboBox indexOfSelectedItem];
    EcuationData *data=[[modelo ecuationData]objectAtIndex:index];
}
-(void)removeGraphic:(id)sender{
    NSInteger index=[ecuationTableView selectedRow];
    [[modelo ecuations]removeObjectAtIndex:index];
    [ecuationTableView reloadData];
}
-(void)addGraphic:(id)sender{
    NSInteger indexComboBox=[ecuationComboBox indexOfSelectedItem];
    Ecuation *ecuation= [[Ecuation alloc]init];
    //Poner color!
    EcuationData *data=[[modelo ecuationData]objectAtIndex:indexComboBox];
    data.color=[colorWell color];
    data.displayName=[nameTextField stringValue];
    ecuation.ecuationData=data;
    //ecuation.name=[nameTextField stringValue];
    //ecuation.color=[colorWell color];
    //ecuation.ecuation=[[[modelo ecuationData]objectAtIndex:indexComboBox]getCustomizedName:termValues];
    [[modelo ecuations]addObject:ecuation];
    [colorWell setColor:[self getRandomColor]];
    [ecuationTableView reloadData];
    
}

-(NSColor *)getRandomColor{
    float red, blue, green;
    red=random()%128/128.0;
    blue=random()%128/128.0;
    green=random()%128/128.0;
    return [NSColor colorWithSRGBRed:red green:green blue:blue alpha:1.0];
}
//TableView Methods...

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    if(tableView==paramsTableView){
        NSInteger index=[ecuationComboBox indexOfSelectedItem];
        if(index>=0){
            return[[[modelo ecuationData]objectAtIndex:index]termCount];
        }
    }
    if(tableView==ecuationTableView)return[[modelo ecuations]count];
    return 0;
}
-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    if([notification object]==ecuationTableView){
        if([ecuationTableView selectedRow]<0){
            [removeGraphicButton setEnabled:NO];
            return;
        }
        [removeGraphicButton setEnabled:YES];
        
    }
}
-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if(tableView==ecuationTableView){
        if([[tableView tableColumns]indexOfObject:tableColumn]==2){
            Ecuation *ecuation=[[modelo ecuations]objectAtIndex:row];
            [cell setBackgroundColor:[[ecuation ecuationData]color]];
        }
        [cell setDrawsBackground:YES];
    }
    
}
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    [termValues addObject:[NSString stringWithFormat:@"%d",[object integerValue]]];
    [paramsTableView reloadData];
    [self checkCorrectGraphic];
}
-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if(tableView==paramsTableView){
        if([[paramsTableView tableColumns]indexOfObject:tableColumn]==1) //Si es la columna de los parametros
            if([termValues count]<=row) //Puede estar vacio...
                return @"";
            else{//Devolvemos el valor del parametro que toque
                return [termValues objectAtIndex:row]; //Devolvemos el value de key=termName.
            }
        //Param Name values
        
        NSInteger index = [ecuationComboBox indexOfSelectedItem];
        EcuationData *data=[[modelo ecuationData]objectAtIndex:index];
        return [[data terms]objectAtIndex:row];
    }else{
        EcuationData *data=[[[modelo ecuations]objectAtIndex:row]ecuationData];
        if([[tableView tableColumns]indexOfObject:tableColumn]==0)//Name
            return [data displayName];
        else if([[tableView tableColumns]indexOfObject:tableColumn]==1)
            return [data getCustomizedName:termValues];
        return NULL;
    }
    
    return NULL;
    
}

//Checks...

-(void)controlTextDidChange:(NSNotification *)obj{
    [self checkCorrectGraphic];
}

-(void) checkCorrectGraphic{
    NSInteger indexComboBox=[ecuationComboBox indexOfSelectedItem];

    if(indexComboBox>=0 &&
       [[nameTextField stringValue]length]>0 &&
       [termValues count]==[[[modelo ecuationData]objectAtIndex:indexComboBox]termCount]){
        NSLog([nameTextField stringValue]);
        [addGraphicButton setEnabled:YES];
    }else
        [addGraphicButton setEnabled:NO];
    
}


//ComboBox Methods...
-(void)comboBoxSelectionDidChange:(NSNotification *)notification{
    NSInteger index=[ecuationComboBox indexOfSelectedItem];
    if(index>=0){
        [termValues removeAllObjects];
        [paramsTableView reloadData];
        [self checkCorrectGraphic];
    }
}



-(NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox{
    return [[modelo ecuationData]count];
}

-(id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index{
    return [[[modelo ecuationData]objectAtIndex:index]name];
}

@end

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
-(void)addGraphic:(id)sender{
    NSInteger indexComboBox=[ecuationComboBox indexOfSelectedItem];
    Ecuation *ecuation= [[Ecuation alloc]init];
    ecuation.name=[nameTextField stringValue];
    ecuation.color=[colorWell color];
    ecuation.ecuation=[[[modelo ecuationData]objectAtIndex:indexComboBox]getCustomizedName:termValues];
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

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if(tableView==ecuationTableView){
        if([[tableView tableColumns]indexOfObject:tableColumn]==2){
            [cell setBackgroundColor:[[[modelo ecuations]objectAtIndex:row]color]];
        }
        [cell setDrawsBackground:YES];
    }
    
}
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSInteger index = [ecuationComboBox indexOfSelectedItem];
    EcuationData *data=[[modelo ecuationData]objectAtIndex:index];//Recogemos los datos del combo box seleccionado
    NSString *termName=[[data terms]objectAtIndex:row]; //Recogemos el nombre del termino
    float termValue=[object floatValue]; // recogemos el valor que quiere dar el usuario
    NSDictionary *dictionary = @{termName : [NSNumber numberWithFloat:termValue]}; //Diccionario tipo: 'A';23
    
    [termValues addObject:dictionary];
    [paramsTableView reloadData];
    [self checkCorrectGraphic];
}
-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if(tableView==paramsTableView){
        if([[paramsTableView tableColumns]indexOfObject:tableColumn]==1) //Si es la columna de los parametros
            if([termValues count]<=row) //Puede estar vacio...
                return @"";
            else{//Devolvemos el valor del parametro que toque
                NSInteger index = [ecuationComboBox indexOfSelectedItem];
                EcuationData *data=[[modelo ecuationData]objectAtIndex:index]; //Recogemos el Data
                NSString *termName=[[data terms]objectAtIndex:row]; //Recogemos el term que ha modificado
                return [termValues valueForKey:termName]; //Devolvemos el value de key=termName.
            }
        //Param Name values
        
        NSInteger index = [ecuationComboBox indexOfSelectedItem];
        EcuationData *data=[[modelo ecuationData]objectAtIndex:index];
        NSLog(@"Voy a meter el parametro: %@",[data terms]);
        return [[data terms]objectAtIndex:row];
    }else{
        if([[tableView tableColumns]indexOfObject:tableColumn]==0)//Name
            return [[[modelo ecuations]objectAtIndex:row]name];
        else if([[tableView tableColumns]indexOfObject:tableColumn]==1)
            return [[[modelo ecuations]objectAtIndex:row]ecuation];
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

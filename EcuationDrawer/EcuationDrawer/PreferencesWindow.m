//
//  PreferencesWindow.m
//  EcuationDrawer
//
//  Created by Alumno on 23/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "PreferencesWindow.h"
#define ERROR -99999999
@interface PreferencesWindow ()

@end

@implementation PreferencesWindow
@synthesize modelo;

NSString * DrawGraphicNotification = @"DrawGraphicNotification";

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(id)init{
    self=[super initWithWindowNibName:@"PreferencesWindow"];
    if(!self){
        
    }
    NSLog(@"LOG(2.7118)=%f :::::::: Log2(2.7118)=%f :::::::: Log10(2.7118)=%f",logf(2.7118), log2(2.7178), log10(2.7118));
    notificationCenter=[NSNotificationCenter defaultCenter];
    //NSLog(@"", [image stri]);
    [imageView setImage:_image];
    termValues=[[NSMutableArray alloc]init];
    termsValuesInterpeterWindow=[[NSMutableArray alloc]init];
    return self;
}

//Button Listeners

-(void)drawGraphic:(id)sender{
    
    [notificationCenter postNotificationName:DrawGraphicNotification object:self];
    
}
-(void)nameVisualPreferenceEditTextListener:(id)sender{
    if([allEquationsTableView selectedRow]>=0){
        Ecuation *equation;
        if((int)[allEquationsTableView selectedRow]>((int)[[modelo ecuations]count]-1)){
            equation=[[modelo drawedEquations]objectAtIndex: [allEquationsTableView selectedRow]-[[modelo ecuations]count]];
        }else{
            equation=[[modelo ecuations]objectAtIndex:[allEquationsTableView selectedRow]];
        }
        [equation setName:[sender stringValue]];
        [ecuationTableView reloadData];
        [drawedEquations reloadData];
        [drawedEquationsInterpeterWindow reloadData];
        [equationsInterpeterWindow reloadData];
        [allEquationsTableView reloadData];
    }
}
-(void)widthSliderListener:(id)sender{
    if([allEquationsTableView selectedRow]>=0){
        Ecuation *equation;
        if((int)[allEquationsTableView selectedRow]>((int)[[modelo ecuations]count]-1)){
            equation=[[modelo drawedEquations]objectAtIndex: [allEquationsTableView selectedRow]-[[modelo ecuations]count]];
        }else{
            equation=[[modelo ecuations]objectAtIndex:[allEquationsTableView selectedRow]];
        }
        [equation setLineWidth:[sender floatValue]];
        [notificationCenter postNotificationName:DrawGraphicNotification object:self]; //Improve solo si está dibujada
    }
    
    
}

-(void)removeGraphic:(id)sender{
    NSInteger indexEquations, indexDrawedEquations;
    if(sender==removeGraphicButton){
        indexEquations=[ecuationTableView selectedRow];
        indexDrawedEquations=[drawedEquations selectedRow];
    }else{
        indexEquations=[equationsInterpeterWindow selectedRow];
        indexDrawedEquations=[drawedEquationsInterpeterWindow selectedRow];
    }
    if(indexEquations!=-1){
        [[modelo ecuations]removeObjectAtIndex:indexEquations];
        [ecuationTableView reloadData];
        [equationsInterpeterWindow reloadData];
    }
    if(indexDrawedEquations!=-1){
        [[modelo drawedEquations]removeObjectAtIndex:indexDrawedEquations];
        [drawedEquations reloadData];
        [drawedEquationsInterpeterWindow reloadData];
    }
    
}

- (void)addGraphicInterpeterWindow:(id)sender{
    NSLog(@"ADDED11111");
    NSMutableArray *paramsArray=[[NSMutableArray alloc]init];
    NSInteger numberOfParams=[counterInterpeterWindow integerValue];
    for(char a='a'; a<'w'; a++){
        if(a!='f' && a!='g' && a!='h' && numberOfParams!=0){
            numberOfParams--;
            NSLog(@"HAY %d",numberOfParams);
            [paramsArray addObject:[NSString stringWithFormat:@"%c",a]];
        }
    }
    NSLog(@"MY EQUATION: %@",[nameTextFieldInterpeterWindow stringValue]);
    Ecuation *equation=[[Ecuation alloc]initWithEquationToSolve:[equationTextField stringValue] withParams:paramsArray withParamValues:termsValuesInterpeterWindow];
    EquationParser *parser=[[EquationParser alloc]initWithEquationToSolve:[equationTextField stringValue] withTermValues:termsValuesInterpeterWindow withTerm:paramsArray];
    NSString *displayName=[[NSString alloc]init];
    for(int i=0; i<[[parser equationSplitted]count];i++){
        displayName=[displayName stringByAppendingString:[[parser equationSplitted]objectAtIndex:i]];
    }
    [equation setDisplayName:displayName];
    [equation setColor:[colorWellInterpeterWindow color]];
    [equation setName:[nameTextFieldInterpeterWindow stringValue]];
    [[modelo ecuations]addObject:equation];
    [colorWellInterpeterWindow setColor:[self getRandomColor]];
    [equationsInterpeterWindow reloadData];
    NSLog(@"ADDED");
}

-(void)addGraphic:(id)sender{
    NSInteger indexComboBox=[ecuationComboBox indexOfSelectedItem];
    
    //Poner color!
    EcuationData *data=[[modelo ecuationData]objectAtIndex:indexComboBox];
    Ecuation *ecuation= [[Ecuation alloc]initWithEquationToSolve:[data name] withParams:[data terms] withParamValues:termValues];
    [ecuation setColor:[colorWell color]];
    [ecuation setName:[nameTextField stringValue]];
    [ecuation setDisplayName:[data getCustomizedName:termValues]];
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
    NSLog(@"ADDED11");
    if(tableView==paramsInterpeterWindow)
        return [counterInterpeterWindow integerValue];
    NSLog(@"ADDED22");
    if(tableView==ecuationTableView || tableView==equationsInterpeterWindow)return[[modelo ecuations]count];
    NSLog(@"ADDED33");
    if(tableView==drawedEquations || tableView==drawedEquationsInterpeterWindow)return[[modelo drawedEquations]count];
    if(tableView==allEquationsTableView) return[[modelo ecuations]count]+[[modelo drawedEquations]count];
    return 0;
}

- (void)representationValueListener:(id)sender{
    if([[xEnd stringValue]length] > 0 && [[yEnd stringValue]length] > 0 && [[xStart stringValue]length] > 0 && [[yStart stringValue]length] > 0){
        [modelo setFuncRect: NSMakeRect([xStart floatValue], [yStart floatValue], abs([xStart floatValue])+abs([xEnd floatValue]),abs([yStart floatValue])+abs([yEnd floatValue]))];
        [notificationCenter postNotificationName:DrawGraphicNotification object:self];
    }
}
-(void)customParamsEditTextListener:(id)sender{
    if([counterInterpeterWindow integerValue]>=0 && [counterInterpeterWindow integerValue]<15){
        NSLog(@"VALOR: %d",[counterInterpeterWindow integerValue]);
        [termsValuesInterpeterWindow removeAllObjects];
        for(int i=0; i<[counterInterpeterWindow integerValue]; i++){
            [termsValuesInterpeterWindow addObject:@""];
        }
        [equationTextField setStringValue:@""];
        if([counterInterpeterWindow integerValue]==0)
            [equationTextField setEnabled:true];
        else
            [equationTextField setEnabled:false];
        [paramsInterpeterWindow reloadData];
    }
    
}
-(void)updateXandYValues{
    NSRect rect=[modelo funcRect];
    [xStart setStringValue:[NSString stringWithFormat:@"%.2f",rect.origin.x]];
    [yStart setStringValue:[NSString stringWithFormat:@"%.2f",rect.origin.y]];
    [xEnd setStringValue:[NSString stringWithFormat:@"%.2f",rect.size.width-abs(rect.origin.x)]];
    [yEnd setStringValue:[NSString stringWithFormat:@"%.2f",rect.size.height-abs(rect.origin.y)]];
}
-(void)visualPropertyListener:(id)sender{
    if(sender==grid)
        //if([grid state]==){
         //   [modelo setGrid:t]
        //} [modelo setGrid:false];
    if(sender==tickNumbers)
        [modelo setTickMarks:[tickNumbers state]];
    if(sender==numbers)
        [modelo setNumbers:[numbers state]];
    NSLog(@"GRID:%",[grid isEnabled]);
    [notificationCenter postNotificationName:DrawGraphicNotification object:self];
}
-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    if([notification object]==ecuationTableView){
        if([ecuationTableView selectedRow]<0){
            [removeGraphicButton setEnabled:NO];
            [removeGraphicButtonInterpeterWindow setEnabled:false];
            [moveToLeft setEnabled:false];
            [moveToRight setEnabled:false];
            [moveToLeftInterpeterWindow setEnabled:false];
            [moveToRightInterpeterWindow setEnabled:false];
            //[drawGraphicButton setEnabled:NO];
            return;
        }
        [moveToRight setEnabled:true];
        [moveToRightInterpeterWindow setEnabled:true];
        [removeGraphicButton setEnabled:YES];
        [removeGraphicButtonInterpeterWindow setEnabled:true];
        //[drawGraphicButton setEnabled:YES];
        
    }else if([notification object]==drawedEquations){
        if([drawedEquations selectedRow]<0){
            [removeGraphicButton setEnabled:NO];
            [removeGraphicButtonInterpeterWindow setEnabled:false];
            [moveToLeft setEnabled:false];
            [moveToRight setEnabled:false];
            [moveToLeftInterpeterWindow setEnabled:false];
            [moveToRightInterpeterWindow setEnabled:false];
            //[drawGraphicButton setEnabled:NO];
            return;
        }
        [moveToLeft setEnabled:true];
        [moveToLeftInterpeterWindow setEnabled:true];
        [removeGraphicButton setEnabled:YES];
        [removeGraphicButtonInterpeterWindow setEnabled:true];
        //[drawGraphicButton setEnabled:YES];
    }else if([notification object]==equationsInterpeterWindow){
        if([equationsInterpeterWindow selectedRow]<0){
            [removeGraphicButton setEnabled:NO];
            [removeGraphicButtonInterpeterWindow setEnabled:false];
            [moveToLeft setEnabled:false];
            [moveToRight setEnabled:false];
            [moveToLeftInterpeterWindow setEnabled:false];
            [moveToRightInterpeterWindow setEnabled:false];
            //[drawGraphicButton setEnabled:NO];
            return;
        }
        [moveToRight setEnabled:true];
        [moveToRightInterpeterWindow setEnabled:true];
        [removeGraphicButton setEnabled:YES];
        [removeGraphicButtonInterpeterWindow setEnabled:true];
        //[drawGraphicButton setEnabled:YES];
        
    }else if([notification object]==drawedEquationsInterpeterWindow){
        if([drawedEquationsInterpeterWindow selectedRow]<0){
            [removeGraphicButton setEnabled:NO];
            [removeGraphicButtonInterpeterWindow setEnabled:false];
            [moveToLeft setEnabled:false];
            [moveToRight setEnabled:false];
            [moveToLeftInterpeterWindow setEnabled:false];
            [moveToRightInterpeterWindow setEnabled:false];
            //[drawGraphicButton setEnabled:NO];
            return;
        }
        [moveToLeft setEnabled:true];
        [moveToLeftInterpeterWindow setEnabled:true];
        [removeGraphicButton setEnabled:YES];
        [removeGraphicButtonInterpeterWindow setEnabled:true];
        //[drawGraphicButton setEnabled:YES];
    }else if([notification object]==allEquationsTableView){
        if([allEquationsTableView selectedRow]>=0){
            [functionColorWell setEnabled:true];
            [nameTextFieldPreferences setEnabled:true];
            [widthSlider setEnabled:true];
            
            Ecuation *equation;
            NSLog(@"SELECTED: %d, COUNT:%d",[allEquationsTableView selectedRow],([[modelo ecuations]count]-1));
            if((int)[allEquationsTableView selectedRow]>((int)[[modelo ecuations]count]-1)){
                NSLog(@"aaaaa");
                equation=[[modelo drawedEquations]objectAtIndex: [allEquationsTableView selectedRow]-[[modelo ecuations]count]];
            }else{
                equation=[[modelo ecuations]objectAtIndex:[allEquationsTableView selectedRow]];
            }
            [functionColorWell setColor:[equation color]];
            [widthSlider setFloatValue:[equation lineWidth]];
            [nameTextFieldPreferences setStringValue:[equation name]];
        }else{
            [functionColorWell setEnabled:false];
            [nameTextFieldPreferences setEnabled:false];
            [widthSlider setEnabled:false];
        }
    }
}
-(void)changeColorListener:(id)sender{
    if(sender==backgroundColor){
        [modelo setBackgroundColor:[backgroundColor color]];
        [notificationCenter postNotificationName:DrawGraphicNotification object:self];
        return;
    }
    Ecuation *equation;
    if([allEquationsTableView selectedRow]>(int)[[modelo ecuations]count]-1){
        equation=[[modelo drawedEquations]objectAtIndex: [allEquationsTableView selectedRow]-[[modelo ecuations]count]];
    }else{
        equation=[[modelo ecuations]objectAtIndex:[allEquationsTableView selectedRow]];
    }
    [equation setColor:[functionColorWell color]];
    [ecuationTableView reloadData];
    [equationsInterpeterWindow reloadData];
    [drawedEquations reloadData];
    [drawedEquationsInterpeterWindow reloadData];
    [allEquationsTableView reloadData];
    [notificationCenter postNotificationName:DrawGraphicNotification object:self];
}

- (void)sendToLeft:(id)sender{
    NSInteger row;
    if(sender==moveToLeftInterpeterWindow)
        row=[drawedEquationsInterpeterWindow selectedRow];
    else
        row=[drawedEquations selectedRow];
    [[modelo ecuations]addObject:[[modelo drawedEquations]objectAtIndex:row]];
    [[modelo drawedEquations]removeObjectAtIndex:row];
    [ecuationTableView reloadData];
    [equationsInterpeterWindow reloadData];
    [drawedEquationsInterpeterWindow reloadData];
    [drawedEquations reloadData];
    if([[modelo drawedEquations]count]==0){
        //NSLog(@"Hay %d elementos...",[[modelo drawedEquations]count]);
        [drawGraphicButton setEnabled:false];
        [drawGraphicButtonInterpeterWindow setEnabled:false];
    }
    [notificationCenter postNotificationName:DrawGraphicNotification object:self];
}
- (void)sendToRight:(id)sender{
    NSInteger row;
    if(sender==moveToRightInterpeterWindow)
        row=[equationsInterpeterWindow selectedRow];
    else
        row=[ecuationTableView selectedRow];
    [[modelo drawedEquations]addObject:[[modelo ecuations]objectAtIndex:row]];
    [[modelo ecuations]removeObjectAtIndex:row];
    [ecuationTableView reloadData];
    [drawedEquations reloadData];
    [equationsInterpeterWindow reloadData];
    [drawedEquationsInterpeterWindow reloadData];
    [drawGraphicButton setEnabled:true];
    [drawGraphicButtonInterpeterWindow setEnabled:true];
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if(tableView==ecuationTableView || tableView==equationsInterpeterWindow){
        if([[tableView tableColumns]indexOfObject:tableColumn]==2){
            Ecuation *ecuation=[[modelo ecuations]objectAtIndex:row];
            [cell setBackgroundColor:[ecuation color]];
        }
        [cell setDrawsBackground:YES];
    }else if(tableView==drawedEquations || tableView==drawedEquationsInterpeterWindow){
        if([[tableView tableColumns]indexOfObject:tableColumn]==2){
            Ecuation *ecuation=[[modelo drawedEquations]objectAtIndex:row];
            [cell setBackgroundColor:[ecuation color]];
        }
        [cell setDrawsBackground:YES];
    }else if(tableView==allEquationsTableView){
        NSInteger countEquations, countDrawedEquations;
        countEquations=[[modelo ecuations]count];
        if([[tableView tableColumns]indexOfObject:tableColumn]==2){
            Ecuation *equation;
            if(row>countEquations-1){
                equation=[[modelo drawedEquations]objectAtIndex:row-countEquations];
            }else{
                equation=[[modelo ecuations]objectAtIndex:row];
            }
            [cell setBackgroundColor:[equation color]];
            
        }
        [cell setDrawsBackground:true];
    }
    
}


- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    //Comprovación de tabla
    if(tableView==paramsTableView){
        [termValues removeObjectAtIndex:row];
        [termValues insertObject:[NSString stringWithFormat:@"%d",[object integerValue]] atIndex:row];
        [paramsTableView reloadData];
        [self checkCorrectGraphic];
    }else if(tableView==paramsInterpeterWindow){
        [termsValuesInterpeterWindow removeObjectAtIndex:row];
        [termsValuesInterpeterWindow insertObject:[NSString stringWithFormat:@"%d",[object integerValue]] atIndex:row];
        [paramsInterpeterWindow reloadData];
        int counter=0;
        for(int i=0; i<[termsValuesInterpeterWindow count]; i++){
            if(![[termsValuesInterpeterWindow objectAtIndex:i]isEqualTo:@""]){
                counter++;
            }
        }
        counter==[termsValuesInterpeterWindow count] ? [equationTextField setEnabled:true] : [equationTextField setEnabled:false];
            
    }
}
-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    //NSLog(@"HOLAAA66666");
    
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
    }else if(tableView==ecuationTableView || tableView==equationsInterpeterWindow){
        Ecuation *ecuation=[[modelo ecuations]objectAtIndex:row];
        if([[tableView tableColumns]indexOfObject:tableColumn]==0)//Name
            return [ecuation name];
        else if([[tableView tableColumns]indexOfObject:tableColumn]==1)
            return [ecuation displayName];
        else if([[tableView tableColumns]indexOfObject:tableColumn]==2){
            return NULL;
            
        }
                
        return NULL;
    }else if(tableView==drawedEquations || tableView==drawedEquationsInterpeterWindow){
        Ecuation *ecuation=[[modelo drawedEquations]objectAtIndex:row];
        if([[tableView tableColumns]indexOfObject:tableColumn]==0)//Name
            return [ecuation name];
        else if([[tableView tableColumns]indexOfObject:tableColumn]==1)
            return [ecuation displayName];
        else if([[tableView tableColumns]indexOfObject:tableColumn]==2)
            return NULL;
    }else if(tableView==paramsInterpeterWindow){
        //NSLog(@"HOLAAA");
        NSInteger numberOfParams=[counterInterpeterWindow integerValue];
        NSMutableArray *paramsArray=[[NSMutableArray alloc]init];
        for(char a='a'; a<'w'; a++){
            if(a!='f' && a!='g' && a!='h'){
                [paramsArray addObject:[NSString stringWithFormat:@"%c",a]];
            }
        }
        if([[tableView tableColumns]indexOfObject:tableColumn]==0)//Param name
            return [paramsArray objectAtIndex:row];
        else if([[tableView tableColumns]indexOfObject:tableColumn]==1)
            return [termsValuesInterpeterWindow objectAtIndex:row];
        
    }else if(tableView=allEquationsTableView){
        NSInteger equationsCount=[[modelo ecuations]count];
        Ecuation *equation;
        if(row>equationsCount-1){
            equation=[[modelo drawedEquations]objectAtIndex:row-equationsCount];
        }else{
            equation=[[modelo ecuations]objectAtIndex:row];
        }
        
        if([[tableView tableColumns]indexOfObject:tableColumn]==0)//Name
            return [equation name];
        else if([[tableView tableColumns]indexOfObject:tableColumn]==1)
            return [equation displayName];
        else if([[tableView tableColumns]indexOfObject:tableColumn]==2)
            return NULL;    }
    
    
    
    return NULL;
    
}

//Checks...

-(void)controlTextDidChange:(NSNotification *)obj{
    //NSLog(@"FDF");
    if([obj object]==equationTextField){
        NSInteger length=[[equationTextField stringValue]length];
        if([[[equationTextField stringValue]substringFromIndex:length-1]floatValue]!=0 || [[[equationTextField stringValue]substringFromIndex:length-1]isEqualToString:@"0"]){
            [equationTextField setStringValue:[[equationTextField stringValue]substringToIndex:length-1]];
        }
        if([[equationTextField stringValue]length]==0){
            [addInterpeterWindow setEnabled:false];
            return;
        }
        if([self checkCorrectEquation] && [[nameTextFieldInterpeterWindow stringValue]length]>0){
            [addInterpeterWindow setEnabled:true];
        }else{
            [addInterpeterWindow setEnabled:false];
        }
    }else if([obj object]==nameTextFieldInterpeterWindow){
        if([self checkCorrectEquation] && [[nameTextFieldInterpeterWindow stringValue]length]>0){
            [addInterpeterWindow setEnabled:true];
        }else{
            [addInterpeterWindow setEnabled:false];
        }
        if([counterInterpeterWindow integerValue]==0)
            [equationTextField setEnabled:true];
        //else
         //   [equationTextField setEnabled:false];
    }else
        [self checkCorrectGraphic];
}

-(bool)checkCorrectEquation{
    if([[equationTextField stringValue]length]==0) return false;
    
    NSMutableArray *paramsArray=[[NSMutableArray alloc]init];
    NSInteger numberOfParams=[counterInterpeterWindow integerValue];
    for(char a='a'; a<'w'; a++){
        if(a!='f' && a!='g' && a!='h' && numberOfParams!=0){
            numberOfParams--;
            [paramsArray addObject:[NSString stringWithFormat:@"%c",a]];
        }
    }
    
    EquationParser *parser= [[EquationParser alloc]initWithEquationToSolve:[equationTextField stringValue] withTermValues:termsValuesInterpeterWindow withTerm:paramsArray];
    if([parser equationSplitted]!=NULL){
        EquationSolver *solver=[[EquationSolver alloc]initWithEquationSplitted:[parser equationSplitted]];
        if([solver getYWithXValue:10]!=ERROR)
            return true;
        else
            return false;
    }else{
        return false;
    }
    
    
}

-(void) checkCorrectGraphic{
    NSInteger indexComboBox=[ecuationComboBox indexOfSelectedItem];
    int counter=0;
    if(indexComboBox>=0 &&
       [[nameTextField stringValue]length]>0){
        for(int i=0; i<[[[modelo ecuationData]objectAtIndex:indexComboBox]termCount]; i++){
            
            if(![[termValues objectAtIndex:i]isEqualTo:@""]){
                counter++;
            }
            else
                counter=0;
        }
        if(counter==[[[modelo ecuationData]objectAtIndex:indexComboBox]termCount])
            [addGraphicButton setEnabled:true];
        else[addGraphicButton setEnabled:false];
        
    
    }else
        [addGraphicButton setEnabled:NO];
    
}

-(void)qualitySliderListener:(id)sender{
    switch ([sender integerValue]) {
        case 0:
            [modelo setHops:300];
            break;
        case 1:
            [modelo setHops:4000];
            break;
        case 2:
            [modelo setHops:14000];
            break;
    }
    [notificationCenter postNotificationName:DrawGraphicNotification object:self];
}
//ComboBox Methods...
-(void)comboBoxSelectionDidChange:(NSNotification *)notification{
    NSInteger index=[ecuationComboBox indexOfSelectedItem];
    if(index>=0){
        [termValues removeAllObjects];
        for(int i=0; i<[[[modelo ecuationData]objectAtIndex:index]termCount]; i++){
            [termValues addObject:@""];
        }
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

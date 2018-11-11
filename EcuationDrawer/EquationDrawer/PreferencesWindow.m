//
//  PreferencesWindow.m
//  EcuationDrawer
//
//  Created by Alumno on 23/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "PreferencesWindow.h"
#import <QuartzCore/QuartzCore.h>
#define ERROR -99999999
@interface PreferencesWindow ()

@end

@implementation PreferencesWindow
@synthesize modelo;

NSString * DrawGraphicNotification = @"DrawGraphicNotification";
NSString * ReloadImageViewNotification = @"ReloadImageViewNotification";

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
    termValues=[[NSMutableArray alloc]init];
    termsValuesInterpeterWindow=[[NSMutableArray alloc]init];
    return self;
}

//Button Listeners
-(void)drawGraphic:(id)sender{
    [notificationCenter postNotificationName:DrawGraphicNotification object:self];
}

-(void)removeGraphic:(id)sender{
    NSInteger indexEquations, indexDrawedEquations;
    if(sender==removeGraphicButton){
        indexEquations=[equationTableView selectedRow];
        indexDrawedEquations=[drawedEquations selectedRow];
    }else{
        indexEquations=[equationsInterpeterWindow selectedRow];
        indexDrawedEquations=[drawedEquationsInterpeterWindow selectedRow];
    }
    if(indexEquations!=-1){
        [[modelo equations]removeObjectAtIndex:indexEquations];
        [equationTableView reloadData];
        [equationsInterpeterWindow reloadData];
    }
    if(indexDrawedEquations!=-1){
        [[modelo drawedEquations]removeObjectAtIndex:indexDrawedEquations];
        [drawedEquations reloadData];
        [drawedEquationsInterpeterWindow reloadData];
        [notificationCenter postNotificationName:DrawGraphicNotification object:self];
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
    Equation *equation=[[Equation alloc]initWithEquationToSolve:[equationTextField stringValue] withParams:paramsArray withParamValues:termsValuesInterpeterWindow];
    EquationParser *parser=[[EquationParser alloc]initWithEquationToSolve:[equationTextField stringValue] withTermValues:termsValuesInterpeterWindow withTerm:paramsArray];
    NSString *displayName=[[NSString alloc]init];
    for(int i=0; i<[[parser equationSplitted]count];i++){
        displayName=[displayName stringByAppendingString:[[parser equationSplitted]objectAtIndex:i]];
    }
    [equation setDisplayName:displayName];
    [equation setColor:[colorWellInterpeterWindow color]];
    [equation setName:[nameTextFieldInterpeterWindow stringValue]];
    
    NSRect rect=[modelo funcRect];
    float width=0.6*(rect.size.width+rect.size.height)/400;
    if(width<0.05) width=0.05;
    [equation setLineWidth:width];
    
    [[modelo equations]addObject:equation];
    [colorWellInterpeterWindow setColor:[self getRandomColor]];
    [equationsInterpeterWindow reloadData];
    NSLog(@"ADDED");
}

-(void)addGraphic:(id)sender{
    NSInteger indexComboBox=[equationComboBox indexOfSelectedItem];
    
    //Poner color!
    EquationData *data=[[modelo equationData]objectAtIndex:indexComboBox];
    Equation *ecuation= [[Equation alloc]initWithEquationToSolve:[data name] withParams:[data terms] withParamValues:termValues];
    [ecuation setColor:[colorWell color]];
    [ecuation setName:[nameTextField stringValue]];
    [ecuation setDisplayName:[data getCustomizedName:termValues]];
    NSRect rect=[modelo funcRect];
    float width=0.6*(rect.size.width+rect.size.height)/400;
    if(width<0.05) width=0.05;
    [ecuation setLineWidth:width];    //ecuation.name=[nameTextField stringValue];
    //ecuation.color=[colorWell color];
    //ecuation.ecuation=[[[modelo ecuationData]objectAtIndex:indexComboBox]getCustomizedName:termValues];
    [[modelo equations]addObject:ecuation];
    [colorWell setColor:[self getRandomColor]];
    [equationTableView reloadData];
    
}
- (void)sendToLeft:(id)sender{
    NSInteger row;
    if(sender==moveToLeftInterpeterWindow)
        row=[drawedEquationsInterpeterWindow selectedRow];
    else
        row=[drawedEquations selectedRow];
    [[modelo equations]addObject:[[modelo drawedEquations]objectAtIndex:row]];
    [[modelo drawedEquations]removeObjectAtIndex:row];
    [equationTableView reloadData];
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
        row=[equationTableView selectedRow];
    [[modelo drawedEquations]addObject:[[modelo equations]objectAtIndex:row]];
    [[modelo equations]removeObjectAtIndex:row];
    [equationTableView reloadData];
    [drawedEquations reloadData];
    [equationsInterpeterWindow reloadData];
    [drawedEquationsInterpeterWindow reloadData];
    [drawGraphicButton setEnabled:true];
    [drawGraphicButtonInterpeterWindow setEnabled:true];
}



//TextField listeners
-(void)nameVisualPreferenceEditTextListener:(id)sender{
    if([allEquationsTableView selectedRow]>=0){
        Equation *equation;
        if((int)[allEquationsTableView selectedRow]>((int)[[modelo equations]count]-1)){
            equation=[[modelo drawedEquations]objectAtIndex: [allEquationsTableView selectedRow]-[[modelo equations]count]];
        }else{
            equation=[[modelo equations]objectAtIndex:[allEquationsTableView selectedRow]];
        }
        [equation setName:[sender stringValue]];
        [equationTableView reloadData];
        [drawedEquations reloadData];
        [drawedEquationsInterpeterWindow reloadData];
        [equationsInterpeterWindow reloadData];
        [allEquationsTableView reloadData];
    }
}
- (void)representationValueListener:(id)sender{
    if([[xEnd stringValue]length] > 0 && [[yEnd stringValue]length] > 0 && [[xStart stringValue]length] > 0 && [[yStart stringValue]length] > 0){
        float width, height;
        
        if([xStart floatValue]<[xEnd floatValue]){
            if([yStart floatValue]<[yEnd floatValue]){
            [modelo setFuncRect: NSMakeRect([xStart floatValue], [yStart floatValue], abs([xStart floatValue])+[xEnd floatValue],abs([yStart floatValue])+[yEnd floatValue])];
                [self recalculateWidths];
                [notificationCenter postNotificationName:DrawGraphicNotification object:self];
            }else
                [self animateTextField:sender];
        }else
            [self animateTextField:sender];
        
    }
    [sender deselectAllCells];
}
-(void)customParamsEditTextListener:(id)sender{
    if([counterInterpeterWindow integerValue]>=0 && [counterInterpeterWindow integerValue]<15){
        //NSLog(@"VALOR: %d",[counterInterpeterWindow integerValue]);
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
    }else{
        NSRect textFieldFrame = [counterInterpeterWindow frame];
        CGFloat centerX=textFieldFrame.origin.x;
        CGFloat centerY=textFieldFrame.origin.y;
        //NSPoint origin = NSMakePoint(centerX, centerY);
        //NSPoint one = NSMakePoint(centerX-5, centerY);
        //NSPoint two = NSMakePoint(centerX+5, centerY);
        if([counterInterpeterWindow frame].origin.x==centerX)
            [self animateTextField:counterInterpeterWindow];
        
    }
    
}
-(void)controlTextDidChange:(NSNotification *)obj{
    //NSLog(@"FDF");
    if([obj object]==equationTextField){
        NSInteger length=[[equationTextField stringValue]length];
        NSRange range;
        for(int i=0; i<[[equationTextField stringValue]length];i++){
            range.length=1;
            range.location=i;
            if([[[equationTextField stringValue]substringWithRange:range]floatValue]!=0 || [[[equationTextField stringValue]substringWithRange:range]isEqualToString:@"0"]){
                NSString *begin, *end;
                begin=[[equationTextField stringValue]substringToIndex:i];
                end=[[equationTextField stringValue]substringFromIndex:i+1];
                [equationTextField setStringValue: [NSString stringWithFormat:@"%@%@",begin,end]];
            }
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


//Slider listeners
-(void)widthSliderListener:(id)sender{
    bool isDrawed=false;
    if([allEquationsTableView selectedRow]>=0){
        Equation *equation;
        if((int)[allEquationsTableView selectedRow]>((int)[[modelo equations]count]-1)){
            equation=[[modelo drawedEquations]objectAtIndex: [allEquationsTableView selectedRow]-[[modelo equations]count]];
            isDrawed=true;
        }else{
            isDrawed=false;
            equation=[[modelo equations]objectAtIndex:[allEquationsTableView selectedRow]];
        }
        [equation setLineWidth:[sender floatValue]];
        if(isDrawed)
            [notificationCenter postNotificationName:DrawGraphicNotification object:self]; //Improve solo si está dibujada
    }
    
    
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




//Others
-(void)exportImage:(id)sender{
    [notificationCenter postNotificationName:ReloadImageViewNotification object:self];
    NSView *view=_currentView;
    NSBitmapImageRep *rep=[view bitmapImageRepForCachingDisplayInRect:[view bounds]];
    [view cacheDisplayInRect:[view bounds] toBitmapImageRep:rep];
    NSSavePanel *savePanel=[[NSSavePanel alloc]init];
    NSData *data;
    NSDate *date=[NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd-HH.mm.SS"];
    if([[fileFormatComboBox stringValue]containsString:@"(.png)"]){
        [savePanel setNameFieldStringValue:[NSString stringWithFormat:@"Grafica_%@_.png",[dateFormat stringFromDate:date]]];
        data=[rep representationUsingType:NSPNGFileType properties:nil];
    }else if([[fileFormatComboBox stringValue]containsString:@"(.gif)"]){
        [savePanel setNameFieldStringValue:[NSString stringWithFormat:@"Grafica_%@_.gif",[dateFormat stringFromDate:date]]];
        data=[rep representationUsingType:NSGIFFileType properties:nil];
    }else if([[fileFormatComboBox stringValue]containsString:@"(.jpeg)"]){
        [savePanel setNameFieldStringValue:[NSString stringWithFormat:@"Grafica_%@_.jpeg",[dateFormat stringFromDate:date]]];
        data=[rep representationUsingType:NSJPEGFileType properties:nil];
    }else if([[fileFormatComboBox stringValue]containsString:@"(.bmp)"]){
        [savePanel setNameFieldStringValue:[NSString stringWithFormat:@"Grafica_%@_.bmp",[dateFormat stringFromDate:date]]];
        data=[rep representationUsingType:NSBMPFileType properties:nil];
    }else if([[fileFormatComboBox stringValue]containsString:@"(.jp2)"]){
        [savePanel setNameFieldStringValue:[NSString stringWithFormat:@"Grafica_%@_.jp2",[dateFormat stringFromDate:date]]];
        data=[rep representationUsingType:NSJPEG2000FileType properties:nil];
    }
    [savePanel setCanCreateDirectories:true];
    [savePanel setPrompt:@"Guardar"];
    [savePanel beginWithCompletionHandler:^(NSInteger result){
        if(result==NSFileHandlingPanelOKButton){
            NSFileManager *manager = [NSFileManager defaultManager];
            NSURL *saveURL=[savePanel URL];
            //NSData *data =[rep representationUsingType:NSPNGFileType properties:nil];
            [data writeToURL:saveURL atomically:true];
        }
    }];
    
   
}
-(NSColor *)getRandomColor{
    float red, blue, green;
    red=random()%128/128.0;
    blue=random()%128/128.0;
    green=random()%128/128.0;
    return [NSColor colorWithSRGBRed:red green:green blue:blue alpha:1.0];
}
-(void)updateXandYValues{
    NSRect rect=[modelo funcRect];
    //if([xStart floatValue]>=[xEnd floatValue])
      //  [self animateTextField:xEnd];
    
        
    [xStart setStringValue:[NSString stringWithFormat:@"%.2f",rect.origin.x]];
    [yStart setStringValue:[NSString stringWithFormat:@"%.2f",rect.origin.y]];
    [xEnd setStringValue:[NSString stringWithFormat:@"%.2f",rect.origin.x+rect.size.width]];
    [yEnd setStringValue:[NSString stringWithFormat:@"%.2f",rect.origin.y+rect.size.height]];
}

-(void)recalculateWidths{
    NSMutableArray *equations, *drawed;
    equations=[modelo equations];
    drawed=[modelo drawedEquations];
    NSRect rect=[modelo funcRect];
    for(int i=0; i<[equations count];i++){
        Equation *equation=[equations objectAtIndex:i];
        CGFloat width=[equation lineWidth];
        width*=(rect.size.width+rect.size.height)/400;
        if(width<0.05) width=0.05;
        [equation setLineWidth:width];
    }
    for(int i=0; i<[drawed count];i++){
        Equation *equation=[drawed objectAtIndex:i];
        CGFloat width=[equation lineWidth];
        width*=(rect.size.height+rect.size.width)/400;
        if(width<0.05) width=0.05;
        [equation setLineWidth:width];
    }
    NSInteger index=[allEquationsTableView selectedRow];
    if(index!=-1){
        Equation *eq;
        if((int)[allEquationsTableView selectedRow]>(int)[[modelo equations]count]-1){
            eq=[[modelo drawedEquations]objectAtIndex:[allEquationsTableView selectedRow]-[[modelo equations]count]];
        }else{
            eq=[[modelo equations]objectAtIndex:[allEquationsTableView selectedRow]];
        }
        [widthSlider setFloatValue:[eq lineWidth]];
    }
}
-(void)animateTextField:(NSTextField *)textField{
    
    NSRect textFieldFrame = [textField frame];
    CGFloat centerX=textFieldFrame.origin.x;
    CGFloat centerY=textFieldFrame.origin.y;
    NSPoint origin = NSMakePoint(centerX, centerY);
    NSPoint one = NSMakePoint(centerX-5, centerY);
    NSPoint two = NSMakePoint(centerX+5, centerY);
    //if([NSAnimationContext currentContext]isCom)
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setCompletionHandler:^{
            
            
            [NSAnimationContext beginGrouping];
            [[NSAnimationContext currentContext] setCompletionHandler:^{
                
                [NSAnimationContext beginGrouping];
                [[NSAnimationContext currentContext] setCompletionHandler:^{
                    
                    [[NSAnimationContext currentContext] setDuration:0.0175];
                    [[NSAnimationContext currentContext] setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
                    [[textField animator] setFrameOrigin:origin];
                    
                }];
                
                [[NSAnimationContext currentContext] setDuration:0.0175];
                [[NSAnimationContext currentContext] setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
                [[textField animator] setFrameOrigin:two];
                [NSAnimationContext endGrouping];
                
            }];
            
            [[NSAnimationContext currentContext] setDuration:0.0175];
            [[NSAnimationContext currentContext] setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
            [[textField animator] setFrameOrigin:one];
            [NSAnimationContext endGrouping];
        }];
        
        [[NSAnimationContext currentContext] setDuration:0.0175];
        [[NSAnimationContext currentContext] setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
        [[textField animator] setFrameOrigin:two];
        [NSAnimationContext endGrouping];
        
    }];
    
    [[NSAnimationContext currentContext] setDuration:0.0175];
    [[NSAnimationContext currentContext] setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
    [[textField animator] setFrameOrigin:one];
    [NSAnimationContext endGrouping];
}

-(void)visualPropertyListener:(id)sender{
    
    //NSLog(@"%@",[sender object]);
    
    if(sender==[grid controlView])
        [modelo setGrid:![modelo grid]];
    if(sender==[tickNumbers controlView])
        [modelo setTickMarks:![modelo tickMarks]];
    //NSLog(@"GRID:%",[grid isEnabled]);
    [notificationCenter postNotificationName:DrawGraphicNotification object:self];
}



//TableView Methods...
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    if(tableView==paramsTableView){
        NSInteger index=[equationComboBox indexOfSelectedItem];
        if(index>=0){
            return[[[modelo equationData]objectAtIndex:index]termCount];
        }
    }
    NSLog(@"ADDED11");
    if(tableView==paramsInterpeterWindow)
        return [counterInterpeterWindow integerValue];
    NSLog(@"ADDED22");
    if(tableView==equationTableView || tableView==equationsInterpeterWindow)return[[modelo equations]count];
    NSLog(@"ADDED33");
    if(tableView==drawedEquations || tableView==drawedEquationsInterpeterWindow)return[[modelo drawedEquations]count];
    if(tableView==allEquationsTableView) return[[modelo equations]count]+[[modelo drawedEquations]count];
    return 0;
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    if([notification object]==equationTableView){
        if([equationTableView selectedRow]<0){
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
            
            Equation *equation;
            NSLog(@"SELECTED: %d, COUNT:%d",[allEquationsTableView selectedRow],([[modelo equations]count]-1));
            if((int)[allEquationsTableView selectedRow]>((int)[[modelo equations]count]-1)){
                NSLog(@"aaaaa");
                equation=[[modelo drawedEquations]objectAtIndex: [allEquationsTableView selectedRow]-[[modelo equations]count]];
            }else{
                equation=[[modelo equations]objectAtIndex:[allEquationsTableView selectedRow]];
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
-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if(tableView==equationTableView || tableView==equationsInterpeterWindow){
        if([[tableView tableColumns]indexOfObject:tableColumn]==2){
            Equation *ecuation=[[modelo equations]objectAtIndex:row];
            [cell setBackgroundColor:[ecuation color]];
        }
        [cell setDrawsBackground:YES];
    }else if(tableView==drawedEquations || tableView==drawedEquationsInterpeterWindow){
        if([[tableView tableColumns]indexOfObject:tableColumn]==2){
            Equation *ecuation=[[modelo drawedEquations]objectAtIndex:row];
            [cell setBackgroundColor:[ecuation color]];
        }
        [cell setDrawsBackground:YES];
    }else if(tableView==allEquationsTableView){
        NSInteger countEquations, countDrawedEquations;
        countEquations=[[modelo equations]count];
        if([[tableView tableColumns]indexOfObject:tableColumn]==2){
            Equation *equation;
            if(row>countEquations-1){
                equation=[[modelo drawedEquations]objectAtIndex:row-countEquations];
            }else{
                equation=[[modelo equations]objectAtIndex:row];
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
        [termValues insertObject:[NSString stringWithFormat:@"%.2f",[object floatValue]] atIndex:row];
        [paramsTableView reloadData];
        [self checkCorrectGraphic];
    }else if(tableView==paramsInterpeterWindow){
        [termsValuesInterpeterWindow removeObjectAtIndex:row];
        [termsValuesInterpeterWindow insertObject:[NSString stringWithFormat:@"%.2f",[object floatValue]] atIndex:row];
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
        
        NSInteger index = [equationComboBox indexOfSelectedItem];
        EquationData *data=[[modelo equationData]objectAtIndex:index];
        return [[data terms]objectAtIndex:row];
    }else if(tableView==equationTableView || tableView==equationsInterpeterWindow){
        Equation *ecuation=[[modelo equations]objectAtIndex:row];
        if([[tableView tableColumns]indexOfObject:tableColumn]==0)//Name
            return [ecuation name];
        else if([[tableView tableColumns]indexOfObject:tableColumn]==1)
            return [ecuation displayName];
        else if([[tableView tableColumns]indexOfObject:tableColumn]==2){
            return NULL;
            
        }
                
        return NULL;
    }else if(tableView==drawedEquations || tableView==drawedEquationsInterpeterWindow){
        Equation *ecuation=[[modelo drawedEquations]objectAtIndex:row];
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
        NSInteger equationsCount=[[modelo equations]count];
        Equation *equation;
        if(row>equationsCount-1){
            equation=[[modelo drawedEquations]objectAtIndex:row-equationsCount];
        }else{
            equation=[[modelo equations]objectAtIndex:row];
        }
        
        if([[tableView tableColumns]indexOfObject:tableColumn]==0)//Name
            return [equation name];
        else if([[tableView tableColumns]indexOfObject:tableColumn]==1)
            return [equation displayName];
        else if([[tableView tableColumns]indexOfObject:tableColumn]==2)
            return NULL;    }
    
    
    
    return NULL;
    
}



//Color Well Listeners
-(void)changeColorListener:(id)sender{
    if(sender==backgroundColor){
        [modelo setBackgroundColor:[backgroundColor color]];
        [notificationCenter postNotificationName:DrawGraphicNotification object:self];
        return;
    }
    Equation *equation;
    bool isDrawed=false;
    if([allEquationsTableView selectedRow]>(int)[[modelo equations]count]-1){
        isDrawed=true;
        equation=[[modelo drawedEquations]objectAtIndex: [allEquationsTableView selectedRow]-[[modelo equations]count]];
    }else{
        equation=[[modelo equations]objectAtIndex:[allEquationsTableView selectedRow]];
    }
    [equation setColor:[functionColorWell color]];
    [equationTableView reloadData];
    [equationsInterpeterWindow reloadData];
    [drawedEquations reloadData];
    [drawedEquationsInterpeterWindow reloadData];
    [allEquationsTableView reloadData];
    if(isDrawed)
        [notificationCenter postNotificationName:DrawGraphicNotification object:self];
}

//Checks
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
    NSInteger indexComboBox=[equationComboBox indexOfSelectedItem];
    int counter=0;
    if(indexComboBox>=0 &&
       [[nameTextField stringValue]length]>0){
        for(int i=0; i<[[[modelo equationData]objectAtIndex:indexComboBox]termCount]; i++){
            
            if(![[termValues objectAtIndex:i]isEqualTo:@""]){
                counter++;
            }
            else
                counter=0;
        }
        if(counter==[[[modelo equationData]objectAtIndex:indexComboBox]termCount])
            [addGraphicButton setEnabled:true];
        else[addGraphicButton setEnabled:false];
        
    
    }else
        [addGraphicButton setEnabled:NO];
    
}


//ComboBox Methods...
-(void)comboBoxSelectionDidChange:(NSNotification *)notification{
    NSInteger index=[equationComboBox indexOfSelectedItem];
    if(index>=0){
        [termValues removeAllObjects];
        for(int i=0; i<[[[modelo equationData]objectAtIndex:index]termCount]; i++){
            [termValues addObject:@""];
        }
        [paramsTableView reloadData];
        [self checkCorrectGraphic];
    }
}

-(NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox{
    return [[modelo equationData]count];
}

-(id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index{
    return [[[modelo equationData]objectAtIndex:index]name];
}

@end

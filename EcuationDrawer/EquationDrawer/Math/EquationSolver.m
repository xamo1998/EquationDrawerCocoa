//
//  EquationSolver.m
//  EcuationDrawer
//
//  Created by alumno5 on 29/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "EquationSolver.h"
#define ERROR -99999999
#define NaN -99999998
@implementation EquationSolver

-(id)initWithEquationSplitted:(NSMutableArray *)equationSplitted{
    self=[super init];
    if(!self){
        
    }
    self.finalEquationSplitted=equationSplitted;
    self.equationSplitted=[[NSMutableArray alloc]init];
    [self initOperations];
    //float yValue=[self getYWithXValue:2.0f];
    //NSLog(@"For the x Value: 2, The y value is %f",yValue);
    return self;
}
-(float)getYWithXValue:(float)xValue{
    //First we go to the deepest parentheses
    [_equationSplitted removeAllObjects];
    for(int i=0; i<[_finalEquationSplitted count]; i++){
        [_equationSplitted addObject:[_finalEquationSplitted objectAtIndex:i]];
    }
    float value=0;
    
    NSPoint position=[self getIndexOfDeepestParetheses]; //x=Start, y=end
    //NSLog(@"POSITION: %@",position);
    while(position.x!=ERROR){
        if(position.x==position.y-1){ //Esta vacio: ()
            return ERROR;
        }
        
        value=[self getValueFromIndexWithPosition:position withXValue:xValue];
        if(value==ERROR){
            return ERROR;
        }
        for(int i=position.x; i<=position.y; i++){
            [_equationSplitted removeObjectAtIndex:position.x];
        }
        [_equationSplitted insertObject:[NSString stringWithFormat:@"%f",value] atIndex:position.x];
        position=[self getIndexOfDeepestParetheses];
        //NSLog(@"PASO PARE___%@",_equationSplitted);
    }
    //NSLog(@"11111111");
    //Cos sen tan....
    int indexOfOperation=[self getIndexOfOperation];
    while(indexOfOperation!=ERROR){
        if([_equationSplitted count]-1<indexOfOperation+1){ //If user is typing x*......
            return ERROR;
        }
        
        
        NSString * operationFound=[_equationSplitted objectAtIndex:indexOfOperation];
        if([operationFound isEqualTo:@"cos"])
            value=cos([[_equationSplitted objectAtIndex:indexOfOperation+1]floatValue]);
        else if([operationFound isEqualTo:@"sen"])
            value=sin([[_equationSplitted objectAtIndex:indexOfOperation+1]floatValue]);
        else if([operationFound isEqualTo:@"tan"])
            value=tan([[_equationSplitted objectAtIndex:indexOfOperation+1]floatValue]);
        else if([operationFound isEqualTo:@"sin"])
            value=sin([[_equationSplitted objectAtIndex:indexOfOperation+1]floatValue]);
        else if([operationFound isEqualTo:@"tag"])
            value=tan([[_equationSplitted objectAtIndex:indexOfOperation+1]floatValue]);
        else if([operationFound isEqualTo:@"tanh"])
            value=tanh([[_equationSplitted objectAtIndex:indexOfOperation+1]floatValue]);
        else if([operationFound isEqualTo:@"tagh"])
            value=tanh([[_equationSplitted objectAtIndex:indexOfOperation+1]floatValue]);
        else if([operationFound isEqualTo:@"cosh"])
            value=cosh([[_equationSplitted objectAtIndex:indexOfOperation+1]floatValue]);
        else if([operationFound isEqualTo:@"senh"])
            value=sinh([[_equationSplitted objectAtIndex:indexOfOperation+1]floatValue]);
        else if([operationFound isEqualTo:@"sinh"])
            value=sinh([[_equationSplitted objectAtIndex:indexOfOperation+1]floatValue]);
        else if([operationFound isEqualTo:@"sqrt"]){
            float temp=[[_equationSplitted objectAtIndex:indexOfOperation+1]floatValue];
            if(temp<0) value=NaN;
            else value=sqrt([[_equationSplitted objectAtIndex:indexOfOperation+1]floatValue]);
        }else if([operationFound isEqualTo:@"abs"]){
            value=[[_equationSplitted objectAtIndex:indexOfOperation+1]floatValue];
            if(value<0)value*=-1;
        }else if([operationFound isEqualTo:@"log"]){
            float temp=[[_equationSplitted objectAtIndex:indexOfOperation+1]floatValue];
            if(temp<=0) value=NaN;
            else value=logf([[_equationSplitted objectAtIndex:indexOfOperation+1]floatValue]);
        }else if([operationFound isEqualTo:@"ln"]){
            float temp=[[_equationSplitted objectAtIndex:indexOfOperation+1]floatValue];
            if(temp<=0) value=NaN;
            else value=logf([[_equationSplitted objectAtIndex:indexOfOperation+1]floatValue]);
        }
       
        
        [_equationSplitted removeObjectAtIndex:indexOfOperation];
        [_equationSplitted removeObjectAtIndex:indexOfOperation];
        [_equationSplitted insertObject:[NSString stringWithFormat:@"%f",value] atIndex:indexOfOperation];
        indexOfOperation=[self getIndexOfOperation];
        //NSLog(@"PASO COS___%@",_equationSplitted);
    }
    //NSLog(@"222222222");
    //^
    int indexOfRaised=[self getIndexOfRaisedSymbol:_equationSplitted];
    while(indexOfRaised!=ERROR){
        if([_equationSplitted count]-1<indexOfRaised+1){ //If user is typing x*......
            return ERROR;
        }
        
        
        NSString *value1, *value2;
        value1=[_equationSplitted objectAtIndex:indexOfRaised-1];
        value2=[_equationSplitted objectAtIndex:indexOfRaised+1];
        value=[self operate2TermsWithOperation:@"^" withValue1:value1 withValue2:value2 withXValue:xValue];
        //NSLog(@"The result of %@^%@ is: %f",value1,value2,value);
        [_equationSplitted removeObjectAtIndex:indexOfRaised-1];
        [_equationSplitted removeObjectAtIndex:indexOfRaised-1];
        [_equationSplitted removeObjectAtIndex:indexOfRaised-1];
        [_equationSplitted insertObject:[NSString stringWithFormat:@"%f",value] atIndex:indexOfRaised-1];
        indexOfRaised=[self getIndexOfRaisedSymbol:_equationSplitted];
        //NSLog(@"PASO ^___%@",_equationSplitted);
    }
    //NSLog(@"3333333");
    // * /
    int indexOfMultiplier=[self getIndexOfMultiplier:_equationSplitted];
    while(indexOfMultiplier!=ERROR){
        if([_equationSplitted count]-1<indexOfMultiplier+1){ //If user is typing x*......
            return ERROR;
        }
        
        NSString *value1, *value2, *operation;
        operation=[_equationSplitted objectAtIndex:indexOfMultiplier];
        value1=[_equationSplitted objectAtIndex:indexOfMultiplier-1];
        value2=[_equationSplitted objectAtIndex:indexOfMultiplier+1];
        value=[self operate2TermsWithOperation:operation withValue1:value1 withValue2:value2 withXValue:xValue];
        if(value==ERROR){
            return ERROR;
        }
        [_equationSplitted removeObjectAtIndex:indexOfMultiplier-1];
        [_equationSplitted removeObjectAtIndex:indexOfMultiplier-1];
        [_equationSplitted removeObjectAtIndex:indexOfMultiplier-1];
        [_equationSplitted insertObject:[NSString stringWithFormat:@"%f",value] atIndex:indexOfMultiplier-1];
        indexOfMultiplier=[self getIndexOfMultiplier:_equationSplitted];
        //NSLog(@"PASO */___%@",_equationSplitted);
    }
    //NSLog(@"44444444");
    // + -
    int indexOfAddition=[self getIndexOfAddition:_equationSplitted];
    //NSLog(@"INDEX OF ADDITION: %d",indexOfAddition);
    while(indexOfAddition!=ERROR){
        if([_equationSplitted count]-1<indexOfAddition+1){ //If user is typing x+......
            return ERROR;
        }
        
        
        NSString *value1, *value2, *operation;
        operation=[_equationSplitted objectAtIndex:indexOfAddition];
        value1=[_equationSplitted objectAtIndex:indexOfAddition-1];
        value2=[_equationSplitted objectAtIndex:indexOfAddition+1];
        value=[self operate2TermsWithOperation:operation withValue1:value1 withValue2:value2 withXValue:xValue];
        if(value==ERROR){
            return ERROR;
        }
        [_equationSplitted removeObjectAtIndex:indexOfAddition-1];
        [_equationSplitted removeObjectAtIndex:indexOfAddition-1];
        [_equationSplitted removeObjectAtIndex:indexOfAddition-1];
        [_equationSplitted insertObject:[NSString stringWithFormat:@"%f",value] atIndex:indexOfAddition-1];
        indexOfAddition=[self getIndexOfAddition:_equationSplitted];
        //NSLog(@"PASO +-___%@",_equationSplitted);
    }
    //NSLog(@"555555555");
    if([[_equationSplitted objectAtIndex:0]isEqualTo:@"x"]) return xValue;
    return [[_equationSplitted objectAtIndex:0]floatValue];
}

-(float)operate2TermsWithOperation:(NSString *)operation withValue1:(NSString *)value1 withValue2:(NSString *)value2 withXValue:(float)xValue{
    float value1Parsed, value2Parsed;
    value1Parsed=[self getValueParsedWithValue:value1 withXValue:xValue];
    value2Parsed=[self getValueParsedWithValue:value2 withXValue:xValue];
    if(value1Parsed==ERROR || value2Parsed==ERROR){
        return ERROR;
    }
    if([operation isEqualTo:@"^"])
        return (float) pow(value1Parsed, value2Parsed);
    else if([operation isEqualTo:@"*"])
        return value1Parsed * value2Parsed;
    else if([operation isEqualTo:@"/"])
        return value1Parsed / value2Parsed;
    else if([operation isEqualTo:@"+"])
        return value1Parsed + value2Parsed;
    else if([operation isEqualTo:@"-"])
        return value1Parsed - value2Parsed;
    return 0;
}

-(NSPoint)getIndexOfDeepestParetheses{
    int indexOfStart=ERROR, indexOfEnd=ERROR;
    for(int i=0; i<[_equationSplitted count]; i++){
        
        NSString *splitValue=[_equationSplitted objectAtIndex:i];
        if([splitValue isEqualTo:@"("])
            indexOfStart=i;
    }
    if(indexOfStart!=ERROR){
        for(int i=([_equationSplitted count]-1); i>indexOfStart;i--){
            NSString *splitValue=[_equationSplitted objectAtIndex:i];
            if([splitValue isEqualTo:@")"])
                indexOfEnd=i;
        }
    }
    NSPoint posicion;
    posicion.x=indexOfStart;
    posicion.y=indexOfEnd;
    return posicion;
}

-(float)getValueParsedWithValue:(NSString *)value withXValue:(float)xValue{
    if([self isNumber:value]) return [value floatValue];
    if([self isXRaised:value]){
        float valueParsed=(float) pow(xValue, [value floatValue]);
        return valueParsed;
    }
    if([value isEqualTo:@"x"])return xValue;
    return ERROR;
}
-(int)getIndexOfRaisedSymbol:(NSMutableArray *)equation{
    for(int i=0; i<[equation count]; i++){
        if([[equation objectAtIndex:i]isEqualTo:@"^"])
            return i;
    }
    return ERROR;
}
-(bool)isXRaised:(NSString *)number{
    if([number containsString:@"x^"])return true;
    return false;
}
-(int)getIndexOfOperation{
    for(int i=0; i<[_equationSplitted count]; i++){
        for(int j=0; j<[_operations count]; j++){
            if([[_equationSplitted objectAtIndex:i]isEqualTo:[[_operations objectAtIndex:j]operation]])
                return i;
        }
    }
    return ERROR;
    
}
-(int)getIndexOfMultiplier:(NSMutableArray *)equation{
    for(int i=0; i<[equation count]; i++){
        if([[equation objectAtIndex:i]isEqualTo:@"*"] ||
           [[equation objectAtIndex:i]isEqualTo:@"/"])
            return i;
    }
    return ERROR;
}
-(int)getIndexOfAddition:(NSMutableArray *)equation{
    for(int i=0; i<[equation count]; i++){
        if([[equation objectAtIndex:i]isEqualTo:@"+"] ||
           [[equation objectAtIndex:i]isEqualTo:@"-"])
            return i;
    }
    return ERROR;
}

-(float)getValueFromIndexWithPosition:(NSPoint)position withXValue:(float)xValue{
    int firstValue=position.x+1, lastValue=position.y-1;
    if(position.x==ERROR || position.y==ERROR){
        return ERROR;
    }
    NSMutableArray *parenthesesList=[[NSMutableArray alloc]init];
    for(int i=firstValue; i<=lastValue; i++){
        [parenthesesList addObject:[_equationSplitted objectAtIndex:i]];
    }
    
    if(firstValue==lastValue){ //Only x or x^n
        if([[_equationSplitted objectAtIndex:firstValue]containsString:@"x"]){
            if([[_equationSplitted objectAtIndex:firstValue]containsString:@"x^"]){
                NSString *xRaised=[_equationSplitted objectAtIndex:firstValue];
                NSRange range;
                range.location=2;
                range.length=[xRaised length]-2;
                NSString *powValue=[xRaised substringWithRange:range];
                return (float)pow(xValue, [powValue floatValue]);
            }else{
                return xValue;
            }
        }
    }
    float trigoValue=ERROR;
    for(int i=0; i<[parenthesesList count]; i++){
        for(int j=0; j<[_operations count]; j++){
            if([[parenthesesList objectAtIndex:i]isEqualTo:[[_operations objectAtIndex:j]operation]]){
                NSString *operation=[[_operations objectAtIndex:j]operation];
                if([parenthesesList count]-1<i+1)return ERROR;
                if([operation isEqualTo:@"cos"])
                    trigoValue= (float)cos([[parenthesesList objectAtIndex:i+1]floatValue]);
                else if([operation isEqualTo:@"sen"])
                    trigoValue= (float)sin([[parenthesesList objectAtIndex:i+1]floatValue]);
                else if([operation isEqualTo:@"tan"])
                    trigoValue= (float)tan([[parenthesesList objectAtIndex:i+1]floatValue]);
                [parenthesesList removeObjectAtIndex:i];
                [parenthesesList removeObjectAtIndex:i];
                [parenthesesList insertObject:[NSString stringWithFormat:@"%f",trigoValue] atIndex:i];
                
            }
                
        }
    }
    float value;
    //^
    int indexOfRaised=[self getIndexOfRaisedSymbol:parenthesesList];
    while(indexOfRaised!=ERROR){
        if([parenthesesList count]-1<indexOfRaised+1){ //If user is typing x+......
            return ERROR;
        }
        
        
        NSString *value1, *value2;
        value1=[parenthesesList objectAtIndex:indexOfRaised-1];
        value2=[parenthesesList objectAtIndex:indexOfRaised+1];
        value=[self operate2TermsWithOperation:@"^" withValue1:value1 withValue2:value2 withXValue:xValue];
        if(value==ERROR)return ERROR;
        [parenthesesList removeObjectAtIndex:indexOfRaised-1];
        [parenthesesList removeObjectAtIndex:indexOfRaised-1];
        [parenthesesList removeObjectAtIndex:indexOfRaised-1];
        [parenthesesList insertObject:[NSString stringWithFormat:@"%f",value] atIndex:indexOfRaised-1];
        indexOfRaised=[self getIndexOfRaisedSymbol:parenthesesList];
    }
    // * /
    int indexOfMultiplier=[self getIndexOfMultiplier:parenthesesList];
    while(indexOfMultiplier!=ERROR){
        if([parenthesesList count]-1<indexOfMultiplier+1){ //If user is typing x+......
            return ERROR;
        }
        
        
        NSString *value1, *value2, *operation;
        operation=[parenthesesList objectAtIndex:indexOfMultiplier];
        value1=[parenthesesList objectAtIndex:indexOfMultiplier-1];
        value2=[parenthesesList objectAtIndex:indexOfMultiplier+1];
        value=[self operate2TermsWithOperation:operation withValue1:value1 withValue2:value2 withXValue:xValue];
        if(value==ERROR)return ERROR;
        [parenthesesList removeObjectAtIndex:indexOfMultiplier-1];
        [parenthesesList removeObjectAtIndex:indexOfMultiplier-1];
        [parenthesesList removeObjectAtIndex:indexOfMultiplier-1];
        [parenthesesList insertObject:[NSString stringWithFormat:@"%f",value] atIndex:indexOfMultiplier-1];
        indexOfMultiplier=[self getIndexOfMultiplier:parenthesesList];
    }
    // + -
    int indexOfAddition=[self getIndexOfAddition:parenthesesList];
    while(indexOfAddition!=ERROR){
        if([parenthesesList count]-1<indexOfAddition+1){ //If user is typing x+......
            return ERROR;
        }
        
        NSString *value1, *value2, *operation;
        operation=[parenthesesList objectAtIndex:indexOfAddition];
        value1=[parenthesesList objectAtIndex:indexOfAddition-1];
        value2=[parenthesesList objectAtIndex:indexOfAddition+1];
        value=[self operate2TermsWithOperation:operation withValue1:value1 withValue2:value2 withXValue:xValue];
        if(value==ERROR)return ERROR;
        [parenthesesList removeObjectAtIndex:indexOfAddition-1];
        [parenthesesList removeObjectAtIndex:indexOfAddition-1];
        [parenthesesList removeObjectAtIndex:indexOfAddition-1];
        [parenthesesList insertObject:[NSString stringWithFormat:@"%f",value] atIndex:indexOfAddition-1];
        indexOfAddition=[self getIndexOfAddition:parenthesesList];
    }
    return [[parenthesesList objectAtIndex:0]floatValue];
    
}
-(bool)isNumber:(NSString *)number{
    if([number isEqualTo:@"."]) return YES;
    //double number=[number doubleValue];
    //NSLog(number);
    if([number isEqualTo:@"e"])return NO;
    if([number isEqualTo:@"("]) return NO;
    if([number isEqualTo:@"0.000000"])return true;
    if([number isEqualTo:@"-0.000000"])return true;
    float value=[number floatValue];
    if(value==0)
        return false;
    else
        return true;
}
-(void)initOperations{
    _operations=[[NSMutableArray alloc]init];
    [_operations addObject:[[Operation alloc]initWithOperation:@"cos"]];
    [_operations addObject:[[Operation alloc]initWithOperation:@"sen"]];
    [_operations addObject:[[Operation alloc]initWithOperation:@"sin"]];
    [_operations addObject:[[Operation alloc]initWithOperation:@"senh"]];
    [_operations addObject:[[Operation alloc]initWithOperation:@"sinh"]];
    [_operations addObject:[[Operation alloc]initWithOperation:@"cosh"]];
    [_operations addObject:[[Operation alloc]initWithOperation:@"tanh"]];
    [_operations addObject:[[Operation alloc]initWithOperation:@"tag"]];
    [_operations addObject:[[Operation alloc]initWithOperation:@"tagh"]];
    [_operations addObject:[[Operation alloc]initWithOperation:@"tan"]];
    [_operations addObject:[[Operation alloc]initWithOperation:@"sqrt"]];
    [_operations addObject:[[Operation alloc]initWithOperation:@"abs"]];
    [_operations addObject:[[Operation alloc]initWithOperation:@"log"]];
    [_operations addObject:[[Operation alloc]initWithOperation:@"ln"]];
}

@end

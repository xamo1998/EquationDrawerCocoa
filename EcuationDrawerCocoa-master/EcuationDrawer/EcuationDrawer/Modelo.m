//
//  Modelo.m
//  EcuationDrawer
//
//  Created by Alumno on 23/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "Modelo.h"

@implementation Modelo
@class EcuationData;
@synthesize ecuationData;
@synthesize ecuations;
-(id)init{
    self=[super init];
    if(!self){
        
    }
    ecuationData=[[NSMutableArray alloc]init];
    ecuations=[[NSMutableArray alloc]init];
    [self createTitleOfEcuations];
    return self;
}

-(void)createTitleOfEcuations{
    [ecuationData addObject:[[EcuationData alloc]initWithName:@"a * sen(b*x)" withCountTerms:2]];
    [ecuationData addObject:[[EcuationData alloc]initWithName:@"a * cos(b*x)" withCountTerms:2]];
    [ecuationData addObject:[[EcuationData alloc]initWithName:@"a * x^n" withCountTerms:1]];
    [ecuationData addObject:[[EcuationData alloc]initWithName:@"a * x + b" withCountTerms:2]];
    [ecuationData addObject:[[EcuationData alloc]initWithName:@"a * x^2 + b*x + c" withCountTerms:3]];
    [ecuationData addObject:[[EcuationData alloc]initWithName:@"a / (b*x)" withCountTerms:2]];
    NSLog(@"En la pos %i, hay %i terms", 0, [[[self ecuationData]objectAtIndex:0]termCount]);

}

@end

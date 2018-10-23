//
//  Modelo.m
//  EcuationDrawer
//
//  Created by Alumno on 23/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "Modelo.h"

@implementation Modelo
@synthesize ecuationTitles;
@synthesize ecuations;
-(id)init{
    self=[super init];
    if(!self){
        
    }
    ecuationTitles=[[NSMutableArray alloc]init];
    ecuations=[[NSMutableArray alloc]init];
    [self createTitleOfEcuations];
    return self;
}

-(void)createTitleOfEcuations{
    [ecuationTitles addObject:@"a * sen(b*x)"];
    [ecuationTitles addObject:@"a * cos(b*x)"];
    [ecuationTitles addObject:@"a * x^n"];
    [ecuationTitles addObject:@"a * x + b"];
    [ecuationTitles addObject:@"a * x^2 + b*x + c"];
    [ecuationTitles addObject:@"a / (b*x)"];
}

@end

//
//  EcuationData.m
//  EcuationDrawer
//
//  Created by Alumno on 24/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "EcuationData.h"

@implementation EcuationData
@synthesize name;
@synthesize termCount;
-(id)initWithName:(NSString *)name
   withCountTerms:(int)count{
    self=[super init];
    if(!self){}
    self.name=name;
    self.termCount=count;
    return self;
}

-(NSString *)getCustomizedName:(NSMutableArray *) terms{
    NSString *customName=[[NSString alloc]init];
    switch ([terms count]) {
        case 1: //1 parametro: A
            customName=[name stringByReplacingOccurrencesOfString:@"a" withString:[terms objectAtIndex:0]];
            break;
        case 2://2 parametros: A, B
            customName=[name stringByReplacingOccurrencesOfString:@"a" withString:[terms objectAtIndex:0]];
            customName=[customName stringByReplacingOccurrencesOfString:@"b" withString:[terms objectAtIndex:1]];
            break;
        case 3:
            customName=[name stringByReplacingOccurrencesOfString:@"a" withString:[terms objectAtIndex:0]];
            customName=[customName stringByReplacingOccurrencesOfString:@"b" withString:[terms objectAtIndex:1]];
            customName=[customName stringByReplacingOccurrencesOfString:@"c" withString:[terms objectAtIndex:2]];
            break;
        default:
            break;
    }
    
    
    
    return customName;
}
@end

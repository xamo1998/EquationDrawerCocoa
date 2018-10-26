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
@synthesize terms;
-(id)initWithName:(NSString *)name
        withTerms:(NSMutableArray *)terms{
    self=[super init];
    if(!self){}
    self.name=name;
    self.terms=terms;
    termCount=[terms count];
    return self;
}

-(NSString *)getCustomizedName:(NSMutableArray *) termValues{
    NSString *customName=name;
    for(int i=0; i< [termValues count]; i++){
        NSString *letter=[terms objectAtIndex:i];
        if([customName containsString:letter]){
            NSString *valueTerm= [termValues objectAtIndex:i];
            customName=[customName stringByReplacingOccurrencesOfString:letter withString:valueTerm];
        }
    }
    return customName;
}
@end

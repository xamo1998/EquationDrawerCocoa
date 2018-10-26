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
    terms=terms;
    termCount=[terms count];
    return self;
}

-(NSString *)getCustomizedName:(NSMutableArray *) terms{
    NSString *customName=name;
    for(char c='a';c<='w';c++){
        NSString *letter=[NSString stringWithFormat:@"%c",c];
        if([customName containsString:letter]){
            NSString *valueTerm= [terms valueForKey:letter];
            customName=[customName stringByReplacingOccurrencesOfString:letter withString:valueTerm];
        }
    }
    return customName;
}
@end

//
//  Ecuation.m
//  EcuationDrawer
//
//  Created by xamo on 10/11/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "Ecuation.h"

@implementation Ecuation
@synthesize termCount;
@synthesize terms;
- (id)initWithParams:(int)numberOfParams{
    self=[super init];
    if(!self){
        
    }
    termCount=numberOfParams;
    terms=malloc(termCount*sizeof(float));

    return self;
    
}
@end

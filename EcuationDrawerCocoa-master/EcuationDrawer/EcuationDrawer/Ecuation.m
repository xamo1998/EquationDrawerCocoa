//
//  Ecuation.m
//  EcuationDrawer
//
//  Created by xamo on 10/11/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "Ecuation.h"

@implementation Ecuation
- (id)init{
    self=[super init];
    if(!self){
        
    }
    termCount=2;
    terms=malloc(termCount*sizeof(float));

    return self;
    
}
@end

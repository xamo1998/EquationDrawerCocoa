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
@end

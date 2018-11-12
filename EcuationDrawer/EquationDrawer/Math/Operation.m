//
//  Operation.m
//  EcuationDrawer
//
//  Created by alumno5 on 29/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "Operation.h"

@implementation Operation

-(id)initWithOperation:(NSString *)operation{
    self=[super init];
    if(self){
        self.operation=operation;
        self.splitted=[[NSMutableString alloc]initWithString:@""];
        self.letters=[[NSMutableArray alloc]init];
        NSRange range;
        for(int i=0; i< [operation length];i++){
            
            range.location=i;
            range.length=1;
            NSString *letter= [operation substringWithRange:range];
            [_letters addObject:letter];
            [_splitted appendString:letter];
            [_splitted appendString:@", "];
        }
        range.location=0;
        range.length=[_splitted length]-2;
        [_splitted setString:[_splitted substringWithRange:range]];   
    }
    return self;
}

@end

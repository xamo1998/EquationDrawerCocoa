//
//  BalancedParentheses.m
//  EcuationDrawer
//
//  Created by xamo on 11/11/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import "BalancedParentheses.h"
#import "Stack.h"
@implementation BalancedParentheses


-(bool)areParenthesesBalanced:(NSMutableArray *)exp{
    Stack *stack= [[Stack alloc]init];
    for(int i=0;i<[exp count];i++){
        NSLog(@"DDDD:%@",[exp objectAtIndex:i]);
        if([[exp objectAtIndex:i] isEqualToString:@"("]){
            NSLog(@"aaaaaa");
           [stack pushObject:[exp objectAtIndex:i]];
        }if([[exp objectAtIndex:i]isEqualToString:@")"]){
            NSLog(@"bbbbbbbb");
            if([stack count]==0) return false;
            else
                if(![self isMatchingPairWithChar1:[stack popObject] withChar2:[exp objectAtIndex:i]]) return false;
        }
    }
    NSLog(@"COUNT: %ld",[stack count]);
    if([stack count]==0) return true;
    else return false;
}
-(bool)isMatchingPairWithChar1:(NSString *)char1 withChar2:(NSString *)char2{
    if([char1 isEqualToString:@"("] && [char2 isEqualToString:@")"]) return true;
    return false;
}

@end

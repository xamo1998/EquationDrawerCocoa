//
//  BalancedParentheses.h
//  EcuationDrawer
//
//  Created by xamo on 11/11/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BalancedParentheses : NSObject{
    
}

-(bool) isMatchingPairWithChar1:(NSString *)char1
                      withChar2:(NSString *)char2;
-(bool) areParenthesesBalanced:(NSMutableArray *)exp;

@end


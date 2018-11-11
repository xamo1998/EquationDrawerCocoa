//
//  Stack.h
//  EcuationDrawer
//
//  Created by xamo on 11/11/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Stack : NSObject <NSFastEnumeration>
    
@property (nonatomic, assign, readonly) NSUInteger count;

- (id)initWithArray:(NSArray*)array;

- (void)pushObject:(id)object;
- (void)pushObjects:(NSArray*)objects;
- (id)popObject;
- (id)peekObject;

@end



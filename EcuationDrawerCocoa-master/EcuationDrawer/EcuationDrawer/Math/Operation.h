//
//  Operation.h
//  EcuationDrawer
//
//  Created by alumno5 on 29/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Operation : NSObject

@property NSString *operation;
@property NSMutableString *splitted;
@property NSMutableArray *letters;
-(id)initWithOperation:(NSString *)operation;


@end

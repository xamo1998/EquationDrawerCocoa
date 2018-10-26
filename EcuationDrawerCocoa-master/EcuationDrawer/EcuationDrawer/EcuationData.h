//
//  EcuationData.h
//  EcuationDrawer
//
//  Created by Alumno on 24/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface EcuationData : NSObject{
    
}
@property NSString *name, *displayName;
@property NSColor *color;
@property int termCount;
@property NSMutableArray *terms;
-(id)initWithName:(NSString *)name
        withTerms:(NSMutableArray *)terms;
-(NSString *)getCustomizedName: (NSMutableArray *) terms;
@end

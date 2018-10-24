//
//  EcuationData.h
//  EcuationDrawer
//
//  Created by Alumno on 24/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EcuationData : NSObject{
    
}
@property NSString *name;
@property int termCount;
-(id)initWithName:(NSString *)name
   withCountTerms:(int)count;
-(NSString *)getCustomizedName: (NSMutableArray *) terms;
@end

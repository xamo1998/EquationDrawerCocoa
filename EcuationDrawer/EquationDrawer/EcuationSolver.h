//
//  EcuationSolver.h
//  EcuationDrawer
//
//  Created by alumno on 26/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface EcuationSolver : NSObject{
    
}

@property NSString *ecuation;
@property NSMutableArray *params, *paramValues;
-(float) valueAt:(float)x
    withEcuation:(NSString *)ecuation
      withParams:(NSMutableArray *)params
 withValueParams:(NSMutableArray *)paramsValue;
@end

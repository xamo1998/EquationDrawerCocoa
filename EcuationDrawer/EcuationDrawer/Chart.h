//
//  Chart.h
//  EcuationDrawer
//
//  Created by xamo on 10/2/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface Chart : NSView{
    
}

-(void)drawAxisWithGrid:(bool)grid
            withNumbers:(bool)numbers
          withTickMarks:(bool)tickMarks
          withStepValue:(float)stepValue;
-(void)drawGrid:(float)stepValue
   withMaxPoint:(NSPoint)maxPoint;
-(void)drawNumbers:(float)stepValue
      withMaxPoint:(NSPoint)maxPoint;


@end

NS_ASSUME_NONNULL_END

//
//  Chart.h
//  EcuationDrawer
//
//  Created by xamo on 10/2/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GraphicsController.h"
@class GraphicsController;
NS_ASSUME_NONNULL_BEGIN

@interface Chart : NSView{
    IBOutlet __weak GraphicsController *graphicsController;
    IBOutlet NSTextField *xValue, *yValue;
}
@property NSPoint startDraggedPoint, endDraggedPoint;
@property NSPoint finalStartDraggedPoint, finalEndDraggedPoint;
-(void)drawAxisWithGrid:(bool)grid
            withNumbers:(bool)numbers
          withTickMarks:(bool)tickMarks
          withStepValue:(float)stepValue;
-(void)drawGrid:(float)stepValue
   withMaxPoint:(NSPoint)maxPoint;
-(void)drawNumbers;
-(void)drawTickMarks;
-(NSImage *)imageRepresentation;

@end

NS_ASSUME_NONNULL_END

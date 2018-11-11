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
    IBOutlet  NSButton *zoomIn, *zoomOut;
    IBOutlet __weak GraphicsController *graphicsController;
    IBOutlet NSTextField *xValue, *yValue;
}
@property NSPoint startDraggedPoint, endDraggedPoint;
@property NSPoint finalStartDraggedPoint, finalEndDraggedPoint;
-(void)drawAxisWithGrid:(bool)grid
          withTickMarks:(bool)tickMarks;
-(void)drawGrid;
-(void)drawNumbers;
-(void)drawTickMarks;
-(NSImage *)imageRepresentation;

@end

NS_ASSUME_NONNULL_END

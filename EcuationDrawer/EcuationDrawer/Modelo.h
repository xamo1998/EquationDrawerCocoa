//
//  Modelo.h
//  EcuationDrawer
//
//  Created by Alumno on 23/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EcuationData.h"
@interface Modelo : NSObject{
    
}
@property NSColor *backgroundColor;
@property NSMutableArray *ecuationData;
@property NSMutableArray *ecuations, *drawedEquations;
@property int hops;
@property NSImage *image;
@property float lineWidth;
@property NSRect funcRect;
@property bool numbers, grid, tickMarks;
-(void)createTitleOfEcuations;
-(float)getWidthOfGraphicsLine;
-(float)getWidthOfGridLine;
-(float)getTextSize;
-(float)getXOffsetForNumbers;
-(float)getYOffsetForNumbers;
-(float)getStepValue;
@end

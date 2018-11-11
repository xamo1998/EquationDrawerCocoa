//
//  Modelo.h
//  EcuationDrawer
//
//  Created by Alumno on 23/10/18.
//  Copyright © 2018 xamo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EquationData.h"
@interface Model : NSObject{
    
}
@property NSColor *backgroundColor;
@property NSMutableArray *equationData;
@property NSMutableArray *equations, *drawedEquations;
@property int hops;
@property float lineWidth;
@property NSRect funcRect;
@property bool grid, tickMarks;
-(void)createTitleOfEcuations;
-(float)getWidthOfGraphicsLine;
-(float)getWidthOfGridLine;
@end

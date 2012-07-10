//
//  PuzzleGrid.h
//  Slider
//
//  Created by Chris Sinchok on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PuzzleGrid : NSObject {
    NSMutableDictionary *_puzzleHolder;
}

- (void)setObject:(id)object forPoint:(CGPoint)point;
- (id)getObjectForPoint:(CGPoint)point;
- (CGPoint)pointForObject:(id)object;
- (BOOL)isSolved;
- (NSArray *)allObjects;

@end

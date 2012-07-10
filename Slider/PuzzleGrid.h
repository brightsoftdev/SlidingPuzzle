//
//  PuzzleGrid.h
//  Slider
//
//  Created by Chris Sinchok on 7/8/12.
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

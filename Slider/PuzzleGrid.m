//
//  PuzzleGrid.m
//  Slider
//
//  Created by Chris Sinchok on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleGrid.h"
#import "PuzzlePiece.h"

@implementation PuzzleGrid

- (id)init
{
    self = [super init];
    if (self) {
        _puzzleHolder = [NSMutableDictionary dictionaryWithCapacity:16];
    }
    return self;
}

- (CGPoint)pointForKey:(NSString *)key
{
    NSRange dividerRange = [key rangeOfString:@","];
    if (dividerRange.location != NSNotFound) {
        NSString *x = [key substringToIndex:dividerRange.location];
        NSString *y = [key substringFromIndex:dividerRange.location + 1];
        return CGPointMake([x integerValue], [y integerValue]);
    }
    return CGPointMake(-1, -1);
}

- (NSArray *)allObjects
{
    return [_puzzleHolder objectsForKeys:[_puzzleHolder allKeys] notFoundMarker:[NSNull null]];
}

- (BOOL)isSolved
{
    for (NSString *key in  [_puzzleHolder allKeys]) {
        CGPoint currentLocation = [self pointForKey:key];
        id piece = [_puzzleHolder objectForKey:key];
        
        if (piece != [NSNull null]) {
            if (!CGPointEqualToPoint(currentLocation, [(PuzzlePiece *)piece goalLocation])) {
                return NO;
            }
        }
    } 
    return YES;
}

- (void)setObject:(id)object forPoint:(CGPoint)point
{
    [_puzzleHolder setObject:object forKey:[NSString stringWithFormat:@"%g,%g", point.x, point.y]];
}

- (id)getObjectForPoint:(CGPoint)point
{
    return [_puzzleHolder objectForKey:[NSString stringWithFormat:@"%g,%g", point.x, point.y]];
}



- (CGPoint)pointForObject:(id)object
{   
    NSSet *matches = [_puzzleHolder keysOfEntriesPassingTest:^(id key, id obj, BOOL *stop) {
        if ([obj isEqual:object]) {
            return  YES;
        }
        return  NO;
    }];
    
    if ([matches count] == 1) {
        return [self pointForKey:[matches anyObject]];
    }
    return CGPointMake(-1, -1);
}

@end

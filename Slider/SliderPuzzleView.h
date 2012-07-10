//
//  SliderPuzzleView.h
//  Slider
//
//  Created by Chris Sinchok on 7/8/12.
//
//  This is a UIView that contains the logic necessary for the game. This could also be 
//  a UIControl or some ViewController, but this is just what I went with.

#import <UIKit/UIKit.h>
#import "PuzzleGrid.h"

@interface SliderPuzzleView : UIView {
    UIImage *_puzzleImage;
    NSUInteger _gridSize;
    PuzzleGrid *_grid;
    UILabel *_solvedView;
}

// The image and the grid size are both configurable.
@property (nonatomic, retain) UIImage *puzzleImage;
@property (nonatomic) NSUInteger gridSize;

// This is just so I can do "self.blankSpace", which is nice.
@property (nonatomic, readonly) CGPoint blankSpace;

- (void)shuffle;
- (void)setPuzzleImage:(UIImage *)image;

@end

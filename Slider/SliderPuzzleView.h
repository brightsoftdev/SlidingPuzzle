//
//  SliderPuzzleView.h
//  Slider
//
//  Created by Chris Sinchok on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleGrid.h"

@interface SliderPuzzleView : UIView {
    UIImage *_puzzleImage;
    NSUInteger _gridSize;
    PuzzleGrid *_grid;
    UILabel *_solvedView;
}

@property (nonatomic, retain) UIImage *puzzleImage;
@property (nonatomic) NSUInteger gridSize;
@property (nonatomic, readonly) CGPoint blankSpace;

- (void)shuffle;
- (void)panned:(UIPanGestureRecognizer *)gesture;
- (void)tapped:(UITapGestureRecognizer *)gesture;
- (void)setPuzzleImage:(UIImage *)image;

@end

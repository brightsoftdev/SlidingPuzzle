//
//  SliderPuzzleView.m
//  Slider
//
//  Created by Chris Sinchok on 7/8/12.
//

#import "SliderPuzzleView.h"
#import "PuzzlePiece.h"
#import <QuartzCore/QuartzCore.h>

@implementation SliderPuzzleView
@synthesize puzzleImage;
@synthesize gridSize;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Sensible defaults
        _puzzleImage = [UIImage imageNamed:@"globe"];
        _gridSize = 4;
        
        // Making things look nice.
        self.clipsToBounds = YES;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        
        // Adding a "solved" overlay.
        _solvedView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_solvedView setFont:[UIFont boldSystemFontOfSize:32.0]];
        [_solvedView setTextAlignment:UITextAlignmentCenter];
        [_solvedView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.5]];
        [_solvedView setHidden:YES];
        [_solvedView setText:@"Solved!"];
        [self addSubview:_solvedView];
        [self sendSubviewToBack:_solvedView];
        
        // Make sure the image is square
        CGSize imageSize = [_puzzleImage size];
        if (imageSize.width != imageSize.height) {
            CGRect cropRect;
            if (imageSize.width < imageSize.height) {
                cropRect = CGRectMake(0, 0, imageSize.width, imageSize.width);
            } else {
                cropRect = CGRectMake(0, 0, imageSize.height, imageSize.height);
            }
            CGImageRef imageRef = CGImageCreateWithImageInRect([_puzzleImage CGImage], cropRect);
            _puzzleImage = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
        }
    
        // Create a grid to keep track of the picece locations.
        _grid = [[PuzzleGrid alloc] init];
        
        // This should maybe be a property, but it's not.
        CGFloat pieceViewSize = self.bounds.size.width / _gridSize;
        
        for(int y=0; y < _gridSize; y++) {            
            for (int x=0; x < _gridSize; x++) {
                
                CGPoint currentLocation = CGPointMake(x, y);
                
                // If this spot is int he lower right, it's blank, so we toss an NSNull in the grid and move on.
                if (y == (_gridSize - 1) && x == (_gridSize - 1)) {
                    [_grid setObject:[NSNull null] forPoint:currentLocation];
                    continue;
                }
                
                // Create and position the piece
                CGRect pieceFrame = CGRectMake(x * pieceViewSize,
                                               y * pieceViewSize,
                                               pieceViewSize,
                                               pieceViewSize);
                PuzzlePiece *piece = [[PuzzlePiece alloc] initWithImage:_puzzleImage 
                                                               location:currentLocation 
                                                               gridSize:_gridSize
                                                                  frame:pieceFrame];
                
                // Add the gesture recognizers.
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                             action:@selector(tapped:)];
                [tapGesture setNumberOfTapsRequired:1];
                [piece addGestureRecognizer:tapGesture];
                
                UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(panned:)];
                [panGesture setMaximumNumberOfTouches:1];
                [panGesture setMinimumNumberOfTouches:1];
                [piece addGestureRecognizer:panGesture];
                
                // Add the piece to the board, and put it in the grid.
                [self addSubview:piece];
                [_grid setObject:piece forPoint:currentLocation];
            }
        }
    }
    return self;
}

/*
 *  I wanted to do a nice animated shuffle, but it just didn't work out in time. This will have to do.
 */
- (void)shuffle
{
    // Every grid can be solved in 80 moves, so 100 will generally be a decent shuffle.
    for (int i = 0; i < 100; i++) {
        int offset = arc4random() % (_gridSize - 1);
        CGPoint randomPoint;
        if (i % 2) {
            randomPoint = CGPointMake(self.blankSpace.x, offset);
            if (CGPointEqualToPoint(randomPoint, self.blankSpace)) {
                randomPoint.y += 1;
            }
        } else {
            randomPoint = CGPointMake(offset, self.blankSpace.y);
            if (CGPointEqualToPoint(randomPoint, self.blankSpace)) {
                randomPoint.x += 1;
            }
        }
        PuzzlePiece *randomPiece = [_grid getObjectForPoint:randomPoint];
        [self movePiece:randomPiece animated:NO];
    }
    [_solvedView setHidden:YES];
    [self sendSubviewToBack:_solvedView];
}

- (CGPoint)blankSpace
{
    return [_grid pointForObject:[NSNull null]];
}

/* 
 *  Just a private method to keep things DRY. This method returns an "offset" 
 *  of how a piece could be moved. If the piece can't be moved, we'll get 
 *  CGPointZero.
 */
- (CGPoint)_getOffset:(PuzzlePiece *)piece
{
    CGPoint currentLocation = [_grid pointForObject:piece];
    CGPoint blankSpace = self.blankSpace;
    
    CGPoint offset = CGPointMake(0, 0);
    
    if (currentLocation.x == blankSpace.x) {
        // Same column
        if (currentLocation.y < blankSpace.y) {
            // Move down
            offset.y = 1;
        }
        if (currentLocation.y > blankSpace.y) {
            // Move up
            offset.y = -1;
        }
    }
    
    if (currentLocation.y == blankSpace.y) {
        // Same row
        if (currentLocation.x < blankSpace.x) {
            // Move right
            offset.x = 1;
        }
        if (currentLocation.x > blankSpace.x) {
            // Move left
            offset.x = -1;
        }
    }
    return offset;
}

/*
 *  Given a piece to move, and the direction in which we're moving it, 
 *  what are all the pieces we'll be moving?
 */
- (NSMutableArray *)_getPiecesToMove:(PuzzlePiece *)piece offset:(CGPoint)offset
{
    NSMutableArray *piecesToMove = [NSMutableArray arrayWithObject:piece];
    CGPoint blankSpace = self.blankSpace;
    
    CGPoint currentLocation = [_grid pointForObject:piece];
    CGPoint tmpPoint = CGPointMake(offset.x + currentLocation.x, 
                                   offset.y + currentLocation.y);
    
    while (!CGPointEqualToPoint(tmpPoint, blankSpace)) {
        PuzzlePiece *tmpPiece = [_grid getObjectForPoint:tmpPoint];
        [piecesToMove addObject:tmpPiece];
        
        tmpPoint.x += offset.x;
        tmpPoint.y += offset.y;
    }
    
    return piecesToMove;
}

/*
 *  This method moves a piece (if it can be moved), and if you ask nicely, it'll animate the move.
 */
- (void)movePiece:(PuzzlePiece *)piece animated:(BOOL)animated
{
    // We'll be using these a lot, so get them now.
    CGFloat pieceViewSize = self.bounds.size.width / _gridSize;    
    CGPoint currentLocation = [_grid pointForObject:piece];
    
    CGPoint offset = [self _getOffset:piece];
    if (CGPointEqualToPoint(offset, CGPointZero)) {
        return;
    }
    NSMutableArray *piecesToMove = [self _getPiecesToMove:piece offset:offset];

    if (animated) {
        [UIView animateWithDuration:0.25 
                          animations:^{
                              // For each peice, animate it into it's new position.
                              for (PuzzlePiece *tmpPiece in piecesToMove) {
                                  CGPoint pieceLocation = [_grid pointForObject:tmpPiece];
                                  CGPoint originalCenter = CGPointMake((pieceLocation.x * pieceViewSize) + (pieceViewSize * .5), 
                                                                       (pieceLocation.y * pieceViewSize) + (pieceViewSize * .5));
                                  originalCenter.x += (offset.x * pieceViewSize);
                                  originalCenter.y += (offset.y * pieceViewSize);
                                  tmpPiece.center = originalCenter;
                              }
                          }
                          completion:^(BOOL finished) {
                              // Now we update the data in the grid.
                              for (PuzzlePiece *tmpPiece in [piecesToMove reverseObjectEnumerator]) {
                                  CGPoint pieceLocation = [_grid pointForObject:tmpPiece];
                                  pieceLocation.x += offset.x;
                                  pieceLocation.y += offset.y;
                                  [_grid setObject:tmpPiece forPoint:pieceLocation];
                              }
                              [_grid setObject:[NSNull null] forPoint:currentLocation];
                              // If the gird is solved, throw up the solved modal. Should probably be a method I call, 
                              // but hey, we all make mistakes.
                              if ([_grid isSolved]) {
                                  [_solvedView setHidden:NO];
                                  [self bringSubviewToFront:_solvedView];
                              }
                          }];
    } else {
        // Same as above, just don't bother animating anything.
        for (PuzzlePiece *tmpPiece in [piecesToMove reverseObjectEnumerator]) {
            CGPoint pieceLocation = [_grid pointForObject:tmpPiece];
            pieceLocation.x += offset.x;
            pieceLocation.y += offset.y;
            [_grid setObject:tmpPiece forPoint:pieceLocation];
            
            CGPoint tempCenter = tmpPiece.center;
            tempCenter.x += (offset.x * pieceViewSize);
            tempCenter.y += (offset.y * pieceViewSize);
            tmpPiece.center = tempCenter;
        }
        [_grid setObject:[NSNull null] forPoint:currentLocation];
        if ([_grid isSolved]) {
            [_solvedView setHidden:NO];
            [self bringSubviewToFront:_solvedView];
        }
    }
    
}

- (void)panned:(UIPanGestureRecognizer *)gesture
{
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)gesture translationInView:self];
    
    CGPoint offset = [self _getOffset:(PuzzlePiece *)gesture.view];
    if (CGPointEqualToPoint(offset, CGPointZero)) {
        return;
    }
    NSMutableArray *piecesToMove = [self _getPiecesToMove:(PuzzlePiece *)gesture.view offset:offset];
    
    CGFloat pieceViewSize = self.bounds.size.width / _gridSize;
    
    CGPoint touchOffset = CGPointZero;
    // We only want to animate along the axis that we can move on.
    if (offset.x == 0) {
        if (offset.y == 1 && (translatedPoint.y > 0)) {
            touchOffset.y = translatedPoint.y;
        }
        
        if (offset.y == -1 && (translatedPoint.y < 0)) {
            touchOffset.y = translatedPoint.y;
        }
    }
    
    if (offset.y == 0) {
        if (offset.x == 1 && (translatedPoint.x > 0)) {
            touchOffset.x = translatedPoint.x;
        }
        
        if (offset.x == -1 && (translatedPoint.x < 0)) {
            touchOffset.x = translatedPoint.x;
        }
    }
    
    // For each piece that could be moved by this pan, pan it over.
    for (PuzzlePiece *piece in piecesToMove) {
        CGPoint currentLocation = [_grid pointForObject:piece];
        CGPoint originalCenter = CGPointMake((currentLocation.x * pieceViewSize) + (pieceViewSize * .5), 
                                             (currentLocation.y * pieceViewSize) + (pieceViewSize * .5));
        originalCenter.x += touchOffset.x;
        originalCenter.y += touchOffset.y;
        [piece setCenter:originalCenter];
    }
    
    // If the pan has ended, we need to animate back to the starting position or 
    // forward to the completed move
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (fabs(touchOffset.x + touchOffset.y) > (pieceViewSize /2)) {
            [self movePiece:(PuzzlePiece *)gesture.view animated:YES];
        } else {
            [UIView animateWithDuration:.25 
                             animations:^{
                                 for (PuzzlePiece *piece in piecesToMove) {
                                     CGPoint currentLocation = [_grid pointForObject:piece];
                                     CGPoint originalCenter = CGPointMake((currentLocation.x * pieceViewSize) + (pieceViewSize * .5), 
                                                                          (currentLocation.y * pieceViewSize) + (pieceViewSize * .5));
                                         [piece setCenter:originalCenter];
                                     }
                                 }];
        }
    }
}

- (void)setPuzzleImage:(UIImage *)image
{
    // Make sure the image is square
    CGSize imageSize = [image size];
    if (imageSize.width != imageSize.height) {
        CGRect cropRect;
        if (imageSize.width < imageSize.height) {
            cropRect = CGRectMake(0, 0, imageSize.width, imageSize.width);
        } else {
            cropRect = CGRectMake(0, 0, imageSize.height, imageSize.height);
        }
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
        image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }
    
    _puzzleImage = image;
    // Update each piece.
    for (PuzzlePiece *piece in [_grid allObjects]) {
        if ([piece respondsToSelector:@selector(setImage:)]) {
            [piece setImage:_puzzleImage];
        }
    }
}

- (void)tapped:(UITapGestureRecognizer *)gesture
{
    [self movePiece:(PuzzlePiece *)gesture.view animated:YES];
}

@end

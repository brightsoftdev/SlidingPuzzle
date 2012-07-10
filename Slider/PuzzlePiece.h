//
//  PuzzlePiece.h
//  Slider
//
//  Created by Chris Sinchok on 7/5/12.
//
//  This is a UIControl that really doesn't need to be a UIControl. It's just a simple view with 
//  an init method that allows it to setup the proper background for a grid, given a large image 
//  and the final location of this piece.
//

#import <UIKit/UIKit.h>

@interface PuzzlePiece : UIControl {
    NSUInteger _gridSize;
    CGPoint _goalLocation;
    UIImageView *_imageView;
}

@property (nonatomic, readonly) CGPoint goalLocation;
@property (nonatomic, readonly) NSUInteger gridSize;

- (id)initWithImage:(UIImage *)image location:(CGPoint)location gridSize:(NSUInteger)gridSize frame:(CGRect)frame;
- (id)initWithImage:(UIImage *)image location:(CGPoint)location frame:(CGRect)frame;
- (void)setImage:(UIImage *)image;
@end

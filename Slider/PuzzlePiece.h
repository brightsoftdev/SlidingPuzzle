//
//  PuzzlePiece.h
//  Slider
//
//  Created by Chris Sinchok on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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

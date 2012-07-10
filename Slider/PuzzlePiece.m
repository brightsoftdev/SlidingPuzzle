//
//  PuzzlePiece.m
//  Slider
//
//  Created by Chris Sinchok on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzlePiece.h"
#import <QuartzCore/QuartzCore.h>

@implementation PuzzlePiece
@synthesize goalLocation = _goalLocation;
@synthesize gridSize = _gridSize;

- (id)initWithImage:(UIImage *)image location:(CGPoint)location frame:(CGRect)frame
{
    return [self initWithImage:image location:location gridSize:4 frame:(CGRect)frame];
}

- (id)initWithImage:(UIImage *)image location:(CGPoint)location gridSize:(NSUInteger)gridSize frame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];    
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        
        _goalLocation = location;
        _gridSize = gridSize;
        
        _imageView = [[UIImageView alloc] init];
        [_imageView setExclusiveTouch:NO];
        [_imageView setUserInteractionEnabled:NO];
        [_imageView setFrame:(CGRect){CGPointZero, self.frame.size}];
        [self addSubview:_imageView];
        
        [self setImage:image];
    }

    return self;
}

- (void)setImage:(UIImage *)image{
    // Crop the image (we assume it's already square)
    CGFloat imageSize = image.size.width / _gridSize;
    CGRect cropRect = CGRectMake(imageSize * _goalLocation.x, 
                                 imageSize * _goalLocation.y, 
                                 imageSize,
                                 imageSize);
    
    CGFloat scale = (imageSize / self.frame.size.width);    
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    UIImage *puzzlePieceImage = [UIImage imageWithCGImage:imageRef 
                                                    scale:scale 
                                              orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    
    [_imageView setImage:puzzlePieceImage];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[PuzzlePiece class]]) {        
        if (CGPointEqualToPoint([(PuzzlePiece *)object goalLocation], self.goalLocation)) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[PuzzlePiece %g,%g]", self.goalLocation.x, self.goalLocation.y];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  ViewController.m
//  Slider
//
//  Created by Chris Sinchok on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "SliderPuzzleView.h"
#import <AudioToolbox/AudioServices.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat viewWidth = UIScreen.mainScreen.bounds.size.width;
    _puzzle = [[SliderPuzzleView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth)];
    [self.view addSubview:_puzzle];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (IBAction)shuffle:(id)sender
{
    [_puzzle shuffle];
}

- (IBAction)choosePhoto:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    [self presentModalViewController:picker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissModalViewControllerAnimated:YES];
    if (newImage) {
        [_puzzle setPuzzleImage:newImage];
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [_puzzle shuffle];
    }
}

- (BOOL)canBecomeFirstResponder
{ 
    return YES;
}

@end

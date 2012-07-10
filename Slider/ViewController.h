//
//  ViewController.h
//  Slider
//
//  Created by Chris Sinchok on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderPuzzleView.h"

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    SliderPuzzleView *_puzzle;
}

- (IBAction)shuffle:(id)sender;
- (IBAction)choosePhoto:(id)sender;
 
@end

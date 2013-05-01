//
//  ViewController.h
//  SightReader
//
//  Created by Steve on 02/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardAuto.h"
#import "AutoLayoutGameViewController.h"

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, KeyPressedDelegate, AutoLayoutGameViewControllerProtocol>
@property (weak, nonatomic) IBOutlet UIPickerView *optionPicker;
- (IBAction)GoToAutoLayoutViewController:(id)sender;


@end

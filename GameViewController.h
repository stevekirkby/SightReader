//
//  GameViewController.h
//  SightReader
//
//  Created by Steve on 02/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keyboard.h"
#import "KeyboardAuto.h"

@interface GameViewController : UIViewController <KeyPressedDelegate>
- (IBAction)nextNoteAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *currentNoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *keyPressedLabel;
@property (weak, nonatomic) IBOutlet UILabel *scorelabel;
@property (strong, nonatomic) IBOutlet UIView *background;

@property (nonatomic, strong) NSString *currentKey;
@property (nonatomic, strong) NSString *currentClef1;
@end
    
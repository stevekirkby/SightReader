//
//  Keyboard.h
//  SightReader
//
//  Created by Steve on 05/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyboardDelegate <NSObject>
@required
-(void)keyBoardButtonPressed:(int)tag;

@end

@interface Keyboard : UIView
@property (nonatomic, assign) id <KeyboardDelegate> delegate;

- (IBAction)keyPressedAction:(id)sender;

@end

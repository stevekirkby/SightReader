//
//  Keyboard.m
//  SightReader
//
//  Created by Steve on 05/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import "Keyboard.h"

@implementation Keyboard



- (void)awakeFromNib {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)keyPressedAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(keyBoardButtonPressed:)]) {
        [self.delegate keyBoardButtonPressed:((UIButton *)sender).tag];
    } else {
        CUSTOMEXCEPTION(@"Keyboard delegate does not respond to KeyboardDelegate protocol")
    }
    
}

- (void)highlightKey:(int)keyBoardKeyTohighlight {
    for (UIButton *keyBoardKeyButton in self.subviews) {
        if (keyBoardKeyButton.tag == keyBoardKeyTohighlight) {
            [keyBoardKeyButton setBackgroundColor:[UIColor lightGrayColor]];
            
        } else {
            [keyBoardKeyButton setBackgroundColor:[UIColor whiteColor]];
        }
    }
}
@end

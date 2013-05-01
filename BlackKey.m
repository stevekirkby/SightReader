//
//  BlackKey.m
//  SightReader
//
//  Created by House on 08/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import "BlackKey.h"
#import "ColorManager.h"

@implementation BlackKey

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.keyIsHighlighted = 1;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[self(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
    }
    return self;
}

- (id)initWithKeyID:(NSMutableArray *)keyID {
    self = [self initWithFrame:CGRectZero];
    if (![_keyID isEqualToArray:keyID]) {
        _keyID = keyID;
    }
    return self;
}

- (void)setKeyIsHighlighted:(BOOL)keyIsHighlighted {
    if (keyIsHighlighted != _keyIsHighlighted || !_keyIsHighlighted) {
        _keyIsHighlighted = keyIsHighlighted;
        if (keyIsHighlighted == 1) {
            [self setBackgroundColor:[ColorManager returnBlackKeyHighlightedColor]];
        } else {
            [self setBackgroundColor:[ColorManager returnBlackKeyColor]];
        }
    }
}


@end

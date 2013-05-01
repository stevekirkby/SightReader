//
//  WhiteKey.m
//  SightReader
//
//  Created by House on 08/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import "WhiteKey.h"
#import "ColorManager.h"

@interface WhiteKey ()

@end

@implementation WhiteKey

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setBackgroundColor:[ColorManager returnWhiteKeyColor]];
        self.keyIsHighlighted = 0;
        // [self addConstraint: [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.2 constant:1.0]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute: NSLayoutAttributeHeight multiplier:0.3 constant:0.0]];
        

    }
    return self;
}


- (id)initWithKeyID:(NSMutableArray *)keyID {
    if (![_keyID isEqualToArray:keyID]) {
        _keyID = keyID;
    }

    self = [self initWithFrame:CGRectZero];

    return self;
}

- (void)setKeyIsHighlighted:(BOOL)keyIsHighlighted {
    if (keyIsHighlighted != _keyIsHighlighted || !_keyIsHighlighted) {
        _keyIsHighlighted = keyIsHighlighted;
        if (keyIsHighlighted == 1) {
            [self setBackgroundColor:[ColorManager returnWhiteKeyHighlightedColor]];
        } else {
            [self setBackgroundColor:[ColorManager returnWhiteKeyColor]];
        }
    }
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

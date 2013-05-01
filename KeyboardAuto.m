//
//  keyboardAuto.m
//  SightReader
//
//  Created by House on 08/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import "KeyboardAuto.h"
#import "BlackKey.h"
#import "WhiteKey.h"

@interface KeyboardAuto ()
@property (nonatomic, assign) id <KeyPressedDelegate> delegate;
@property (nonatomic) NSMutableArray *keyID;
@end

@implementation KeyboardAuto

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _keyID = @[@"0", @"0"].mutableCopy;
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(220)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
        // [self setBackgroundColor:[UIColor redColor]];
        UIView *multiOctaveView = [self keyboardWithOctaves:2];
        [multiOctaveView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:multiOctaveView];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[multiOctaveView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(multiOctaveView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[multiOctaveView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(multiOctaveView)]];
        // [self  highLightNotesForKey:@"G_Major"];
    }
    return self;
}

- (id)initWithDelegate:(id)delegate {
    _delegate = delegate;
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (UIView *)keyboardWithOctaves:(int)octaves {
    UIView *multiOctaveView = [[UIView alloc] init];
    [multiOctaveView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSMutableArray *keyboardArray=[[NSMutableArray alloc] init];
    for (int i = 0; i<octaves; i++) {
        UIView *octaveView = [self octaveContainerStartingAtNote:0 andEndingAtNote:6];
        [octaveView setBackgroundColor:[UIColor clearColor]];
        [multiOctaveView addSubview:octaveView];
        [multiOctaveView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[octaveView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(octaveView)]];
        [keyboardArray addObject:octaveView];
    }       
    
    UIView *firstView = [keyboardArray objectAtIndex:0];
    // [multiOctaveView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[firstView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(firstView)]];
    [multiOctaveView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(5)-[firstView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(firstView)]];
    
    UIView *lastView = [keyboardArray lastObject];
    [multiOctaveView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lastView]-(5)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lastView)]];
    UIView *previousView = nil;
    for (UIView *octaveView in keyboardArray) {
        if (previousView) {
            NSDictionary *viewsDict = NSDictionaryOfVariableBindings(octaveView, previousView);
            [multiOctaveView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousView]-(5)-[octaveView]" options:NSLayoutFormatAlignAllTop metrics:nil views:viewsDict]];
            [multiOctaveView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousView(==octaveView)]" options:0 metrics:nil views:viewsDict]];
        }
        previousView = octaveView;
    }
    
    return multiOctaveView;
}

- (UIView *)octaveContainerStartingAtNote:(int)startingNoteValue andEndingAtNote: (int)endingNoteValue {
    int whiteKeyValue = startingNoteValue;
    UIView *octaveView = [[UIView alloc] init];
    [octaveView setTranslatesAutoresizingMaskIntoConstraints:NO];    
    NSMutableArray *octaveArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<7; i++) {
        WhiteKey *whiteKeyView = [self whiteKey];
        [octaveView addSubview:whiteKeyView];
        [octaveArray addObject:whiteKeyView];
        if (whiteKeyValue == 0 || whiteKeyValue == 1 || whiteKeyValue == 3 || whiteKeyValue == 4 || whiteKeyValue == 5) {
            BlackKey *blackKeyView = [self blackKey];
            [octaveView addSubview:blackKeyView];
            [octaveArray addObject:blackKeyView];
        }
        whiteKeyValue ++;
    }
    
    UIView *firstView = [octaveArray objectAtIndex:0];
    [octaveView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[firstView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(firstView)]];

    UIView *lastView = [octaveArray lastObject];
    [octaveView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lastView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lastView)]];
    
    id previousView = nil;
    for (id keyView in octaveArray) {
        if ([keyView isKindOfClass:[WhiteKey class]]){
            [octaveView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[keyView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(keyView)]];
            if (previousView) {
                NSDictionary *viewsDict = NSDictionaryOfVariableBindings(keyView, previousView);
                [octaveView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousView]-(5)-[keyView]" options:0 metrics:nil views:viewsDict]];
                [octaveView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousView(==keyView)]" options:0 metrics:nil views:viewsDict]];
            }
            previousView = keyView;
        } else if ([keyView isKindOfClass:[BlackKey class]]) {
            [octaveView addConstraint: [NSLayoutConstraint constraintWithItem:keyView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:octaveView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
            [octaveView addConstraint:[NSLayoutConstraint constraintWithItem:keyView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:octaveView attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0.0]];
            [octaveView addConstraint: [NSLayoutConstraint constraintWithItem:keyView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeRight multiplier:1.0 constant:2.5]]; // constant equal to the half the constant width
        }
    }
    for (UIView *key in octaveView.subviews) {
        if ([key isKindOfClass:[BlackKey class]]) {
            [octaveView bringSubviewToFront:key];
        }
    }
    return octaveView;
}

- (WhiteKey *)whiteKey {
    WhiteKey *key = [[WhiteKey alloc] initWithKeyID:[_keyID copy]];
    [self incrementKeyId];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(keyPressed:)];
    [key addGestureRecognizer:tapGesture];
    return key;
}

- (BlackKey *)blackKey{
    BlackKey *key = [[BlackKey alloc] initWithKeyID:[_keyID copy]];
    [self incrementKeyId];
    [key setBackgroundColor:[UIColor blackColor]];
    [key setTranslatesAutoresizingMaskIntoConstraints:NO];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(keyPressed:)];
    [key addGestureRecognizer:tapGesture];
    return key;
}

- (void)incrementKeyId {
    int octave = [[_keyID objectAtIndex:0] intValue];
    int keyNoteIndex = [[_keyID objectAtIndex:1] intValue];    
    if (keyNoteIndex == 11){
        octave++;
        keyNoteIndex = 0;
        [_keyID replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d", octave]];
        [_keyID replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d", keyNoteIndex]];
    } else {
        keyNoteIndex++;
        [_keyID replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d", keyNoteIndex]];
    }
}

- (void)highLightNotesForKey:(NSString *)key {
    // [[ModelConstants sharedStore]returnNotesArrayForKey:key];
}

//- (void)incrementKeyId {
//    unichar letter = [[_keyID objectAtIndex:0] characterAtIndex:0];
//    letter ++;
//    NSString *incrementedLetter = [NSString stringWithCharacters:&letter length:1];
//    [_keyID replaceObjectAtIndex:0 withObject: incrementedLetter];
//    if ([[_keyID objectAtIndex:0] isEqualToString:@"H"]) {
//        [_keyID replaceObjectAtIndex:0 withObject: @"A"];
//    }
//    if ([[_keyID objectAtIndex:0] isEqualToString:@"C"]) {
//        int currentNumber = [[_keyID objectAtIndex:1] intValue];
//        NSString *replaceWithKeyNumber = [NSString stringWithFormat:@"%d", ++currentNumber];
//        [_keyID replaceObjectAtIndex:1 withObject: replaceWithKeyNumber];
//    }
//}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

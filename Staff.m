//
//  Staff.m
//  SightReader
//
//  Created by Steve Kirkby on 04/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import "Staff.h"

@interface Staff ()

@property (nonatomic, strong) UIImageView *clefImageView;
@property (nonatomic, strong) UIImageView *keyImageView;
@property (nonatomic, strong) UIImageView *noteImageView;
@end

@implementation Staff


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        if (!_clefName) {
            _clefName=@"treble";
        }
        if (!_keyName) {
            _keyName=@"C_Major";
        }
        
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self constructStaffImages];
    }
    return self;
}

- (void)setNoteName:(NSString *)noteName {
    if (_noteName != noteName) {
        _noteName = noteName;
        _noteImageView.image = [UIImage imageNamed:noteName];
        // DLog(@"notename is %@", noteName);
    }
}


- (id)initWithClef:(NSString *)clefName andKey:(NSString *)keyName
{
    if (_clefName !=clefName) {
        _clefName = clefName;
    }
    if (_keyName != keyName) {
        _keyName = keyName;
    }
    _noteName = @"noNote.png";
    
    return [self initWithFrame:CGRectZero];
}


- (void)constructStaffImages {
    _clefImageView = [self returnClefImage:_clefName];
    [self addSubview:_clefImageView];
    
    _keyImageView = [self returnKeyImage:_keyName];
    [self addSubview:_keyImageView];
    
    _noteImageView = [self returnNoteImage:_noteName];
    [self addSubview:_noteImageView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_clefImageView][_keyImageView][_noteImageView]|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_clefImageView, _keyImageView, _noteImageView )]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_clefImageView]-(-30)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_clefImageView)]];
}

- (UIImageView *) returnClefImage:(NSString *)clefName {
    NSString *imageName=clefName;
    imageName = ([clefName isEqualToString:@"treble"]) ? @"trebleClefOLD.png" : @"bassClefOLD.png";
    UIImageView *clefImageView = [self returnRightSizedImageForImageWithName:imageName];
    return clefImageView;
}

- (void)changeClefImageTo:(NSString *)clefName {
    [self setClefName: clefName];
    NSString *imageName = ([clefName isEqualToString:@"treble"]) ? @"trebleClefOLD.png" : @"bassClefOLD.png";
    UIImageView *clefImageView = [self returnRightSizedImageForImageWithName:imageName];
    _clefImageView.image = clefImageView.image;
}

- (void)changeKeyImageTo:(NSString *)keyName {
    [self setKeyName: keyName];
    // NSString *imageName = keyName;
    NSString *imageName = [[ModelConstants sharedStore] imageNameForKey:keyName andClef:_clefName];
    UIImageView *keyImageView = [self returnRightSizedImageForImageWithName:imageName];
    _keyImageView.image = keyImageView.image;
}

- (UIImageView *) returnKeyImage:(NSString *)keyName {
    // NSString *imageName = keyName;
    NSString *imageName = [[ModelConstants sharedStore] imageNameForKey:keyName andClef:_clefName];
    UIImageView *keyImageView = [self returnRightSizedImageForImageWithName:imageName];
    return keyImageView;
}

- (UIImageView *) returnNoteImage:(NSString *)noteName {
    NSString *imageName = noteName;
    UIImageView *noteImageView = [self returnRightSizedImageForImageWithName:imageName];
    return noteImageView;
}

- (UIImageView *)returnRightSizedImageForImageWithName: (NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSNumber *height = [NSNumber numberWithFloat: image.size.height*IMAGEREDUCTION];
    NSNumber *width = [NSNumber numberWithFloat: image.size.width*IMAGEREDUCTION];
    [imageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageView(height)]" options:0 metrics:NSDictionaryOfVariableBindings(height) views:NSDictionaryOfVariableBindings(imageView)]];
    [imageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView(width)]" options:0 metrics:NSDictionaryOfVariableBindings(width) views:NSDictionaryOfVariableBindings(imageView)]];
    imageView.image = image;
    return imageView;
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

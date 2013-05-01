//
//  StaffAutoLean.m
//  SightReader
//
//  Created by Steve on 23/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import "StaffAutoLean.h"

@interface StaffAutoLean ()
@property (nonatomic, strong) NSMutableArray *noteYLocations;
@property (nonatomic, strong) NSMutableArray *lineLocations;
@property (nonatomic, strong) NSMutableArray *staffLocations;
@property (nonatomic, strong) NSMutableArray *lowerLineLocations;
@property (nonatomic, strong) NSMutableArray *upperLineLocations;
@property (nonatomic, strong) NSMutableArray *subSuperLineLayers;
@property (nonatomic, strong) NSMutableArray *additionalLineYLocationsArray;
@property (nonatomic, assign) CGFloat staffWidth; // for adding spacers
@property (nonatomic, assign) CGFloat staffHeight; 
@property (nonatomic, assign) CGFloat additionalLineWidth;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) CGFloat subSuperlineWidth;
@property (nonatomic, assign) CGFloat semiToneWidth;
@property (nonatomic, assign) CGFloat startLocation;

@property (nonatomic) int staffStart;
@property (nonatomic) int staffEnd;
@property (nonatomic) int totalNotes;
@property (nonatomic, getter=isSpacer) BOOL spacerFlag;
@property (nonatomic, getter=isClef) BOOL clefFlag;
@property (nonatomic, getter=isKey) BOOL keyFlag;

@end

@implementation StaffAutoLean

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setupDefaultValues];
        [self setupStaffSizing];
        [self setupYLocations];
        // [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)setClef:(NSString *)clef {
    if (_clef !=clef) {
        _clef = clef;
    }
}

- (void)setKey:(NSString *)key {
    if (_key !=key) {
        _key = key;
    }
}

- (void)drawKeyOnStaff {
    
    NSDictionary *keyLocationsAndImageType = [[ModelConstants sharedStore] keyLocationsRelativeToLowestStaffLineForKey:_key andClef:_clef];
    NSString *imageType = [keyLocationsAndImageType objectForKey:@"sharpOrFlat"];
    NSArray *keyLocationReferences = [keyLocationsAndImageType objectForKey:@"markerLocations"];
    
    UIImage *imageToUse;
    if ([imageType isEqualToString:@"sharp"]) {
        imageToUse = [UIImage imageNamed: kSINGLESHARPIMAGE];
    } else if ([imageType isEqualToString:@"flat"]) {
        imageToUse = [UIImage imageNamed: kSINGLEFLATIMAGE];
    }
    
    CGPoint anchorPoint;
    NSMutableArray *markerImagesArray = @[].mutableCopy;
    CGFloat xPosition = 0;
    CGFloat desiredImageHeight;
    CGAffineTransform t;
    
    CGFloat currentImageHeight = imageToUse.size.height;


    if ([imageType isEqualToString:@"sharp"]) {
        desiredImageHeight = 6.*_semiToneWidth;
        CGFloat scalingRequired = (desiredImageHeight/currentImageHeight);
        t = CGAffineTransformMakeScale(scalingRequired, scalingRequired);
        anchorPoint = CGPointMake(0., 0.5);
    } else if ([imageType isEqualToString:@"flat"]) {
        CGFloat scalingRequired = (_semiToneWidth)/(currentImageHeight*(15./73.));
        t = CGAffineTransformMakeScale(scalingRequired, scalingRequired);
        anchorPoint = CGPointMake(0., 58./73.);
    }
    
    for (NSNumber *markerLocations in keyLocationReferences) {
        CGFloat relativePosition = [markerLocations floatValue] * _semiToneWidth;
        CGFloat lowestYPositonOnStaff = [[_staffLocations objectAtIndex:0] floatValue];
        CGFloat actualMarkerPosition =  lowestYPositonOnStaff-relativePosition;
        
        UIImageView *keyMarker = [[UIImageView alloc] initWithImage:imageToUse];
        [keyMarker.layer setAnchorPoint:anchorPoint];
        
        CGRect markerFrame = CGRectMake(xPosition, actualMarkerPosition, keyMarker.frame.size.width, keyMarker.frame.size.height);
        [keyMarker setFrame:markerFrame];
        
        [keyMarker setTransform:t];
        [keyMarker.layer setPosition:CGPointMake(xPosition, actualMarkerPosition)];
        [markerImagesArray addObject:keyMarker];
        xPosition = xPosition+keyMarker.frame.size.width+1;
    }
    
    for (UIImageView *keyMarkerImage  in markerImagesArray) {
        [self addSubview:keyMarkerImage];
    }

    // convert marker references to yPosition

}

- (void)drawClefOnStaff {
    CGFloat desiredHeight;
    NSString *imageName;
    CGPoint anchorPoint;
    if ([_clef isEqualToString:@"treble"]) {
        imageName = kTREBLECLEFIMAGE;
        desiredHeight = (_semiToneWidth *10)*1.22;
        anchorPoint = CGPointMake(0., 0.5);
    }
    if ([_clef isEqualToString:@"bass"]) {
        imageName = kBASSCLEFIMAGE;
        desiredHeight = (_semiToneWidth *10.)*0.7;
        anchorPoint = CGPointMake(0., 0.);
    }
    
    
    UIImage *clefImage = [UIImage imageNamed:imageName];
    UIImageView *clef = [[UIImageView alloc] initWithImage:clefImage];
    
    CGFloat yPosition=0;
    if ([_clef isEqualToString:@"treble"]) {
        yPosition = 120.;
    }
    if ([_clef isEqualToString:@"bass"]) {
        CGFloat highestStaffLine = [[_staffLocations lastObject] floatValue];
        yPosition = highestStaffLine;
    }
    
    [clef.layer setAnchorPoint:anchorPoint];
    [clef setFrame:CGRectMake(CGRectGetMinX(self.bounds), yPosition, clefImage.size.width, clefImage.size.height)];
    [clef setTransform:CGAffineTransformMakeScale(desiredHeight/100., desiredHeight/100.)];
    // [self addConsistentShadowToLayer:clef.layer];
    [self addSubview:clef];
}

- (void)addConsistentShadowToLayer: (CALayer *)myLayer {
    myLayer.shadowColor = [UIColor blackColor].CGColor;
    myLayer.shadowOpacity = 0.7f;
    myLayer.shadowOffset = CGSizeMake(0.0f, 10.0f);
    myLayer.shadowRadius = 5.0f;
    myLayer.masksToBounds = NO;
}

-(void)setupDefaultValues {
    // constants
    _staffStart = 13; // staff will start drawing on line 13
    _staffEnd = 13+9;
    _totalNotes=40;
    _semiToneWidth=8;
    _startLocation = 300.;
    _staffHeight = 300.;
    _lineHeight = 1.;
    _additionalLineWidth = 40.;
    _noteYLocations = @[].mutableCopy;
    _staffLocations = @[].mutableCopy;
    
    // setup
    if (self.isSpacer == YES) {
        _staffWidth = 100;
    } else if (self.isClef == YES) {
        _staffWidth = 60;
    } else if (self.isKey == YES) {
        _staffWidth = 130; }
    else {
        _staffWidth = 50;
        _subSuperlineWidth = 50.;
        _lowerLineLocations = @[].mutableCopy;
        _upperLineLocations = @[].mutableCopy;
    }
}

-(void)setupYLocations {
    // model (yes, in a View)
    // Note:- starting at A0, lines will always be drawn on odd numbers
    CGFloat yLocation = _startLocation;
    for (int i = 0; i<_totalNotes; i++) {
        // setup note locations
        [_noteYLocations addObject: [NSNumber numberWithFloat:yLocation]];
        if (i>=_staffStart && i<_staffEnd & i%2==1) {
            // set up staff locations
            [_staffLocations addObject:[NSNumber numberWithFloat:yLocation]];
        }
        if (self.isSpacer != YES && self.isClef !=YES && self.isKey !=YES ){
            if (i<_staffStart && i%2!=0) {
                [_lowerLineLocations addObject:[NSNumber numberWithFloat:yLocation]];
            }
            if (i>_staffEnd && i%2!=0) {
                [_upperLineLocations addObject:[NSNumber numberWithFloat:yLocation]];
            }
        }
        
        yLocation = yLocation - _semiToneWidth;
    }
    
    NSArray* reversedArray = [[_lowerLineLocations reverseObjectEnumerator] allObjects];
    _lowerLineLocations = reversedArray.mutableCopy;
}

-(id)initAsSpacer {
    [self setSpacerFlag:YES];
    self = [self initWithFrame:CGRectZero];
    return self;
}

-(id)initAsClef:(NSString *)clef {
    [self setClefFlag:YES];
    [self setClef:clef];
    self = [self initWithFrame:CGRectZero];
    [self drawClefOnStaff];
    return self;
}

-(id)initAsKey:(NSString *)key withClef:(NSString *)clef {
    [self setKeyFlag:YES];
    [self setKey:key];
    [self setClef:clef];
    self = [self initWithFrame:CGRectZero];
    [self drawKeyOnStaff];
    return self;
}


- (void)setupStaffSizing {
    NSNumber *staffHeightObject = [NSNumber numberWithFloat:_staffHeight];
    NSNumber *staffWidthObject = [NSNumber numberWithFloat:_staffWidth];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(staffHeightObject)]" options:0 metrics:NSDictionaryOfVariableBindings(staffHeightObject) views:NSDictionaryOfVariableBindings(self)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[self(staffWidthObject)]" options:0 metrics:NSDictionaryOfVariableBindings(staffWidthObject) views:NSDictionaryOfVariableBindings(self)]];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, self.bounds);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 2.);
    for (id yLocationObject in _staffLocations) {
        CGFloat yLocation = [yLocationObject floatValue];
        CGContextMoveToPoint(context, 0, yLocation); //start at this point
        CGContextAddLineToPoint(context, _staffWidth, yLocation); //start at this point
    }
    CGContextStrokePath(context); // Draw the path

}

- (void) presentNote:(NSNumber*)noteNumber {
    [self presentStaffForNote:noteNumber];
    [self presentNoteImage:noteNumber];
}


- (void) presentStaffForNote:(NSNumber*)noteNumber {
    _subSuperLineLayers = @[].mutableCopy;
    NSArray *locationArray = @[];
    int noteInt = [noteNumber intValue];
    CGFloat lineStartLocation;
    int numberOfSubSuperLinesToPresentForNote = 0;
    if (noteInt <=12 || noteInt >= 23) {
        if (noteInt <=12) {
            lineStartLocation =  [[_staffLocations objectAtIndex:0] floatValue];
            numberOfSubSuperLinesToPresentForNote = 6-noteInt/2;
            locationArray = _lowerLineLocations;
        }
        if (noteInt >=23) {
            numberOfSubSuperLinesToPresentForNote = (noteInt-21)/2;
            lineStartLocation =  [[_staffLocations lastObject] floatValue];
            locationArray = _upperLineLocations;
        }
    
        _additionalLineYLocationsArray = [locationArray subarrayWithRange:NSMakeRange(0, numberOfSubSuperLinesToPresentForNote)].mutableCopy;
    
        if ([_additionalLineYLocationsArray count] !=0) {
            for (id yLocationObject in _additionalLineYLocationsArray) {
                CALayer *lineLayer = [CALayer layer];
                [lineLayer setBorderWidth:_lineHeight];
                [lineLayer setBorderColor:[UIColor blackColor].CGColor];
                [lineLayer setBounds:CGRectMake(0, 0, _additionalLineWidth, 1)];
                [lineLayer setAnchorPoint:CGPointMake(0.0, 0.5)];
                [lineLayer setPosition:CGPointMake(0, lineStartLocation)];
                [_subSuperLineLayers addObject:lineLayer];
                [self.layer addSublayer:lineLayer];
            }
        }
    }
    [self animateSubSuperReveal];
}

- (void)animateSubSuperReveal {
    CGFloat timeOffset = 0;
    [CATransaction begin];
    for (int i = 0; i <[_subSuperLineLayers count]; i++) {
        CALayer *layer = [_subSuperLineLayers objectAtIndex:i];
        CGFloat yPosition = [[_additionalLineYLocationsArray objectAtIndex:i] floatValue];
    
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position.y"];
        anim.fromValue = [NSNumber numberWithFloat:layer.position.y];
        layer.position = CGPointMake(layer.position.x,yPosition);
        anim.toValue = [NSNumber numberWithFloat:yPosition];
        anim.beginTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil] + timeOffset;
        anim.duration = 0.3;
        [layer addAnimation:anim forKey:nil];
    }
    [CATransaction commit];
    
    DLog(@"additionalLineYLocations = %@", [_additionalLineYLocationsArray description]);
}

- (void) presentNoteImage:(NSNumber*)noteNumber {
    CGFloat yLocationOfNote = [[_noteYLocations objectAtIndex:([noteNumber intValue])] floatValue];
    CALayer *noteLayer = [self scaledNoteImageForNoteNumber:noteNumber];
    
    [noteLayer setPosition:CGPointMake(_additionalLineWidth/2, yLocationOfNote)];
    [self.layer addSublayer:noteLayer];
    DLog(@"notelayer y position is %f", noteLayer.position.y);
}

- (CALayer *)scaledNoteImageForNoteNumber:(NSNumber*)noteNumber {
    CALayer *noteLayer = [CALayer layer];
    UIImage *noteImage = [UIImage imageNamed:@"singleNote.png"];
    CGFloat ballHeight = (27./132.)*noteImage.size.height; // height of the ball
    CGFloat transformRatio = (_semiToneWidth * 2)/ballHeight;
    [noteLayer setContents:(id)noteImage.CGImage];
    [noteLayer setTransform:CATransform3DMakeScale(transformRatio, transformRatio, 1.)];
    [noteLayer setBounds:CGRectMake(0, 0, noteImage.size.width, noteImage.size.height)];
    [noteLayer setAnchorPoint:CGPointMake(0.5, 12./127.)]; // don't forget the decimal point when adding floats together
    [self addConsistentShadowToLayer:noteLayer];
    return noteLayer;
}

@end

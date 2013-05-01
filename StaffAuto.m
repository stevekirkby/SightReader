//
//  StaffAuto.m
//  SightReader
//
//  Created by Steve on 10/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import "StaffAuto.h"
@interface StaffAuto () {

}
@property (assign) CGFloat width;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (assign) CGFloat singleNoteSpacing;
@property (assign) int firstLineInStaffReference;
@property (assign) int lastLineInStaffReference;
@property (nonatomic, assign) CGFloat firstLineInStaffLocation;
@property (nonatomic, assign) CGFloat lineForB0;

@property (assign) CGFloat positionOfA0;
@property (assign) CGFloat lineForF5;
@property (nonatomic, strong) NSMutableArray *noteLocations;

@end



@implementation StaffAuto

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!_width) {
            _width = 50;
        }
        _noteLocations = @[].mutableCopy;
        [self setLineSpacing: 16];
        [self setLineForB0: 350];
        
        _firstLineInStaffReference = 7;
        _lastLineInStaffReference = _firstLineInStaffReference + 4;
        NSNumber *widthObject = [NSNumber numberWithFloat:_width];
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(300)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[self(widthObject)]" options:0 metrics:NSDictionaryOfVariableBindings(widthObject) views:NSDictionaryOfVariableBindings(self)]];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    if (_lineSpacing != lineSpacing) {
        _lineSpacing = lineSpacing;
        _singleNoteSpacing = lineSpacing/2;
    }
}

- (void)setLineForB0:(CGFloat)lineForB0 {
    if (_lineForB0 != lineForB0) {
        _lineForB0 = lineForB0;
        _positionOfA0 = _lineForB0 + _singleNoteSpacing;
        [_noteLocations addObject:[NSNumber numberWithFloat:_positionOfA0]];
    }
}

- (id)initWithSpacer {
    _width = 100;
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);    
    CGContextSetLineWidth(context, 1.0);
    CGFloat locationOfCurrentLineDrawnOrUndrawn = _lineForB0;
    for (int i=0; i<=21; i++) {
        [_noteLocations addObject:[NSNumber numberWithFloat:locationOfCurrentLineDrawnOrUndrawn]];
        [_noteLocations addObject:[NSNumber numberWithFloat:(locationOfCurrentLineDrawnOrUndrawn-_lineSpacing/2)]];
        if (i== _firstLineInStaffReference) {
            _firstLineInStaffLocation = locationOfCurrentLineDrawnOrUndrawn;
        }
        CGContextMoveToPoint(context, 0, locationOfCurrentLineDrawnOrUndrawn); //start at this point
        if (i >= _firstLineInStaffReference && i<=_lastLineInStaffReference) {
            CGContextAddLineToPoint(context, _width, locationOfCurrentLineDrawnOrUndrawn); //draw to this point
            if (i==_lastLineInStaffReference) {
                _lineForF5 = locationOfCurrentLineDrawnOrUndrawn;
            }
        }
        locationOfCurrentLineDrawnOrUndrawn = locationOfCurrentLineDrawnOrUndrawn - _lineSpacing;
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();    
    CGFloat components[4] = {0.0, 0.0, 0.0, 0.3};
    CGColorRef shadowColor = CGColorCreate(colorSpace, components);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 3.0f), 0.0, shadowColor);
    CGContextStrokePath(context); // Draw the path
}

- (void) presentNote:(NSNumber*)noteNumber {
    [self presentStaffForNote:noteNumber];
    [self presentNoteImage:noteNumber];
    [self upperNote];
}

- (void) presentNoteImage:(NSNumber*)noteNumber {
    int noteToDisplay = [noteNumber intValue];
    CALayer *noteLayer = [self lowerNote];
    // CGFloat position = _lineForB0 - (_singleNoteSpacing * noteToDisplay);
    CGFloat noteLocation = [[_noteLocations objectAtIndex:noteToDisplay] floatValue];
    [noteLayer setPosition:CGPointMake(0, noteLocation)];
    NSLog(@"notelayer y position is %f", noteLayer.position.y);
    [self.layer addSublayer:noteLayer];    
}

- (CALayer *)lowerNote {
    CALayer *noteLayer = [CALayer layer];
    UIImage *noteImage = [UIImage imageNamed:@"singleNote.png"];
    [noteLayer setContents:(id)noteImage.CGImage];
    [noteLayer setBorderColor:[UIColor redColor].CGColor];
    [noteLayer setBorderWidth:2.0];
    [noteLayer setTransform:CATransform3DMakeScale(0.5, 0.5, 1.)];
    [noteLayer setBounds:CGRectMake(0, 0, noteImage.size.width, noteImage.size.height)];
    [noteLayer setAnchorPoint:CGPointMake(0.5, 15/134)];
    return noteLayer;
}

- (void)upperNote {

    

}


- (void) presentStaffForNote:(NSNumber*)noteNumber {
    int noteToDisplay = [noteNumber intValue];
    
    NSLog(@"note number is %d", noteToDisplay);
    NSMutableArray *linelayersArray = @[].mutableCopy;
    
    CGFloat locationOfCurrentSub_SuperStaffLine;
    
    if (noteToDisplay <12) { // below the staff
        int numberOfLayers = 6-noteToDisplay/2;
        NSLog(@"number of layers = %d", numberOfLayers);
        for (int i=0; i<numberOfLayers; i++) {
            CALayer *lineLayer = [self lineLayer];
            [linelayersArray addObject:lineLayer];
            [lineLayer setPosition:CGPointMake(0, _firstLineInStaffLocation)];
            [self.layer addSublayer:lineLayer];
        }
        locationOfCurrentSub_SuperStaffLine = _firstLineInStaffLocation+_lineSpacing;
    }
    
    if (noteToDisplay >=36 && noteToDisplay <=52) { // above the staff
        int numberOfLayers = (noteToDisplay-34)/2;
        NSLog(@"number of layers = %d", numberOfLayers);
        for (int i=0; i<numberOfLayers; i++) {
            CALayer *lineLayer = [self lineLayer];
            [linelayersArray addObject:lineLayer];
            [lineLayer setPosition:CGPointMake(0, _lineForF5)];
            [self.layer addSublayer:lineLayer];
        }
        locationOfCurrentSub_SuperStaffLine = _lineForF5-_lineSpacing;
    }
    CGFloat timeOffset = 0;
    [CATransaction begin];

    for(CALayer *layer in linelayersArray)
    {
        NSLog(@"drop lines will animate to position %f", locationOfCurrentSub_SuperStaffLine);
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position.y"];
        anim.fromValue = [NSNumber numberWithFloat:layer.position.y];
        layer.position = CGPointMake(layer.position.x, locationOfCurrentSub_SuperStaffLine);
        anim.toValue = [NSNumber numberWithFloat:locationOfCurrentSub_SuperStaffLine];
        anim.beginTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil] + timeOffset;
        anim.duration = .3;
        [layer addAnimation:anim forKey:nil];
        if (noteToDisplay <12) {
            locationOfCurrentSub_SuperStaffLine = locationOfCurrentSub_SuperStaffLine+_lineSpacing;
        }
        if (noteToDisplay >=36 && noteToDisplay <=52) {
            locationOfCurrentSub_SuperStaffLine = locationOfCurrentSub_SuperStaffLine-_lineSpacing;
        }
        //timeOffset += 2.; // add this to make sequential but note that setting the layer's model position bewtween from and to values stops this working as expected
    }
    [CATransaction commit];
}

- (CALayer *) lineLayer {
    CALayer *line = [CALayer layer];
    [line setBounds:CGRectMake(0, 0, 30, 1)];
    [line setBorderColor:[UIColor blackColor].CGColor];
    [line setBorderWidth:1.0];    
    return line;
}


@end

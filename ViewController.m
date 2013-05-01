//
//  ViewController.m
//  SightReader
//
//  Created by Steve on 02/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import "ViewController.h"
#import "GameViewController.h"
#import "Staff.h"
#import "WhiteKey.h"
#import "BlackKey.h"
#import "AutoLayoutGameViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSDictionary *keyDetails;
@property (nonatomic, strong) NSMutableArray *orderedKeyNames;
@property (nonatomic, strong) NSString *keySelected;
@property (nonatomic, strong) NSString *clefSelected;
@property (nonatomic, strong) Staff *staff;
@property (nonatomic, strong) KeyboardAuto *keyboardAuto;
@property (nonatomic) CGFloat keyBoardConstant;
@property (nonatomic, strong) NSLayoutConstraint *horizontalPosition;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _keyDetails = [[ModelConstants sharedStore] keyNames];
    _orderedKeyNames = [[NSMutableArray alloc] init];
    for (int i = 0; i<[_keyDetails count]; i++) {
        [_orderedKeyNames addObject:@""];
    }
    for (id key in _keyDetails) {
        NSDictionary *dict = [_keyDetails objectForKey:key];
        int orderValue = [[dict objectForKey:@"orderValue"] intValue]-1;
        NSString *keyName = [dict objectForKey:@"keyName"];
        [_orderedKeyNames replaceObjectAtIndex: orderValue withObject:keyName];
    }
    
    [self.optionPicker setDelegate:self]; // UIPicker for Key and Clef
    [self.optionPicker setDataSource:self];
    
    [self placeStaff];
    [self placeKeyboard];
//    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//    [_keyboardAuto addGestureRecognizer:panRecognizer];
//    
//    UIGestureRecognizer *touchRecogniser = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(touchesBegan:withEvent:)];
//    [_keyboardAuto addGestureRecognizer:touchRecogniser];
}

//- (void)pan :(UIPanGestureRecognizer *)panGesture {    
//        CGPoint translation = [panGesture translationInView:self.view];
//        _horizontalPosition.constant = _horizontalPosition.constant + translation.x;
//        [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
//        NSLog(@"_keyboardConstant = %f", _keyBoardConstant);
//        [self.view layoutIfNeeded];
//        if (panGesture.state == UIGestureRecognizerStateEnded) {
//        
//            CGPoint velocity = [panGesture velocityInView:self.view];            
//            float slideFactor = 0.2; // Increase for more of a slide
//            CGFloat finalPoint = _horizontalPosition.constant + (velocity.x * slideFactor);
//            
//            DLog(@"final point is %f", finalPoint);
//            [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
//                _horizontalPosition.constant = finalPoint;
//                [self.view layoutIfNeeded];
//        } completion:nil];
//        
//    }
//}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    [UIView animateWithDuration:0.0
//                          delay:0.0
//                        options:UIViewAnimationOptionBeginFromCurrentState
//                     animations:^{_horizontalPosition.constant = _horizontalPosition.constant; [self.view layoutIfNeeded]; [self.view.layer removeAllAnimations];
//                     }
//                     completion:^(BOOL finished){}
//     ];
//    
//}

- (void)placeKeyboard {
    _keyboardAuto = [[KeyboardAuto alloc] initWithDelegate:self];
    [self.view addSubview:_keyboardAuto];
    _keyBoardConstant = 0;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_keyboardAuto attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20.0]];
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:_keyboardAuto attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
//    [self.view addConstraint:_horizontalPosition];
}

- (void)placeStaff {    
    NSString *keyNameInPicker = [_orderedKeyNames objectAtIndex: [_optionPicker selectedRowInComponent:1]];
    int clefOption = [_optionPicker selectedRowInComponent:0];
    NSString *keyID = [self keyIDForKeyNameInPicker:keyNameInPicker];
    NSString *clefID = [self clefNameForClefNameInPicker:clefOption];
    
    _staff = [[Staff alloc] initWithClef:clefID andKey:keyID];
    [self.view addSubview:_staff];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_staff attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-40.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_staff attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
}

#pragma mark UIPickerView data source 

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return 2;
            break;
        case 1:
            return [_orderedKeyNames count];
            break;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return (row == 0) ? @"Treble" : @"Bass";
            break;
        case 1:
            return [_orderedKeyNames objectAtIndex:row];
            break;
    }
    return [_orderedKeyNames objectAtIndex:row];
}

#pragma mark UIPickerView delegate methods


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    int clefOption = [_optionPicker selectedRowInComponent:0];
    NSString *clefID = [self clefNameForClefNameInPicker:clefOption];
    NSString *keyNameInPicker = [_orderedKeyNames objectAtIndex: [_optionPicker selectedRowInComponent:1]];
    NSString *keyID = [self keyIDForKeyNameInPicker:keyNameInPicker];
    switch (component) {
        case 0:
            // clefID = [self clefNameForClefNameInPicker:clefOption];
            [_staff changeClefImageTo:clefID];
            break;
        case 1:
            [_staff changeKeyImageTo:keyID];
            break;
        default:
            break;
    }
}

- (NSString *)keyIDForKeyNameInPicker:(NSString *)keyName {

    // NSString *keyID;
    for (id key in _keyDetails) {
        NSDictionary *keyDict = [_keyDetails objectForKey:key];
        if ([[keyDict objectForKey:@"keyName"] isEqualToString:keyName]) {
            // keyID = key;
            return key;
        }
    }
    return nil;
}

- (NSString *)clefNameForClefNameInPicker:(int)clefOption {
    return (clefOption == 0) ? @"treble" : @"bass";
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    if ([segue.identifier isEqualToString:@"GameControllerSegue"]) {
//        NSString *keyNameInPicker = [_orderedKeyNames objectAtIndex: [_optionPicker selectedRowInComponent:1]];
//        int clefOption = [_optionPicker selectedRowInComponent:0];
//        NSString *keyID = [self keyIDForKeyNameInPicker:keyNameInPicker];
//        NSString *clefID = [self clefNameForClefNameInPicker:clefOption];
//        GameViewController *gVC = segue.destinationViewController;
//        [gVC setCurrentClef1:clefID];
//        [gVC setCurrentKey:keyID];
//    }
//}



#pragma mark KeyboardAuto delegate method

- (void)keyPressed:(UITapGestureRecognizer *) sender {
    int keyIndex =  [[((BlackKey *)[(UITapGestureRecognizer *)sender view]).keyID objectAtIndex:1] intValue];
    if ([[(UITapGestureRecognizer *)sender view] isKindOfClass:[BlackKey class]]) {
        // int keyIndex =  [[((BlackKey *)[(UITapGestureRecognizer *)sender view]).keyID objectAtIndex:1] intValue];
        DLog(@"This is a black key")
        DLog(@"key pressed with id %d", keyIndex);
        DLog(@"notes relevant are: %@", [[ModelConstants sharedStore] noteFromOneOctaveKeyboardAtIndex:keyIndex])
    }
    if ([[(UITapGestureRecognizer *)sender view] isKindOfClass:[WhiteKey class]]) {
        // WhiteKey *key = [(UITapGestureRecognizer *)sender view];
        // int keyIndex =  [[((BlackKey *)[(UITapGestureRecognizer *)sender view]).keyID objectAtIndex:1] intValue];
        DLog(@"This is a white key")
        DLog(@"key pressed with id %@", ((WhiteKey *)[(UITapGestureRecognizer *)sender view]).keyID);
        DLog(@"notes relevant are: %@", [[ModelConstants sharedStore] noteFromOneOctaveKeyboardAtIndex:keyIndex])
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)GoToAutoLayoutViewController:(id)sender {
    NSString *keyNameInPicker = [_orderedKeyNames objectAtIndex: [_optionPicker selectedRowInComponent:1]];
    int clefOption = [_optionPicker selectedRowInComponent:0];
    NSString *keyID = [self keyIDForKeyNameInPicker:keyNameInPicker];
    NSString *clefID = [self clefNameForClefNameInPicker:clefOption];
    
    AutoLayoutGameViewController *avc= [[AutoLayoutGameViewController alloc] initWithClef:clefID andKey:keyID];
    [avc setDelegate:self];
    [avc setModalTransitionStyle: UIModalTransitionStyleCoverVertical];
    [self presentViewController:avc animated:YES completion:nil];
}

- (void)backButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end

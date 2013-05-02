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
#import "StaffAutoLean.h"
#import "AutoLayoutGameViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSDictionary *keyDetails;
@property (nonatomic, strong) NSMutableArray *orderedKeyNames;
@property (nonatomic, strong) Staff *staff;
@property (nonatomic, strong) KeyboardAuto *keyboardAuto;
@property (nonatomic) CGFloat keyBoardConstant;
@property (nonatomic, strong) NSLayoutConstraint *horizontalPosition;
@property (strong,nonatomic) UIView *staffView;
@property (strong,nonatomic) NSMutableArray *staffArray;
@property (strong,nonatomic) NSMutableArray *notesModel;
@property (strong,nonatomic) NSMutableArray *notesOnStaffArray;
@property (nonatomic, strong) NSString *currentKey;
@property (nonatomic, strong) NSString *currentClef;
- (void)animateWithObjectAtIndex:(int)index;
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
    
    // [self placeStaff];
    [self setupModel];
    [self setInitialKeyAndClef];
    [self setupStaffView];
    [self revealStaff];
    
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

- (void)revealStaff {
    NSMutableArray *staffsWithNotesArray = [self staffsWithNotes];
    
    for (int i = 0; i<[_notesModel count]; i++) {
        StaffAutoLean *staffAuto = [staffsWithNotesArray objectAtIndex:i];
        
        [staffAuto presentNote:(NSNumber *)[_notesModel objectAtIndex:i]];
    }
}

- (NSMutableArray *)staffsWithNotes {
    NSMutableArray *staffsWithNotesArray = @[].mutableCopy;
    for (StaffAutoLean *staffAuto in _staffArray) {
        if (staffAuto.type == kWithNote) {
            [staffsWithNotesArray addObject:staffAuto];
        }
    }
    return staffsWithNotesArray;
}

- (void)setInitialKeyAndClef {
    NSString *keyNameInPicker = [_orderedKeyNames objectAtIndex: [_optionPicker selectedRowInComponent:1]];
    int clefOption = [_optionPicker selectedRowInComponent:0];
    _currentKey = [self keyIDForKeyNameInPicker:keyNameInPicker];
    _currentClef = [self clefNameForClefNameInPicker:clefOption];
}

- (void)placeKeyboard {
    _keyboardAuto = [[KeyboardAuto alloc] initWithDelegate:self];
    [self.view addSubview:_keyboardAuto];
    _keyBoardConstant = 0;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_keyboardAuto attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20.0]];
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:_keyboardAuto attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
//    [self.view addConstraint:_horizontalPosition];
}

- (void)setupModel {
    _staffArray = @[].mutableCopy;
    _notesModel = @[].mutableCopy;
    for (int i = 0; i<5; i++) {
        int random = arc4random()%10;
        random = random+10;
        NSNumber *randomNote = [NSNumber numberWithInt:random];
        [_notesModel addObject:randomNote];
    }
}


- (void)setupStaffView {
    _staffView = [[UIView alloc] init];
    [_staffView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_staffView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_staffView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_staffView]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_staffView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(40)-[_staffView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_staffView)]];
    
    // Clef
    StaffAutoLean *staffAutoClef  = [self buildClef]; // at index 0 in _staffArray
    [_staffArray addObject:staffAutoClef];
    
    // Spacer
    StaffAutoLean *staffKeySpace = [self buildKeyStaff]; // at index 1 in _staffArray
    [_staffArray addObject:staffKeySpace];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(30)-[staffAutoClef][staffKeySpace]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(staffAutoClef,staffKeySpace)]];
    
    _notesOnStaffArray = @[].mutableCopy;
    // notes sliding off to the left will need to be animated with autolayout here, maybe slide behind the spacer - spacer z index to fade?
    
    // Notes
    for (id modelObject in _notesModel) {  // take this from the mdoel
        StaffAutoLean * staffAuto = [self buildStaffWithNote];
        [_staffArray addObject:staffAuto];
        [_notesOnStaffArray addObject:staffAuto];
#   ifdef spacer
        StaffAutoLean *staffAutoSpacer = [self buildSpacer];
        [_staffArray addObject:staffAutoSpacer];
        [_notesOnStaffArray addObject:staffAutoSpacer];
#   endif
    }
    
    UIView *previousView = nil;
    
    UIView *firstView = [_notesOnStaffArray objectAtIndex:0];
    UIView *lastView =  [_notesOnStaffArray lastObject];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[staffKeySpace][firstView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(firstView, staffKeySpace)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lastView]-(30)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lastView)]];
    
    for (UIView *staffView in _notesOnStaffArray) {
        if (previousView) {
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousView][staffView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(previousView, staffView)]];
        }
        previousView = staffView;
    }
}

- (StaffAutoLean *) buildClef {
    StaffAutoLean *staffAutoClef = [[StaffAutoLean alloc] initAsClef:_currentClef];
    [staffAutoClef setAlpha:0.];
    [_staffView addSubview:staffAutoClef];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[staffAutoClef]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(staffAutoClef)]];
    return staffAutoClef;
}


- (StaffAutoLean *)buildSpacer {
    StaffAutoLean *staffAutoSpacer = [[StaffAutoLean alloc] initAsSpacer];
    [staffAutoSpacer setAlpha:0.];
    [staffAutoSpacer setType:kSpacer];
    [_staffView addSubview:staffAutoSpacer];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[staffAutoSpacer]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(staffAutoSpacer)]];
    
    return staffAutoSpacer;
}

- (StaffAutoLean *)buildKeyStaff {
    StaffAutoLean *staffAutoKey = [[StaffAutoLean alloc] initAsKey:_currentKey withClef:_currentClef];
    [staffAutoKey setAlpha:0.];
    [staffAutoKey setType:kKey];
    [_staffView addSubview:staffAutoKey];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[staffAutoKey]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(staffAutoKey)]];
    
    return staffAutoKey;
}

- (StaffAutoLean *)buildStaffWithNote {
    StaffAutoLean *staffAuto = [[StaffAutoLean alloc] initWithFrame:CGRectZero];
    [staffAuto setAlpha:0.];
    [staffAuto setType:kWithNote];
    [_staffView addSubview:staffAuto];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[staffAuto]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(staffAuto)]];
    return staffAuto;
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



- (void)animateWithObjectAtIndex:(int)index {
    ViewController *thisViewController = self;
    if ([_staffArray count] > index)        {
        StaffAutoLean *staffAuto = [_staffArray objectAtIndex:index];
        [UIView animateWithDuration:0.05 animations:^{
            [staffAuto setAlpha:1.0];
        } completion:^(BOOL finished) {
            int newIndex = index+1;
            [thisViewController animateWithObjectAtIndex:newIndex];
        }] ;
    }
}




@end

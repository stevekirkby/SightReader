//
//  AutoLayoutGameViewController.m
//  SightReader
//
//  Created by Steve on 10/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#define SPACER 1;
//#define LOWERNOTES 1;

#import "AutoLayoutGameViewController.h"
#import "StaffAuto.h"
#import "StaffAutoLean.h"
#import "KeyboardAuto.h"

@interface AutoLayoutGameViewController ()
@property (strong,nonatomic) NSMutableArray *staffArray;
@property (strong,nonatomic) UIView *staffView;
@property (strong,nonatomic) NSMutableArray *notesModel;
@property (strong,nonatomic) NSMutableArray *notesOnStaffArray;
@property (nonatomic, strong) NSDictionary *currentKeyboard;
@property (nonatomic, strong) KeyboardAuto *keyboardAuto;
@property (nonatomic) CGFloat keyBoardConstant;
@property (nonatomic, strong) NSString *currentNote;
@property (nonatomic, strong) NSArray *currentKeyMapping;
//@property (nonatomic, strong) NSLayoutConstraint *horizontalPosition;
@property (nonatomic) int score;
- (void)animateWithObjectAtIndex:(int)index;


@end

@implementation AutoLayoutGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- initWithClef:(NSString *)clef andKey:(NSString *)key {
    [self setCurrentKey:key];
    [self setCurrentClef:clef];
    self = [self initWithNibName:nil bundle:nil];
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupModel]; // add model limits
    [self setupStaffView];
    [self createBackButton];
    [self addKeyboardAuto];
}

- (void)createBackButton {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 80, 40)];
    [backButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundColor:[UIColor orangeColor]];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton.layer setCornerRadius:8.0f];
    [backButton.layer setBorderWidth:1.0];
    [backButton.layer setBorderColor:[UIColor blackColor].CGColor];
    
    
    
    
    [self.view addSubview:backButton];
}

- (void)buttonPressed  {
    if ([self.delegate respondsToSelector:@selector(backButtonPressed)]) {
        [self.delegate backButtonPressed];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [self animateWithObjectAtIndex:0];
    [self revealInterface];
}



- (void)revealInterface {
    
    void(^staffRevealBlock)() = ^{
        [self revealStaff];
    };
    void(^keyboardRevealBlock)() = ^{
        [self revealKeyboard];
    };
    
    [UIView animateWithDuration:0.0 animations:staffRevealBlock completion:^(BOOL finished){keyboardRevealBlock();}];
}

- (void)revealKeyboard {
    [UIView animateWithDuration:0.5 animations:^{[_keyboardAuto setAlpha:1.0];}];
}
 

- (void)revealStaff {
    NSMutableArray *staffsWithNotesArray = [self staffsWithNotes];
    
    for (int i = 0; i<[_notesModel count]; i++) {
        StaffAutoLean *staffAuto = [staffsWithNotesArray objectAtIndex:i];

        [staffAuto presentNote:(NSNumber *)[_notesModel objectAtIndex:i]];
        }
}

- (void)addKeyboardAuto {
    _keyboardAuto = [[KeyboardAuto alloc] initWithDelegate:self];
    [_keyboardAuto setAlpha:0.0];
    [self.view addSubview:_keyboardAuto];
    _keyBoardConstant = 0;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_keyboardAuto attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20.0]];
     [self.view addConstraint: [NSLayoutConstraint constraintWithItem:_keyboardAuto attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
}

- (void)setCurrentKeyboard:(NSDictionary *)currentKeyboard   {
    if (_currentKeyboard != currentKeyboard) {
        _currentKeyboard = currentKeyboard;
        _currentKeyMapping = [currentKeyboard objectForKey:@"keyMapping"];
    }
}


- (void)setupModel {
    _staffArray = @[].mutableCopy;
    
    _notesModel = @[].mutableCopy;
    for (int i = 0; i<15; i++) {
        int random = arc4random()%10;
        random = random+10;
        NSNumber *randomNote = [NSNumber numberWithInt:random];
        [_notesModel addObject:randomNote];
    }
    
//#ifdef LOWERNOTES
//    //  add user constraints to how the model is presented here
//    [_notesModel addObject:@1];
//    [_notesModel addObject:@2];
//    [_notesModel addObject:@3];
//    [_notesModel addObject:@4];
//    [_notesModel addObject:@5];
//    [_notesModel addObject:@6];
//    [_notesModel addObject:@7];
//    [_notesModel addObject:@8];
//    [_notesModel addObject:@9];
//    [_notesModel addObject:@10];
//    [_notesModel addObject:@11];
//    [_notesModel addObject:@12];
////    [_notesModel addObject:@13];
////    [_notesModel addObject:@14];
////    [_notesModel addObject:@15];
////    [_notesModel addObject:@16];
////    [_notesModel addObject:@17];
////    [_notesModel addObject:@18];
////    [_notesModel addObject:@19];
//#else
//    [_notesModel addObject:@20];
//    [_notesModel addObject:@21];
//    [_notesModel addObject:@22];
//    [_notesModel addObject:@23];
//    [_notesModel addObject:@24];
//    [_notesModel addObject:@25];
//    [_notesModel addObject:@26];
//    [_notesModel addObject:@27];
//    [_notesModel addObject:@28];
//    [_notesModel addObject:@29];
//    [_notesModel addObject:@30];
//    [_notesModel addObject:@31];
//    [_notesModel addObject:@32];
////    [_notesModel addObject:@33];
////    [_notesModel addObject:@34];
////    [_notesModel addObject:@35];
////    [_notesModel addObject:@36];
////    [_notesModel addObject:@37];
////    [_notesModel addObject:@38];
//    
//#endif
    
    
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


- (void)setupStaffView {
    _staffView = [[UIView alloc] init];
    [_staffView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_staffView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[_staffView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_staffView)]];
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


- (NSMutableArray *)staffsWithNotes {
    NSMutableArray *staffsWithNotesArray = @[].mutableCopy;
    for (StaffAutoLean *staffAuto in _staffArray) {
        if (staffAuto.type == kWithNote) {
            [staffsWithNotesArray addObject:staffAuto];
        }
    }
    return staffsWithNotesArray;
}

- (void)animateWithObjectAtIndex:(int)index {
    AutoLayoutGameViewController *thisViewController = self;
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


- (void)keyboardButtonPressedActionsWithTag:(int)tag {
    //convert the key mapping array to a string to display
    NSArray *keyOptions = [_currentKeyMapping objectAtIndex:tag];
    NSString *keyPressedString=@"";
    for (NSString *option in keyOptions) {
        if ([keyOptions indexOfObject:option] > 0) {
            keyPressedString = [NSString stringWithFormat:@"%@ / ", keyPressedString];
        }
        keyPressedString = [NSString stringWithFormat:@"%@%@",keyPressedString, option];
    }
    
    for (NSString *option in keyOptions) {
        if ([_currentNote isEqualToString:option]) {
            [self incrementScore];
            // other success displays
        } else {
            // fail displays
        }
    }
    
    [self nextNote];
    
    // check whether the current note is in the array for the current key mapping
    
    // [self.keyPressedLabel setText:[NSString stringWithFormat:@"%@", keyPressedString]];
    // MAP THE KEYBOARD PRESS TO THE KEY -
}

- (IBAction)nextNoteAction:(id)sender {
    [self nextNote];
}

- (void)nextNote {
    // advance to next note - the following should work
    
//    [self.keyPressedLabel setText:@""]; // slow this down
//    
//    // GENERAL RANDOM
//    int randomNote;
//    NSString *currentNoteLocationOnKeyboard = _currentNoteLocationOnKeyboard;
//    NSString *newNote;
//    // NSString *newNote = _currentNote;
//    // NSString *currentNoteLocationOnKeyboard;
//    while ([_currentNoteLocationOnKeyboard isEqualToString: currentNoteLocationOnKeyboard] || currentNoteLocationOnKeyboard == nil) {
//        randomNote = (arc4random() % [_currentSelectionNotes count]);
//        currentNoteLocationOnKeyboard = [_currentSelectionNotes objectAtIndex:randomNote];
//        newNote = [currentNoteLocationOnKeyboard substringToIndex:1];
//    }
//    _currentNoteLocationOnKeyboard = currentNoteLocationOnKeyboard;
//    NSString *keyAmendedNote = [[ModelConstants sharedStore] amendCurrentNote:newNote againstKey:_currentKey];
//    
//    [self.currentNoteLabel setText:keyAmendedNote ];
//    
//    [self setCurrentNote: keyAmendedNote];
//    
//    NSString *imageName = [[ModelConstants sharedStore] imageNameForNoteLocation:currentNoteLocationOnKeyboard onClef:_currentClef1];
//    [_staff setNoteName:imageName];
    
    // STAT BASED NOTE SELECTIONds
}


-(void)incrementScore {
    int score = _score;
    score++;
    [self setScore:score];
}

- (void)setCurrentNote:(NSString *)currentNote {
    if (_currentNote != currentNote) {
        _currentNote = currentNote;
    }
}

- (void)addConsistentShadowToLayer: (CALayer *)myLayer {
    myLayer.shadowColor = [UIColor blackColor].CGColor;
    myLayer.shadowOpacity = 0.7f;
    myLayer.shadowOffset = CGSizeMake(0.0f, 10.0f);
    myLayer.shadowRadius = 5.0f;
    myLayer.masksToBounds = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

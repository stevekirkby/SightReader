//
//  GameViewController.m
//  SightReader
//
//  Created by Steve on 02/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import "GameViewController.h"
#import "Staff.h"
#import "KeyboardAuto.h"
#import "BlackKey.h"
#import "WhiteKey.h"

@interface GameViewController ()

@property (nonatomic, strong) NSString *currentNote;
@property (nonatomic, strong) Staff *staff;
@property (nonatomic, strong) NSDictionary *currentSelectionName;
@property (nonatomic, strong) NSDictionary *currentKeyboard;
@property (nonatomic, strong) NSArray *currentKeyMapping;
@property (nonatomic, strong) NSArray *currentSelectionNotes;
@property (nonatomic, strong) NSString *currentNoteLocationOnKeyboard;
@property (nonatomic) int score;

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)setScore:(int)score {
    if (_score != score) {
        _score = score;
        [self.scorelabel setText:[NSString stringWithFormat:@"%d", score]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialGameSelection];
    [self placeStaff];
    [self nextNote];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    KeyboardAuto *keyboardAuto = [[KeyboardAuto alloc] initWithDelegate:self];
//    [self.view addSubview:keyboardAuto];
//    UIView *mainVew = self.view;
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:keyboardAuto attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:mainVew attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20.0]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[keyboardAuto]-(10)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(keyboardAuto)]];
}

- (void)setCurrentClef1:(NSString *)currentClef1 {
    if (_currentClef1 !=currentClef1) {
        _currentClef1 = currentClef1;
        // Any additional clef set up beside
    }
}

- (void)setCurrentKey:(NSString *)currentKey {
    if (_currentKey != currentKey) {
        _currentKey = currentKey;
        // [self.keyLabel setText:currentKey];
        // Set the title of the key on screen
    }
}

- (void)setCurrentNote:(NSString *)currentNote {
    if (_currentNote != currentNote) {
        _currentNote = currentNote;

    }
}

- (void) initialGameSelection {
    {
        
        NSDictionary *gameOptions;
        NSDictionary *optionChosen;
        if ([_currentClef1 isEqualToString: @"treble"]) {
            gameOptions = [[[ModelConstants sharedStore] selectionsDictionary] objectForKey:@"trebleSelection"];
            DLog(@"trebleOptions description: %@",[gameOptions description]);
            optionChosen =[gameOptions objectForKey:@"allTreble"];
        }
        if ([_currentClef1 isEqualToString: @"bass"]) {
            gameOptions = [[[ModelConstants sharedStore] selectionsDictionary] objectForKey:@"bassSelection"];
            DLog(@"bassOptions description: %@",[gameOptions description]);
            optionChosen =[gameOptions objectForKey:@"allBass"];
        }

        // DLog(@"option chosen name: %@ ",[optionChosen objectForKey:@"name"]);
        // DLog(@"option chosen notes: %@ ",[optionChosen objectForKey:@"notes"]);
        _currentSelectionNotes =[optionChosen objectForKey:@"notes"];
        _currentSelectionName =[optionChosen objectForKey:@"name"];
        
        [self setScore:0];
        
        [self setCurrentKeyboard: [[ModelConstants sharedStore] specificKeyboardModelDetailsForID:@"km1"]];
        // [self placeBassTrebleKeyboardsForLandscape];
        
    }
}

- (void)placeStaff {
    
    _staff = [[Staff alloc] initWithClef:_currentClef1 andKey:_currentKey];
    [self.view addSubview:_staff];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_staff attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_staff attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:-290.0]];
}

- (void)setCurrentKeyboard:(NSDictionary *)currentKeyboard   {
    if (_currentKeyboard != currentKeyboard) {
        _currentKeyboard = currentKeyboard;
        _currentKeyMapping = [currentKeyboard objectForKey:@"keyMapping"];
    }
}

//-(void)placeBassTrebleKeyboardsForLandscape {
//    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"Keyboard" owner:self options:nil];
//    Keyboard *bassKeyboardView = [views objectAtIndex:0];
//    [bassKeyboardView setDelegate:self];
//
//    [bassKeyboardView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    
//    [bassKeyboardView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[bassKeyboardView(485)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bassKeyboardView)]];
//    [bassKeyboardView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bassKeyboardView(262)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bassKeyboardView)]];
//    
//    NSArray *views2 = [[NSBundle mainBundle] loadNibNamed:@"Keyboard" owner:self options:nil];
//    Keyboard *trebleKeyboardView = [views2 objectAtIndex:0];
//    [trebleKeyboardView setDelegate:self];
//    [trebleKeyboardView setTranslatesAutoresizingMaskIntoConstraints:NO];
//
//    [trebleKeyboardView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[trebleKeyboardView(485)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(trebleKeyboardView)]];
//    [trebleKeyboardView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[trebleKeyboardView(262)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(trebleKeyboardView)]];
//    
//    UIView *keyboardContainer = [[UIView alloc] init];
//    [keyboardContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.view addSubview: keyboardContainer];
//    [keyboardContainer setBackgroundColor:[UIColor whiteColor]];
//    [keyboardContainer addSubview:bassKeyboardView];
//    [keyboardContainer addSubview:trebleKeyboardView];
//    
//    [keyboardContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[trebleKeyboardView]|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(bassKeyboardView, trebleKeyboardView)]];
//    [keyboardContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bassKeyboardView]-(5)-[trebleKeyboardView]|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(bassKeyboardView, trebleKeyboardView)]];
//    
//    UIView *mainView = self.view;
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:keyboardContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:mainView  attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:keyboardContainer attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:mainView  attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
//}

-(NSString *)randomKeyName {
    NSArray *availableKeysArray = [[ModelConstants sharedStore] availableKeys];
    int numberOfKeys = [availableKeysArray count];
    int randomKeyIndex = (arc4random() % numberOfKeys);
    DLog(@"Random key set at:%d", randomKeyIndex);
    NSString *randomKey = [availableKeysArray objectAtIndex:randomKeyIndex];
    return randomKey;
}

-(NSString *)randomClefName {
    NSString *randomClef;
    int randomClefIndex = (arc4random() % 2);
    if (randomClefIndex == 1) {
        randomClef = @"bass";
    } else {
        randomClef = @"treble";
    }
    return randomClef;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextNoteAction:(id)sender {
    [self nextNote];
}

- (void)nextNote {
    
    
    [self.keyPressedLabel setText:@""]; // slow this down
    
    // GENERAL RANDOM
    int randomNote;
    NSString *currentNoteLocationOnKeyboard = _currentNoteLocationOnKeyboard;
    NSString *newNote;
    // NSString *newNote = _currentNote;
    // NSString *currentNoteLocationOnKeyboard;
    while ([_currentNoteLocationOnKeyboard isEqualToString: currentNoteLocationOnKeyboard] || currentNoteLocationOnKeyboard == nil) {
        randomNote = (arc4random() % [_currentSelectionNotes count]);
        currentNoteLocationOnKeyboard = [_currentSelectionNotes objectAtIndex:randomNote];
        newNote = [currentNoteLocationOnKeyboard substringToIndex:1];
    }
    _currentNoteLocationOnKeyboard = currentNoteLocationOnKeyboard;
    NSString *keyAmendedNote = [[ModelConstants sharedStore] amendCurrentNote:newNote againstKey:_currentKey];    

    [self.currentNoteLabel setText:keyAmendedNote ];
    
    [self setCurrentNote: keyAmendedNote];
    
    NSString *imageName = [[ModelConstants sharedStore] imageNameForNoteLocation:currentNoteLocationOnKeyboard onClef:_currentClef1];
    [_staff setNoteName:imageName];
    
    // STAT BASED NOTE SELECTIONds
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

-(void)incrementScore {
    int score = _score;
    score++;
    [self setScore:score];
}

//#pragma mark keyboard delegate methods
//- (void)keyBoardButtonPressed:(int)tag {
//    [self keyboardButtonPressedActionsWithTag:(int)tag];
//}

#pragma mark KeyboardAuto delegate method

- (void)keyPressed:(UITapGestureRecognizer *) sender {
    if ([[(UITapGestureRecognizer *)sender view] isKindOfClass:[BlackKey class]]) {
        DLog(@"This is a black key")
    }
    if ([[(UITapGestureRecognizer *)sender view] isKindOfClass:[WhiteKey class]]) {
        // WhiteKey *key = [(UITapGestureRecognizer *)sender view];
        
        DLog(@"This is a white key")
        DLog(@"key pressed with id %@", ((WhiteKey *)[(UITapGestureRecognizer *)sender view]).keyID);
    }
}


@end

//
//  ImageStore.m
//  SightReader
//
//  Created by Steve Kirkby on 04/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import "ModelConstants.h"

@interface ModelConstants ()

@property (nonatomic, strong) NSDictionary *keyImages;
@property (nonatomic, strong) NSDictionary *clefImages;
@property (nonatomic, strong) NSDictionary *noteDictTreble;
@property (nonatomic, strong) NSDictionary *noteDictBass;
@property (nonatomic, strong) NSDictionary *keyDict;
@property (nonatomic, strong) NSArray *keyboardModelsArray;
// @property (nonatomic, strong) NSDictionary *noteDict;
@end

@implementation ModelConstants


+(ModelConstants *)sharedStore {
    static ModelConstants *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedStore];
}


- (void) calculatePositionForNote: (NSString *)note onClef:(NSString *) clef {
    
    
}

- (NSArray *)trebleRange {
    return @[@"C1", @"F7"];
}

- (NSArray *)bassRange {
    return @[@"A0", @"C5"];
}


- (NSDictionary *)keyImages {
    NSDictionary *KI = @{  @"C_Major":@"KeyC",
                                  @"G_Major":@"KeyG",
                                  @"D_Major":@"KeyD",
                                  @"A_Major":@"KeyA",
                                  @"E_Major":@"KeyE",
                                  @"B_Major":@"KeyB",
                                  @"F_Major":@"KeyF",
                                  @"F_Sharp_Major":@"KeyFSharp",
                                  @"C_Sharp_Major":@"KeyCSharp",
                                  @"B_Flat_Major":@"KeyBFlat",
                                  @"E_Flat_Major":@"KeyEFlat",
                                  @"A_Flat_Major":@"KeyAFlat",
                                  @"D_Flat_Major":@"KeyDFlat",
                                  @"G_Flat_Major":@"KeyGFlat",
                                  @"C_Flat_Major":@"KeyCFlat"
                                  };
    return KI;
}


- (NSDictionary *)isTheKeySharpOrFlat {
    NSDictionary *dict = @{  @"C_Major":@"sharp",
                           @"G_Major":@"sharp",
                           @"D_Major":@"sharp",
                           @"A_Major":@"sharp",
                           @"E_Major":@"sharp",
                           @"B_Major":@"sharp",
                           @"F_Major":@"flat",
                           @"F_Sharp_Major":@"sharp",
                           @"C_Sharp_Major":@"sharp",
                           @"B_Flat_Major":@"flat",
                           @"E_Flat_Major":@"flat",
                           @"A_Flat_Major":@"flat",
                           @"D_Flat_Major":@"flat",
                           @"G_Flat_Major":@"flat",
                           @"C_Flat_Major":@"flat"
                           };
    return dict;
}

- (NSDictionary *)numberOfSharpsOrFlatsInEachKey {
    // NB This dict if the number of sharps/flats to take from the 
    NSDictionary *numberOfSharpsOrFlats = @{  @"C_Major":@0,
                             @"G_Major":@1,
                             @"D_Major":@2,
                             @"A_Major":@3,
                             @"E_Major":@4,
                             @"B_Major":@5,
                             @"F_Major":@1,
                             @"F_Sharp_Major":@6,
                             @"C_Sharp_Major":@7,
                             @"B_Flat_Major":@2,
                             @"E_Flat_Major":@3,
                             @"A_Flat_Major":@4,
                             @"D_Flat_Major":@5,
                             @"G_Flat_Major":@6,
                             @"C_Flat_Major":@7
                             };
    
    return numberOfSharpsOrFlats;
}

- (NSMutableDictionary *)keyLocationsRelativeToLowestStaffLineForKey:(NSString *)key andClef:(NSString *)clef {
    // dictionary contains indicator whether the image should be sharp or flat, and also contains the relative positions on the staff for where these images should be placed
    NSMutableDictionary *dict = @{}.mutableCopy;
    NSMutableArray *keyMarkerLocationsRelativeToLowestStaffLine = @[].mutableCopy;
    
    int numberOfSharpsFlatToDisplay = [[[self numberOfSharpsOrFlatsInEachKey] objectForKey:key] intValue];
     
    NSString *isTheKeySharpOrFlat = [[self isTheKeySharpOrFlat] objectForKey:key];
    
    NSArray *arrayToUse;
    NSArray *bassSharpLocations = @[@6, @3, @7, @4, @1, @5, @2];
    NSArray *bassFlatLocations = @[@2, @5, @1, @4, @0, @3, @-1];
    NSArray *trebleSharpLocations = @[@8, @5, @9, @6, @3, @7, @4];
    NSArray *trebleFlatLocations = @[@4, @7, @3, @6, @2, @5, @1];
    
    if ([clef isEqualToString:@"bass"]) {
        if ([isTheKeySharpOrFlat isEqualToString:@"sharp"]) {
            arrayToUse = bassSharpLocations;
        } else if ([isTheKeySharpOrFlat isEqualToString:@"flat"]) {
            arrayToUse = bassFlatLocations;
        } else {
            NSLog(@"neither sharp not flat. Big problem!");
        }
    }

    if ([clef isEqualToString:@"treble"]) {
        if ([isTheKeySharpOrFlat isEqualToString:@"sharp"]) {
                arrayToUse = trebleSharpLocations;
        } else if ([isTheKeySharpOrFlat isEqualToString:@"flat"]) {
                arrayToUse = trebleFlatLocations;
        } else {
            NSLog(@"neither sharp not flat. Big problem!");
        }
    }
    
    keyMarkerLocationsRelativeToLowestStaffLine = [arrayToUse subarrayWithRange:NSMakeRange(0, numberOfSharpsFlatToDisplay)].mutableCopy;
    
    [dict setObject:keyMarkerLocationsRelativeToLowestStaffLine forKey:@"markerLocations"];
    [dict setObject:isTheKeySharpOrFlat forKey:@"sharpOrFlat"];
    return dict;
}


- (NSDictionary *)noteDictBass {
    NSDictionary *NDB = @{  @"A0": @{@"imageName": @"1.png"},
                            @"B0": @{@"imageName": @"2.png"},
                            @"C1": @{@"imageName": @"3.png"},
                            @"D1": @{@"imageName": @"4.png"},
                            @"E1": @{@"imageName": @"5.png"},
                            @"F1": @{@"imageName": @"6.png"},
                            @"G1": @{@"imageName": @"7.png"},
                            @"A1": @{@"imageName": @"8.png"},
                            @"B1": @{@"imageName": @"9.png"},
                            @"C2": @{@"imageName": @"10.png"},
                            @"D2": @{@"imageName": @"11.png"},
                            @"E2": @{@"imageName": @"12.png"},
                            @"F2": @{@"imageName": @"13.png"},
                            @"G2": @{@"imageName": @"14.png"},
                            @"A2": @{@"imageName": @"15.png"},
                            @"B2": @{@"imageName": @"16.png"},
                            @"C3": @{@"imageName": @"17.png"},
                            @"D3": @{@"imageName": @"18.png"},
                            @"E3": @{@"imageName": @"19.png"},
                            @"F3": @{@"imageName": @"20.png"},
                            @"G3": @{@"imageName": @"21.png"},
                            @"A3": @{@"imageName": @"22.png"},
                            @"B3": @{@"imageName": @"23.png"},
                            @"C4": @{@"imageName": @"24.png"},
                            @"D4": @{@"imageName": @"25.png"},
                            @"E4": @{@"imageName": @"26.png"},
                            @"F4": @{@"imageName": @"27.png"},
                            @"G4": @{@"imageName": @"28.png"},
                            @"A4": @{@"imageName": @"29.png"},
                            @"BV": @{@"imageName": @"30.png"},
                            @"C5": @{@"imageName": @"31.png"},
                            @"D5": @{@"imageName": @"32.png"},
                            @"E5": @{@"imageName": @"33.png"},
                            @"F5": @{@"imageName": @"34.png"},
                            @"G5": @{@"imageName": @"35.png"}
                            };
    return NDB;
}

- (NSDictionary *)noteDictTreble {
    NSDictionary *NDT = @{          @"F2": @{@"imageName": @"1.png"},
                                  @"G2": @{@"imageName": @"2.png"},
                                  @"A2": @{@"imageName": @"3.png"},
                                  @"B2": @{@"imageName": @"4.png"},
                                  @"C3": @{@"imageName": @"5.png"},
                                  @"D3": @{@"imageName": @"6.png"},
                                  @"E3": @{@"imageName": @"7.png"},
                                  @"F3": @{@"imageName": @"8.png"},
                                  @"G3": @{@"imageName": @"9.png"},
                                  @"A3": @{@"imageName": @"10.png"},
                                  @"B3": @{@"imageName": @"11.png"},
                                  @"C4": @{@"imageName": @"12.png"},
                                  @"D4": @{@"imageName": @"13.png"},
                                  @"E4": @{@"imageName": @"14.png"},
                                  @"F4": @{@"imageName": @"15.png"},
                                  @"G4": @{@"imageName": @"16.png"},
                                  @"A4": @{@"imageName": @"17.png"},
                                  @"B4": @{@"imageName": @"18.png"},
                                  @"C5": @{@"imageName": @"19.png"},
                                  @"D5": @{@"imageName": @"20.png"},
                                  @"E5": @{@"imageName": @"21.png"},
                                  @"F5": @{@"imageName": @"22.png"},
                                  @"G5": @{@"imageName": @"23.png"},
                                  @"A5": @{@"imageName": @"24.png"},
                                  @"B5": @{@"imageName": @"25.png"},
                                  @"C6": @{@"imageName": @"26.png"},
                                  @"D6": @{@"imageName": @"27.png"},
                                  @"E6": @{@"imageName": @"28.png"},
                                  @"F6": @{@"imageName": @"29.png"},
                                  @"G6": @{@"imageName": @"30.png"},
                                  @"A6": @{@"imageName": @"31.png"},
                                  @"B6": @{@"imageName": @"32.png"},
                                  @"C7": @{@"imageName": @"33.png"},
                                  @"D7": @{@"imageName": @"34.png"},
                                  @"E7": @{@"imageName": @"35.png"}
                                  };
    return NDT;
}

- (NSDictionary *)keyDict {
    NSDictionary *KD = @{ @"C_Major": @{@"keyName":@"C Major", @"imageName":@"KeyC", @"sharpsOrFlats":@"sharp", @"alteredNotes":@"", @"orderValue":@"1"},
                          @"G_Major": @{@"keyName":@"G Major", @"imageName":@"KeyG", @"sharpsOrFlats":@"sharp", @"alteredNotes":@"F", @"orderValue":@"2"},
                          @"D_Major": @{@"keyName":@"D Major", @"imageName":@"KeyD", @"sharpsOrFlats":@"sharp", @"alteredNotes":@"FC", @"orderValue":@"3"},
                          @"A_Major": @{@"keyName":@"A Major", @"imageName":@"KeyA", @"sharpsOrFlats":@"sharp", @"alteredNotes":@"FCG", @"orderValue":@"4"},
                          @"E_Major": @{@"keyName":@"E Major", @"imageName":@"KeyE", @"sharpsOrFlats":@"sharp", @"alteredNotes":@"FCGD", @"orderValue":@"5"},
                          @"B_Major": @{@"keyName":@"B Major", @"imageName":@"KeyB", @"sharpsOrFlats":@"sharp", @"alteredNotes":@"FCGDA", @"orderValue":@"6"},
                          @"F_Sharp_Major": @{@"keyName":@"F# Major", @"imageName":@"KeyFSharp", @"sharpsOrFlats":@"sharp", @"alteredNotes":@"FCGDAE", @"orderValue":@"7"},
                          @"C_Sharp_Major": @{@"keyName":@"C# Major", @"imageName":@"KeyCSharp", @"sharpsOrFlats":@"sharp", @"alteredNotes":@"FCGDAEB", @"orderValue":@"8"},
                          
                          @"F_Major": @{@"keyName":@"F Major", @"imageName":@"keyF", @"sharpsOrFlats":@"flat", @"alteredNotes":@"B", @"orderValue":@"9"},
                          @"B_Flat_Major": @{@"keyName":@"Bb Major", @"imageName":@"KeyBFlat", @"sharpsOrFlats":@"flat", @"alteredNotes":@"BE", @"orderValue":@"10"},
                          @"E_Flat_Major": @{@"keyName":@"Eb Major", @"imageName":@"KeyEFlat", @"sharpsOrFlats":@"flat", @"alteredNotes":@"BEA", @"orderValue":@"11"},
                          @"A_Flat_Major": @{@"keyName":@"Ab Major", @"imageName":@"KeyAFlat", @"sharpsOrFlats":@"flat", @"alteredNotes":@"BEAD", @"orderValue":@"12"},
                          @"D_Flat_Major": @{@"keyName":@"Db Major", @"imageName":@"KeyDFlat", @"sharpsOrFlats":@"flat", @"alteredNotes":@"BEADG", @"orderValue":@"13"},
                          @"G_Flat_Major": @{@"keyName":@"Gb Major", @"imageName":@"KeyGFlat", @"sharpsOrFlats":@"flat", @"alteredNotes":@"BEADGC", @"orderValue":@"14"},
                          @"C_Flat_Major": @{@"keyName":@"Cb Major", @"imageName":@"KeyCFlat", @"sharpsOrFlats":@"flat", @"alteredNotes":@"BEADCGF", @"orderValue":@"15"}
                          };
    return KD;
}

- (NSDictionary *)oneOctaveKeyboard {
    // KEYBOARDS AVAILABLE
    NSDictionary *OOK=@{  @"id":@"km1",
                                        @"name":@"One Octave Keyboard",
                                        @"description":@"One octave C-B",
                                        @"keyMapping":  @[@[@"C", @"B#"],
                                                          @[@"C#", @"Db"],
                                                          @[@"D"],
                                                          @[@"D#", @"Eb"],
                                                          @[@"E", @"Fb"],
                                                          @[@"F", @"E#"],
                                                          @[@"F#", @"Gb"],
                                                          @[@"G"],
                                                          @[@"G#", @"Ab"],
                                                          @[@"A"],
                                                          @[@"A#", @"Bb"],
                                                          @[@"B", @"Cb"]]
                                        };
    return OOK;
}

- (NSArray *)keyboardModelsArray {
    NSArray *KBMA = @[self.oneOctaveKeyboard];
    return KBMA;
}

- (NSDictionary *)clefImages {
    NSDictionary *CI = @{  @"bass":@"bassClef.png",
                      @"treble":@"trebleClef.png"
                      };
    return CI;
}

- (id)init {
    self=[super init];
    if (self) { 
        // SELECTIONS AVAILABLE
        NSDictionary *allTreble = @{@"name":@"All Treble Notes", @"notes":[self availableTrebleNotes]};
        NSDictionary *allBass = @{@"name":@"All Bass Notes", @"notes":[self availableBassNotes]};
        NSDictionary *bassDictionary = @{@"allBass": allBass};
        NSDictionary *trebleDictionary = @{@"allTreble": allTreble};
        
        _selectionsDictionary = @{@"trebleSelection":trebleDictionary, @"bassSelection":bassDictionary};
                
    }
    return self;
}

- (NSString *)amendCurrentNote:(NSString *)currentNote againstKey:(NSString *)currentKey {
    NSDictionary *keyDetailsDict = [self.keyDict objectForKey:currentKey];
    NSString *amendedNote = currentNote;
    
    NSString *alteredNotesString = [keyDetailsDict objectForKey:@"alteredNotes"];
    if ([alteredNotesString rangeOfString:currentNote].location != NSNotFound) {
        if ([[keyDetailsDict objectForKey:@"sharpsOrFlats"] isEqualToString:@"flat"]) {
            amendedNote = [NSString stringWithFormat:@"%@b",amendedNote];
        }
        if ([[keyDetailsDict objectForKey:@"sharpsOrFlats"] isEqualToString:@"sharp"]) {
            amendedNote = [NSString stringWithFormat:@"%@#", amendedNote];
        }
    }
    return amendedNote;
}

-(NSString *)imageNameForKey: (NSString *)keyName andClef:(NSString *)clefName {
    NSDictionary *keyDictElement = [self.keyDict objectForKey:keyName];
    NSString *imageNamePrefix = [keyDictElement objectForKey:@"imageName"];
    if ([clefName isEqualToString:@"bass"]) {
        NSString *imageName = [NSString stringWithFormat:@"%@Bass.png", [self.keyImages objectForKey:keyName]];
        return imageName;
    } else if ([clefName isEqualToString:@"treble"]) {
        NSString *imageName = [NSString stringWithFormat:@"%@Treble.png", imageNamePrefix];
        return imageName;
    } else 
        CUSTOMEXCEPTION (@"imageNameForKey in model constants: Neither bass nor treble have been assigned");
        return nil;
}

- (NSString *)imageNameForNoteLocation: (NSString *)noteLocation onClef:(NSString *)clefName {
    NSDictionary *notelocationDict;
    if ([clefName isEqualToString:@"treble"]) {
        notelocationDict = [self.noteDictTreble objectForKey:noteLocation];
    } else if ([clefName isEqualToString:@"bass"]) {
        notelocationDict = [self.noteDictBass objectForKey:noteLocation];
    } else {
        CUSTOMEXCEPTION(@"imageNameForNote in model constants: bass or treble: Neither bass nor treble have been assigned  ")
        return nil;
    }
    NSString *imageName = [notelocationDict objectForKey:@"imageName"];
    return imageName;
}

-(NSString *)imageNameForClef:(NSString *)clef {
    NSString *clefImageName = [self.clefImages objectForKey:clef];
    return clefImageName;
}

- (NSArray *) availableBassNotes {
    NSArray *availableBassNotes=[self.noteDictBass allKeys];
    return availableBassNotes;
}

- (NSArray *) availableTrebleNotes {
    NSArray *availableTrebleNotes=[self.noteDictTreble allKeys];
    return availableTrebleNotes;
}

- (NSArray *)availableKeys {
    NSArray *availableKeys = [self.keyDict allKeys];
    return availableKeys;
}

- (NSDictionary *)keyNames {
    NSArray *allKeys = [self.keyDict allKeys];
    NSMutableDictionary *keyDictSubset = [[NSMutableDictionary alloc] init];
    for (NSString *keyID in allKeys) {
        NSDictionary *specificKeyDict = [self.keyDict objectForKey:keyID];
        NSMutableDictionary *keyDictExtract=[[NSMutableDictionary alloc] init];
        [keyDictExtract setObject:[specificKeyDict objectForKey:@"keyName"] forKey:@"keyName"];
        [keyDictExtract setObject:[specificKeyDict objectForKey:@"orderValue"] forKey:@"orderValue"];
        [keyDictSubset setObject:keyDictExtract forKey:keyID];
    }

    return keyDictSubset;
}


- (NSDictionary *)availableKeyboardModelSummary { // call when a selection of availabel keyboards is needed
    NSDictionary *modelDictSubset;
    for (NSDictionary *keyboardModel in self.keyboardModelsArray) {
        modelDictSubset = @{@"id":[keyboardModel objectForKey:@"id"],@"name":[keyboardModel objectForKey:@"name"] , @"description":[keyboardModel objectForKey:@"description"]};
    }
    return modelDictSubset;
}

- (NSDictionary *) specificKeyboardModelDetailsForID:(NSString *)idString { // call to get the mapping
        NSDictionary *modelDetailsDict;
        for (NSDictionary *keyboardModel in self.keyboardModelsArray) {
            if ([[keyboardModel objectForKey:@"id"] isEqualToString:idString]) {
                modelDetailsDict = keyboardModel;
            }
        }
        return modelDetailsDict;
}

- (NSArray *)noteFromOneOctaveKeyboardAtIndex:(int) index {
        NSArray *keyMapping = [[self oneOctaveKeyboard] objectForKey:@"keyMapping"];
        return [keyMapping objectAtIndex:index];
}



@end

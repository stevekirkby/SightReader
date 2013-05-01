//
//  ImageStore.h
//  SightReader
//
//  Created by Steve Kirkby on 04/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelConstants : NSObject
+ (ModelConstants *)sharedStore;
- (NSString *)imageNameForKey: (NSString *)keyName andClef:(NSString *)clefName;
- (NSString *)imageNameForNoteLocation: (NSString *)noteLocation onClef:(NSString *)clefName;
- (NSString *)amendCurrentNote:(NSString *)currentNote againstKey:(NSString *)currentKey;

- (NSString *)imageNameForClef:(NSString *)clef;
- (NSArray *)availableKeys;
- (NSArray *)availableBassNotes;
- (NSArray *)availableTrebleNotes;
- (NSDictionary *)availableKeyboardModelSummary;
- (NSDictionary *) specificKeyboardModelDetailsForID:(NSString *)idString;
- (NSDictionary *)keyNames;
- (NSArray *)noteFromOneOctaveKeyboardAtIndex:(int)index;
@property (strong, nonatomic) NSDictionary *selectionsDictionary;
- (NSDictionary *)keyLocationsRelativeToLowestStaffLineForKey:(NSString *)key andClef:(NSString *)clef;
@end

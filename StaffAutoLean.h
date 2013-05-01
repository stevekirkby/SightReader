//
//  StaffAutoLean.h
//  SightReader
//
//  Created by Steve on 23/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {kSpacer, kWithNote, kClef, kKey} StaffType;
@interface StaffAutoLean : UIView
-(id)initAsSpacer;
-(id)initAsClef:(NSString *)clef;
-(id)initAsKey:(NSString *)key withClef:(NSString *)clef;
- (void) presentNote:(NSNumber*)noteNumber;

@property (nonatomic) StaffType type;
@property (nonatomic, strong) NSString *clef;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSNumber *noteReference;

@end

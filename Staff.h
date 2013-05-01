//
//  Staff.h
//  SightReader
//
//  Created by Steve Kirkby on 04/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//


@interface Staff : UIView
@property (nonatomic, strong) NSString *clefName;
@property (nonatomic, strong) NSString *keyName;
@property (nonatomic, strong) NSString *noteName;
- (id)initWithClef:(NSString *)clef andKey:(NSString *)key;
- (void)changeClefImageTo:(NSString *)clefName;
- (void)changeKeyImageTo:(NSString *)keyName;
@end

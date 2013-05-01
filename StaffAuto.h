//
//  StaffAuto.h
//  SightReader
//
//  Created by Steve on 10/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef enum {kSpacer, kWithNote} StaffType;

@interface StaffAuto : UIView

//@property (nonatomic) StaffType type;
- (id)initWithSpacer;
- (void) presentNote:(NSNumber*)noteNumber;
@end

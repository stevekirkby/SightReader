//
//  ColorManager.h
//  SightReader
//
//  Created by House on 10/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorManager : NSObject
+ (UIColor *) returnColorChangeFrom: (UIColor *)originalColor withToneAdjustment: (float) toneAdjustment;

+ (UIColor *) returnWhiteKeyColor;
+ (UIColor *) returnWhiteKeyHighlightedColor;
+ (UIColor *) returnBlackKeyColor;
+ (UIColor *) returnBlackKeyHighlightedColor;

@end

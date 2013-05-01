//
//  AutoLayoutGameViewController.h
//  SightReader
//
//  Created by Steve on 10/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AutoLayoutGameViewControllerProtocol <NSObject>
- (void)backButtonPressed;
@end

@interface AutoLayoutGameViewController : UIViewController

@property (nonatomic, assign) id <AutoLayoutGameViewControllerProtocol> delegate;
@property (nonatomic, strong) NSString *currentKey;
@property (nonatomic, strong) NSString *currentClef;
- initWithClef:(NSString *)clef andKey:(NSString *)key;
@end

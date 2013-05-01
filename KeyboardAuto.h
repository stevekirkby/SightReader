//
//  keyboardAuto.h
//  SightReader
//
//  Created by House on 08/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KeyPressedDelegate <NSObject>

-(void)keyPressed:(UITapGestureRecognizer *)sender;

@end

@interface KeyboardAuto : UIView
- (id)initWithDelegate: (id) delegate;

@end

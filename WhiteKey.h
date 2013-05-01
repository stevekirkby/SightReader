//
//  WhiteKey.h
//  SightReader
//
//  Created by House on 08/04/2013.
//  Copyright (c) 2013 HiveDynamic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhiteKey : UIView
@property (nonatomic, strong) NSMutableArray*keyID;
@property (nonatomic, assign) BOOL keyIsHighlighted;
- (id)initWithKeyID:(NSMutableArray *)keyID;


@end

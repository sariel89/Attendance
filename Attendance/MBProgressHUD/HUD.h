//
// Created by Sariel on 2017/1/3.
// Copyright (c) 2017 Sariel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUD : NSObject

+ (void) showHUD;
+ (void) hiddenHUD;

+ (void) toast:(NSString *)msg;

@end
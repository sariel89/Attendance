//
// Created by Sariel on 2017/1/4.
// Copyright (c) 2017 Sariel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AttendanceFilterView : UIView

@property(nonatomic, copy) void (^tapDoneItemBlock)(NSString *filterInfo);

- (void) showFilterWithNames:(NSArray *)arrNames;
@end
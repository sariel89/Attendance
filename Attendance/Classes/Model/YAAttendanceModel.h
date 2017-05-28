//
// Created by sariel on 2017/5/23.
// Copyright (c) 2017 Sariel. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YAAttendanceExceptionModel : NSObject
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *desc;
@end

@interface YAAttendanceRecordModel : NSObject

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *first;
@property (nonatomic, strong) NSString *last;
@property (nonatomic, copy) NSArray *records;

@end

@interface YAAttendanceModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger exceptionCount;
@property (nonatomic, copy) NSArray *records;

@end
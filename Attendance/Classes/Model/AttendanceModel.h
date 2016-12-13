//
//  AttendanceModel.h
//  Attendance
//
//  Created by Sariel on 16/11/5.
//  Copyright © 2016年 Sariel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, kUnusuallyType) {
    kUnusuallyTypeNormal,   // 正常
    kUnusuallyTypeLessCount,
    kUnusuallyTypeOverTime,
    kUnusuallyTypeLessStation,
};

@interface AttendanceUnusuallyModel : NSObject
@property (nonatomic, strong) NSString *dateInfo;
@property (nonatomic, strong) NSString *time;
@end

@interface AttendanceModel : NSObject
@property (nonatomic, strong) NSDateComponents *dateComp;
@property (nonatomic, strong) NSString *dateFirstRecord;
@property (nonatomic, strong) NSString *dateLastRecord;
@property (nonatomic, assign) kUnusuallyType unusuallyType; // 是否有异常，默认为有异常
@property (nonatomic, strong) NSMutableArray<AttendanceUnusuallyModel *> *arrUnusually;    // 异常列表

@property (nonatomic, assign) float cellHeight;
@end

@interface AttendanceUserModel : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSArray<AttendanceModel *> *userAttendanceDates;
@end

@interface AttendanceRecordModel : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSDate *> *> *records;
@end



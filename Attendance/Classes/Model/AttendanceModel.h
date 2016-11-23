//
//  AttendanceModel.h
//  Attendance
//
//  Created by Sariel on 16/11/5.
//  Copyright © 2016年 Sariel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttendanceModel : NSObject
@property (nonatomic, strong) NSDateComponents *dateComp;
@property (nonatomic, strong) NSDate *dateFirstRecord;
@property (nonatomic, strong) NSDate *dateLastRecord;
@property (nonatomic, assign) BOOL isUnusually; // 是否有异常，默认为有异常
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



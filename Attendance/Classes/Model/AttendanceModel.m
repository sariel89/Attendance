//
//  AttendanceModel.m
//  Attendance
//
//  Created by Sariel on 16/11/5.
//  Copyright © 2016年 Sariel. All rights reserved.
//

#import "AttendanceModel.h"

@implementation AttendanceModel

@end

@implementation AttendanceUserModel

@end

@implementation AttendanceRecordModel
- (NSMutableArray<NSMutableArray<NSDate *> *> *)records {
    if (!_records) {
        _records = [[NSMutableArray alloc] init];
    }
    return _records;
}
@end


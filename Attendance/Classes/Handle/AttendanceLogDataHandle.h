//
//  AttendanceLogDataHandle.h
//  Attendance
//
//  Created by Sariel on 2016/12/26.
//  Copyright © 2016年 Sariel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttendanceLogDataHandle : NSObject
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSCalendar *calendar;

/**
 * 开始处理下载好的文件
 * @param filePath 文件路径
 */
- (NSArray *)beginReadFileAndHandle:(id)filePath;
@end

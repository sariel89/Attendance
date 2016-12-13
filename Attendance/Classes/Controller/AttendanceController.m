//
// Created by Sariel on 16/11/19.
// Copyright (c) 2016 Sariel. All rights reserved.
//

#import "AttendanceController.h"
#import "AttendanceModel.h"
#import "AttendanceCell.h"


@interface AttendanceController () <UITableViewDelegate, UITableViewDataSource>
@property(weak, nonatomic) IBOutlet UILabel *labTime;
@property(weak, nonatomic) IBOutlet UIButton *btnDownFile;
@property(weak, nonatomic) IBOutlet UITableView *tableResult;
@property(weak, nonatomic) IBOutlet UIButton *btnClearCache;
@property(weak, nonatomic) IBOutlet UIButton *btnUpload;

@property(nonatomic, strong) NSMutableArray<AttendanceUserModel *> *arrDatas;

@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSCalendar *calendar;

@end

@implementation AttendanceController

#pragma mark - System Method

- (void)viewDidLoad {
    [super viewDidLoad];

    self.labTime.layer.borderColor = [UIColor colorWithRed:(CGFloat) 0 green:(CGFloat) (148.0 / 255.0) blue:(CGFloat) (141.0 / 255.0) alpha:1].CGColor;
    self.labTime.layer.borderWidth = 1;
    self.labTime.userInteractionEnabled = YES;
    [self.labTime addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabTime)]];

    [self.tableResult registerClass:[AttendanceCell class] forCellReuseIdentifier:@"cell"];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];


}

#pragma mark - UITableviewDelegate, UITabelviewDatasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AttendanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.dataModel = self.arrDatas[indexPath.section].userAttendanceDates[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrDatas[section].userAttendanceDates.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AttendanceUserModel *userModel = self.arrDatas[indexPath.section];
    AttendanceModel *model = userModel.userAttendanceDates[indexPath.row];
    if (model.cellHeight < 81) {
        if (model.unusuallyType == kUnusuallyTypeOverTime) {
            model.cellHeight = (model.arrUnusually.count + 1) * 30 + 89;
        } else {
            model.cellHeight = 89;
        }
    }
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.arrDatas[section].userName;
}

#pragma mark - Action

- (void)tapLabTime {
    NSLog(@"点击时间 － 弹出时间选择控制器");
}

- (IBAction)actionDownFile:(id)sender {
    NSLog(@"下载文件");
    [self.arrDatas removeAllObjects];
    //TODO: 替换为真实信息
    [self beginReadFileAndHandle:nil];

}

- (IBAction)actionClearCache:(id)sender {
    NSLog(@"清除缓存文件");
}

- (IBAction)actionUploadFile:(id)sender {
    NSLog(@"上传文件");
}

#pragma mark - Method

/**
 * 开始处理下载好的文件
 * @param filePath 文件路径
 */
- (void)beginReadFileAndHandle:(NSString *)filePath {
    NSArray *arr = [self separateDataStringToArray:[self getDatasFromFilePath:nil]];
    NSArray *arrModel = [self transformDatasArrayToModel:arr];

    for (AttendanceRecordModel *model in arrModel) {
        AttendanceUserModel *model1 = [self createNewUserModelWithOneRecord:model];
        for (NSArray *arrDates in model.records) {
            // 获取当前日期
            NSDateComponents *com = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:arrDates.firstObject];

            // 查看是否有异常
            AttendanceModel *unusuallyModel = [self analyzeDailyRecords:arrDates];

            // 放入对应的UserModel里面
            for (AttendanceModel *modelAttendance in model1.userAttendanceDates) {
                if (modelAttendance.dateComp.day == com.day) {
                    modelAttendance.dateFirstRecord = unusuallyModel.dateFirstRecord;
                    modelAttendance.dateLastRecord = unusuallyModel.dateLastRecord;
                    modelAttendance.unusuallyType = unusuallyModel.unusuallyType;
                    modelAttendance.arrUnusually = unusuallyModel.arrUnusually;
                    break;
                }
            }
        }
        [self.arrDatas addObject:model1];
    }

    [self.tableResult reloadData];

}

/**
 * 根据路径获取文件
 * @param path 路径
 * @return 文件内容字符串
 */
- (NSString *)getDatasFromFilePath:(NSString *)path {
    //TODO: 测试信息
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"09.csv"];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *file = [[NSString alloc] initWithContentsOfFile:filePath encoding:enc error:nil];
    return file;
}

/**
 * 切割字符串
 * @param dataString 字符串
 * @return 切割后的数组
 */
- (NSArray *)separateDataStringToArray:(NSString *)dataString {
    NSArray<NSString *> *arr = [NSArray arrayWithArray:[dataString componentsSeparatedByString:@"\r"]];
    if (arr.count < 2) {
        return nil;
    }
    return arr;
}

/**
 * 数组转换为模型数组
 * @param dataArray 源数组
 * @return 模型数组
 */
- (NSArray <AttendanceRecordModel *> *)transformDatasArrayToModel:(NSArray *)dataArray {
    if (!dataArray) {
        return nil;
    }
    // 开始解析数组
    NSMutableArray *arrUsers = [[NSMutableArray alloc] init];
    AttendanceRecordModel *modelNowSelected = nil;
    for (NSString *strRecord in dataArray) {
        NSArray<NSString *> *arrOneRecord = [strRecord componentsSeparatedByString:@";"];

        // 获取有信息的索引值
        int index = 0;
        for (int j = 0; j < arrOneRecord.count; j++) {
            if (arrOneRecord[j].length > 2) {
                index = j;
                break;
            }
        }
        index++;
        // 判断是否需要创建新的model
        BOOL isNeedNew = YES;
        if (modelNowSelected && [modelNowSelected.userID isEqualToString:arrOneRecord[index]]) {
            isNeedNew = NO;
        } else {
            if (!modelNowSelected) {
                isNeedNew = YES;
            } else {
                NSString *userID = arrOneRecord[index];
                for (AttendanceRecordModel *model in arrUsers) {
                    if ([model.userID isEqualToString:userID]) {
                        isNeedNew = NO;
                        modelNowSelected = model;
                        break;
                    }
                }
            }
        }
        NSString *time = arrOneRecord[index + 3];
        NSDate *date = [self.dateFormatter dateFromString:time];
        if (!date) {
            continue;
        }
        if (isNeedNew) {
            modelNowSelected = [[AttendanceRecordModel alloc] init];
            modelNowSelected.userID = arrOneRecord[index];
            modelNowSelected.userName = arrOneRecord[index + 1];

            [modelNowSelected.records addObject:[[NSMutableArray alloc] initWithObjects:date, nil]];
            [arrUsers addObject:modelNowSelected];
        } else {
            // 不需要创建，在records中添加新的记录
            NSDateComponents *com = [self.calendar components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];

            BOOL isSameDay = NO;
            for (int i = 0; i < modelNowSelected.records.count; i++) {
                NSMutableArray *arrR = [NSMutableArray arrayWithArray:modelNowSelected.records[i]];
                NSDateComponents *comR = [self.calendar components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:arrR[0]];
                if (comR.month == com.month && comR.day == com.day) {
                    // 有同一天
                    isSameDay = YES;
                    [arrR addObject:date];
                    [modelNowSelected.records replaceObjectAtIndex:i withObject:arrR];
                    break;
                }
            }
            if (!isSameDay) {
                [modelNowSelected.records addObject:[[NSMutableArray alloc] initWithObjects:date, nil]];
            }
        }
    }

    return arrUsers;
}

/**
 * 创建新的用户模型
 * @param record 一条用户记录，用于判断需要生成的记录范围
 * @return 用户模型
 */
- (AttendanceUserModel *)createNewUserModelWithOneRecord:(AttendanceRecordModel *)record {
    AttendanceUserModel *model = [[AttendanceUserModel alloc] init];
    model.userID = record.userID;
    model.userName = record.userName;
    model.userAttendanceDates = [self createUserRecordListWithOneRecord:record.records[0][0]];
    return model;
}

/**
 * 创建新的用户记录模型
 * @param date 一条用户记录，用于判断需要生成的记录范围
 * @return 用户模型
 */
- (NSArray<AttendanceModel *> *)createUserRecordListWithOneRecord:(NSDate *)date {
    NSDateComponents *com = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    int count = 0;
    if (com.day > 25) {
        // 本月 26到下月25
        count = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    } else {
        // 上月26 到本月 25
        count = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[date dateByAddingTimeInterval:-3600 * 24 * 26]].length;
        com.month -= 1;
    }
    com.day = 26;

    if (count < 26) {
        return nil;
    }
    NSMutableArray<AttendanceModel *> *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        AttendanceModel *model = [[AttendanceModel alloc] init];
        model.unusuallyType = kUnusuallyTypeLessCount;
        model.dateComp = com;
        [arr addObject:model];
        NSDate *dateNew = [self.calendar dateFromComponents:com];
        dateNew = [dateNew dateByAddingTimeInterval:24 * 3600];
        com = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:dateNew];

    }

    return arr;
}

/**
 * 分析单个用户一天的记录，确定时候有异常
 * @param arrRecords 记录列表
 * @return Yes是有异常，NO是没有异常
 */
- (AttendanceModel *)analyzeDailyRecords:(NSArray<NSDate *> *)arrRecords {
    AttendanceModel *model = [[AttendanceModel alloc] init];
    model.unusuallyType = kUnusuallyTypeLessCount;

    arrRecords = [arrRecords sortedArrayUsingComparator:^NSComparisonResult(NSDate *obj1, NSDate *obj2) {
        return [obj1 timeIntervalSinceDate:obj2] > 0 ? NSOrderedDescending : NSOrderedAscending;
    }];

    model.dateFirstRecord = arrRecords.firstObject;
    model.dateLastRecord = arrRecords.lastObject;

    if (!arrRecords || arrRecords.count < 14) {
        model.unusuallyType = kUnusuallyTypeLessCount;
    } else {
        // 打卡次数无异常，判断打卡间隔
        // 循环遍历判断打卡是否有异常
        for (int i = 1; i < arrRecords.count; i++) {
            NSDate *date1 = arrRecords[i - 1];
            NSDate *date2 = arrRecords[i];
            if ([date2 timeIntervalSinceDate:date1] > 30 * 60) {
                // 其他情况
                model.unusuallyType = kUnusuallyTypeOverTime;

                // 超过 30分钟，需要判断是否是吃饭时间
                NSDateComponents *com1 = [self.calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date1];
                NSDateComponents *com2 = [self.calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date2];

                // 判断中午吃饭时间  11:00 -- 11:50
                // 10:30 -- 11:00 和 11:50 - 12:20 各有一次打卡就时正常
                if ((com1.hour == 10 && (com1.minute > 29 && com1.minute < 60)) || (com1.hour == 11 && com1.minute == 0)) {
                    model.unusuallyType = kUnusuallyTypeNormal;
                } else if ((com2.hour == 11 && com2.minute > 49) || (com2.hour == 12 && com2.minute < 21)) {
                    model.unusuallyType = kUnusuallyTypeNormal;
                }

                // 判断下午吃饭时间  15:40 -- 16:30
                // 15:10 -- 15:40 和 16:00 - 16:30 各有一次打卡就时正常
                if (com1.hour == 15 && (com1.minute > 9 && com1.minute < 41)) {
                    model.unusuallyType = kUnusuallyTypeNormal;
                } else if (com2.hour == 16 && (com2.minute > -1 && com2.minute < 31)) {
                    model.unusuallyType = kUnusuallyTypeNormal;
                }

                // 判断是否超时，如果是超时需要把超时时间记录
                if (model.unusuallyType == kUnusuallyTypeOverTime) {
                    // 记录时间
                    AttendanceUnusuallyModel *unusually = [[AttendanceUnusuallyModel alloc] init];
                    unusually.dateInfo = [NSString stringWithFormat:@"%d:%d:%d -- %d:%d:%d", com1.hour, com1.minute, com1.second, com2.hour, com2.minute, com2.second];
                    int seconds = [date2 timeIntervalSinceDate:date1] - 1800;
                    NSMutableString *str = [[NSMutableString alloc] init];
                    if (seconds >= 3600) {
                        [str appendString:[NSString stringWithFormat:@"%d时", seconds / 3600]];
                        seconds = seconds % 3600;
                    }
                    if (seconds > 60) {
                        [str appendString:[NSString stringWithFormat:@"%d分", seconds / 60]];
                        seconds = seconds % 60;
                    }
                    [str appendString:[NSString stringWithFormat:@"%d秒", seconds]];
                    unusually.time = str;
                    [model.arrUnusually addObject:unusually];
                }
            }
        }
    }

    return model;
}

#pragma mark - Getter 

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    return _dateFormatter;
}

- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    }
    return _calendar;
}

- (NSMutableArray<AttendanceUserModel *> *)arrDatas {
    if (!_arrDatas) {
        _arrDatas = [[NSMutableArray alloc] init];
    }
    return _arrDatas;
}

@end

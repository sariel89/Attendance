//
// Created by Sariel on 16/11/19.
// Copyright (c) 2016 Sariel. All rights reserved.
//

#import "AttendanceController.h"
#import "AttendanceModel.h"


@interface AttendanceController() <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UIButton *btnDownFile;
@property (weak, nonatomic) IBOutlet UITableView *tableResult;
@property (weak, nonatomic) IBOutlet UIButton *btnClearCache;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload;

@property (nonatomic, strong) NSMutableArray<AttendanceUserModel *> *arrDatas;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic,strong) NSCalendar *calendar;

@end

@implementation AttendanceController

#pragma mark - System Method
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
    
}

#pragma mark - Method
/**
 * 根据路径获取文件
 * @param path 路径
 * @return 文件内容字符串
 */
- (NSString *) getDatasFromFilePath:(NSString *)path {
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
- (NSArray *) separateDataStringToArray:(NSString *) dataString {
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
        for (int j = 0; j < arrOneRecord.count; j ++) {
            if (arrOneRecord[j].length > 2) {
                index = j;
                break;
            }
        }
        index ++;
        // 判断是否需要创建新的model
        BOOL isNeedNew = NO;
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
        if (isNeedNew) {
            modelNowSelected = [[AttendanceRecordModel alloc] init];
            modelNowSelected.userID = arrOneRecord[index];
            modelNowSelected.userName = arrOneRecord[index + 1];
            
            [modelNowSelected.records addObject:[[NSMutableArray alloc] initWithObjects:date, nil]];
            [arrUsers addObject:modelNowSelected];
        } else {
            // 不需要创建，在records中添加新的记录
            NSDateComponents *com = [self.calendar components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
            
            for (int i = 0; i < modelNowSelected.records.count; i ++) {
                NSMutableArray *arrR = modelNowSelected.records[i];
                NSDateComponents *comR = [self.calendar components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:arrR[0]];
                if (comR.month == com.month && comR.day == com.day) {
                    // 同一天
                    [arrR addObject:date];
                    break;
                }
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
- (AttendanceUserModel *) createNewUserModelWithOneRecord:(AttendanceRecordModel *)record {
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
    com.day = 26;
    if (com.day > 25) {
        // 本月 26到下月25
        count = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    } else {
        // 上月26 到本月 25
        count = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[date dateByAddingTimeInterval:-3600*24*26]].length;
        com.month -= com.month;
    }
    
    if (count < 26) {
        return nil;
    }
    NSMutableArray<AttendanceModel *> *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i ++) {
        AttendanceModel *model = [[AttendanceModel alloc] init];
        model.isUnusually = YES;
        model.dateComp = com;
        com.day += 1;
    }
    
    return arr;
}

/**
 * 分析单个用户一天的记录，确定时候有异常
 * @param arrRecords 记录列表
 * @return Yes是有异常，NO是没有异常
 */
- (BOOL) analyzeDailyRecords:(NSArray<NSDate *> *)arrRecords {
    BOOL isUnusual = NO;
    
    if (!arrRecords || arrRecords.count < 14) {
        isUnusual = YES;
    } else {
        // 打卡次数无异常，判断打卡间隔
        
    }
    
    return isUnusual;
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
    }
    return _calendar;
}

@end

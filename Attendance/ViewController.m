//
//  ViewController.m
//  Attendance
//
//  Created by Sariel on 16/11/5.
//  Copyright © 2016年 Sariel. All rights reserved.
//

#import "ViewController.h"
#import "AttendanceModel.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UIButton *btnDownFile;
@property (weak, nonatomic) IBOutlet UITableView *tableResult;
@property (weak, nonatomic) IBOutlet UIButton *btnClearCache;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload;

@property (strong, nonatomic) UIWebView *viewWeb;

@property (nonatomic, strong) NSMutableArray<AttendanceRecordModel *> *arrDatas;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.labTime.layer.borderColor = [UIColor colorWithRed:0 green:(148.0 / 255.0) blue:(141.0 / 255.0) alpha:1].CGColor;
    self.labTime.layer.borderWidth = 1;
    self.labTime.userInteractionEnabled = YES;
    [self.labTime addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabTime)]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableviewDelegate, UITabelviewDatasource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finish load url.");
}

#pragma mark - method
- (void) handleCSVFile:(NSString *)fileName {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        // Test
//        NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"09.csv"];
//        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//        NSString *file = [[NSString alloc] initWithContentsOfFile:filePath encoding:enc error:nil];
//        // 开始分割
//        NSArray<NSString *> *arr = [NSArray arrayWithArray:[file componentsSeparatedByString:@"\r"]];
//        if (arr.count < 2) {
//            return;
//        }
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//        
//        NSMutableArray *arrModels = [[NSMutableArray alloc] init];
//        for (int i = 0; i < arr.count; i ++) {
//            NSArray<NSString *> *arrInfo = [arr[i] componentsSeparatedByString:@";"];
//            
//            int index = 0;
//            for (int j = 0; j < arrInfo.count; j ++) {
//                if (arrInfo[j].length > 2) {
//                    index = j;
//                    break;
//                }
//            }
//            index ++;
//            // 创建 打卡记录model
//            AttendanceModel *model = [[AttendanceModel alloc] init];
//            model.userID = arrInfo[index++];
//            model.userName = arrInfo[index++];
//            model.address1 = arrInfo[index++];
//            NSString *strTime1 = arrInfo[index++];
//            model.date1 = [formatter dateFromString:strTime1];
//            model.address2 = arrInfo[index++];
//            NSString *strTime2 = arrInfo[index];
//            model.date2 = [formatter dateFromString:strTime2];
//            
//            // 判断是否需要放到已经存在的arr里面
//            BOOL isHaveUserArr = NO;
//            for (int j = 0; j < arrModels.count; j ++) {
//                NSMutableArray *oldModels = [NSMutableArray arrayWithArray:arrModels[j]];
//                if ([model.userID isEqualToString:((AttendanceModel *)oldModels.firstObject).userID]) {
//                    [oldModels addObject:model];
//                    [arrModels replaceObjectAtIndex:j withObject:oldModels];
//                    isHaveUserArr = YES;
//                    break;
//                }
//            }
//            if (!isHaveUserArr) {
//                [arrModels addObject:@[model]];
//            }
//        }
//        
//        self.arrDatas = [[NSMutableArray alloc] initWithCapacity:arrModels.count];
//        // 开始检查是否有打卡问题
//        for (int i = 0; i < arrModels.count; i ++) {
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSArray<AttendanceModel *> *arr = [arrModels[i] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//                    return [[(AttendanceModel *)obj1 date1] timeIntervalSinceDate:[(AttendanceModel *)obj2 date1]] < 0;
//                }];
//                
//                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//                NSMutableArray<NSArray *> *arrUserRecord = [[NSMutableArray alloc] init];
//                // 先吧每个人的打卡时间按天分隔好，然后再比较
//                for (int k = 0; k < arr.count; k ++) {
//                    AttendanceModel *modelAttendance = arr[k];
//                    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:modelAttendance.date1];
//                    // 检查是否已经存在
//                    BOOL isHaveInUserRecord = NO;
//                    for (int m = 0; m < arrUserRecord.count; m ++) {
//                        NSMutableArray<AttendanceModel *> *arrTemp = [NSMutableArray arrayWithArray:arrUserRecord[m]];
//                        NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:arrTemp[0].date1];
//                        if (comps.year == comp.year && comps.month == comp.month && comps.day == comp.day) {
//                            // 同一天
//                            [arrTemp addObject:modelAttendance];
//                            isHaveInUserRecord = YES;
//                            break;
//                        }
//                    }
//                    if (!isHaveInUserRecord) {
//                        [arrUserRecord addObject:@[modelAttendance]];
//                    }
//                    
//                }
//                
//                // 遍历用户所有数据，查看是否有异常
//                for (int k = 0; k < arrUserRecord.count; k ++) {
//                    [self checkDailyAttendance:arrUserRecord[k] recordModel:self.arrDatas[i]];
//                }
//                
//            });
//        }
//        
//    });
    
}


// 判断每天的打卡时间是否超过30分钟
- (void) checkDailyAttendance:(NSArray<AttendanceModel *> *)arrDaily recordModel:(AttendanceRecordModel *)modelGet {
//    for (int i = 1; i < arrDaily.count; i ++) {
//        if ([arrDaily[i].date1 timeIntervalSinceDate:arrDaily[i - 1].date1] > 30 * 60) {
//            // 打卡时间超过30分钟， 异常
//            return;
//        }
//    }
//    // 没有异常，修改状态
//    for (AttendanceRecordStatusModel *modelStatus in modelGet.arrRecodes) {
//        modelStatus.isUnusual = NO;
//    }
}

#pragma mark - action
- (void) tapLabTime {
    NSLog(@"点击时间 － 弹出时间选择控制器");
}

- (IBAction)actionDownFile:(id)sender {
    NSLog(@"下载文件");
    //TODO: 替换为真实信息
    [self handleCSVFile:nil];
    
}

- (IBAction)actionClearCache:(id)sender {
    NSLog(@"清除缓存文件");
}

- (IBAction)actionUploadFile:(id)sender {
    NSLog(@"上传文件");
}

#pragma mark - Getter
- (NSMutableArray *)arrDatas {
    if (!_arrDatas) {
        _arrDatas = [[NSMutableArray alloc] init];
    }
    return _arrDatas;
}

- (UIWebView *)viewWeb {
    if (!_viewWeb) {
        _viewWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 100, 320, 300)];
        _viewWeb.delegate = self;
        [self.view addSubview:_viewWeb];
    }
    return _viewWeb;
}
@end

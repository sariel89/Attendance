//
// Created by Sariel on 16/11/19.
// Copyright (c) 2016 Sariel. All rights reserved.
//

#import "AttendanceController.h"
#import "AttendanceModel.h"
#import "AttendanceCell.h"
#import "AttendanceLogDataHandle.h"
#import "SarielDatePickerView.h"
#import "AFNetworking.h"

@interface AttendanceController () <UITableViewDelegate, UITableViewDataSource>
@property(weak, nonatomic) IBOutlet UILabel *labTime;
@property(weak, nonatomic) IBOutlet UIButton *btnDownFile;
@property(weak, nonatomic) IBOutlet UITableView *tableResult;
@property(weak, nonatomic) IBOutlet UIButton *btnClearCache;
@property(weak, nonatomic) IBOutlet UIButton *btnUpload;

@property(nonatomic, strong) NSMutableArray<AttendanceUserModel *> *arrDatas;

@property(nonatomic, strong) NSArray<AttendanceUserModel *> *arrTableDatas;

@property(nonatomic, strong) AttendanceLogDataHandle *dataHandle;
@property(nonatomic, strong) SarielDatePickerView *viewPicker;

@end

@implementation AttendanceController

#pragma mark - System Method

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat) (242.0 / 255.0) green:(CGFloat) (242.0 / 255.0) blue:(CGFloat) (242.0 / 255.0) alpha:1];
    self.labTime.layer.borderColor = [UIColor colorWithRed:(CGFloat) 0 green:(CGFloat) (148.0 / 255.0) blue:(CGFloat) (141.0 / 255.0) alpha:1].CGColor;
    self.labTime.layer.borderWidth = 1;
    self.labTime.userInteractionEnabled = YES;
    [self.labTime addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabTime)]];

    self.tableResult.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *viewHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    viewHeader.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    viewHeader.font = [UIFont systemFontOfSize:16];
    viewHeader.text = [NSString stringWithFormat:@"  %@", self.arrDatas[section].userName];
    return viewHeader;
}

#pragma mark - Action

- (void)tapLabTime {
    [self.viewPicker showView];
}

- (IBAction)actionDownFile:(id)sender {
    NSLog(@"下载文件");

    NSString *strURL = [NSString stringWithFormat:@"http://oisdy8krb.bkt.clouddn.com/%@.csv?%f", self.labTime.text, [[NSDate date] timeIntervalSince1970]];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [[manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *strFileName = [documentPath stringByAppendingPathComponent:response.suggestedFilename];
        NSLog(@"file name : %@", strFileName);
        return [NSURL fileURLWithPath:strFileName];
    }               completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (!error) {
            [self.arrDatas removeAllObjects];
            self.arrDatas = [self.dataHandle beginReadFileAndHandle:filePath];
            [self.tableResult reloadData];

        } else {
            //TODO: show error message.

        }
    }] resume];

}

- (IBAction)actionClearCache:(id)sender {
    NSLog(@"清除缓存文件");
}

- (IBAction)actionUploadFile:(id)sender {
    NSLog(@"上传文件");
}

#pragma mark - Method


#pragma mark - Getter

- (NSMutableArray<AttendanceUserModel *> *)arrDatas {
    if (!_arrDatas) {
        _arrDatas = [[NSMutableArray alloc] init];
    }
    return _arrDatas;
}

- (NSArray<AttendanceUserModel *> *)arrTableDatas {
    if (!_arrTableDatas) {
        _arrTableDatas = [[NSArray alloc] init];
    }
    return _arrTableDatas;
}

- (AttendanceLogDataHandle *)dataHandle {
    if (!_dataHandle) {
        _dataHandle = [[AttendanceLogDataHandle alloc] init];
    }
    return _dataHandle;
}

- (SarielDatePickerView *)viewPicker {
    if (!_viewPicker) {
        _viewPicker = [[SarielDatePickerView alloc] init];
        _viewPicker.showType = kDateShowType_YearAndMonth;
        [_viewPicker setSarielDatePickerBlock:^(NSString *strDate) {
            self.labTime.text = strDate;
        }];
    }
    return _viewPicker;
}

@end

//
// Created by Sariel on 16/11/28.
// Copyright (c) 2016 Sariel. All rights reserved.
//

#import "AttendanceCell.h"

#define AppWidth [UIScreen mainScreen].bounds.size.width

@interface AttendanceCell ()

@property(nonatomic, strong) UILabel *labDate; // 日期
@property(nonatomic, strong) UILabel *labStatus;   // 状态
@property(nonatomic, strong) UILabel *labFirstRecord; // 第一条数据
@property(nonatomic, strong) UILabel *labLastRecord;   // 最后一条数据
@property(nonatomic, strong) UIView *viewRecords;      // 超时记录

@end

@implementation AttendanceCell {

}

#pragma mark - UI

- (void)updateUI {
    // 日期
    NSMutableAttributedString *strDate = [[NSMutableAttributedString alloc] init];
    [strDate appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", self.dataModel.dateComp.month] attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:20]}]];
    [strDate appendAttributedString:[[NSAttributedString alloc] initWithString:@"月" attributes:nil]];
    [strDate appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", self.dataModel.dateComp.day] attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:20]}]];
    [strDate appendAttributedString:[[NSAttributedString alloc] initWithString:@"日" attributes:nil]];
    self.labDate.attributedText = strDate;
    // 状态
    switch (self.dataModel.unusuallyType) {
        case kUnusuallyTypeLessCount: {
            // 次数不足
            self.labStatus.text = @"次数不足";
            self.labStatus.textColor = [UIColor redColor];
        }
            break;
        case kUnusuallyTypeOverTime: {
            // 超时
            self.labStatus.text = @"间隔过长";
            self.labStatus.textColor = [UIColor redColor];
        }
            break;
        case kUnusuallyTypeLessStation: {
            // 站点数太少
            self.labStatus.text = @"站点太少";
            self.labStatus.textColor = [UIColor redColor];
        }
            break;
        default: {
            // 正常
            self.labStatus.text = @"打卡正常";
            self.labStatus.textColor = [UIColor greenColor];
        }
            break;
    }

    // 第一次打卡时间和最后一次打卡时间
    self.labFirstRecord.text = [NSString stringWithFormat:@"%@", self.dataModel.dateFirstRecord];
    self.labLastRecord.text = [NSString stringWithFormat:@"%@", self.dataModel.dateLastRecord];

    // 超时记录
    if (self.dataModel.unusuallyType == kUnusuallyTypeOverTime) {
        self.viewRecords.hidden = NO;
        // 移除之前的View
        for (UIView *vi in self.viewRecords.subviews) {
            if (vi.tag > 0) {
                [vi removeFromSuperview];
            }
        }

        for (int i = 0; i < self.dataModel.arrUnusually.count; i++) {
            AttendanceUnusuallyModel *model = self.dataModel.arrUnusually[i];
            UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 30 + i * 30, self.viewRecords.frame.size.width, 30)];
            vi.tag = i + 1000;
            UIView *viLine = [[UIView alloc] initWithFrame:CGRectMake(0, 29, vi.frame.size.width, 1)];
            viLine.backgroundColor = [UIColor colorWithRed:(CGFloat)(229.0 / 255.0) green:(CGFloat)(229.0 / 255.0) blue:(CGFloat)(229.0 / 255.0) alpha:1];
            [vi addSubview:viLine];

            UILabel *labDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, vi.frame.size.width / 2, 30)];
            labDate.textColor = [UIColor lightGrayColor];
            labDate.font = [UIFont systemFontOfSize:12];
            labDate.text = [NSString stringWithFormat:@"时间:%@", model.dateInfo];
            [vi addSubview:labDate];
            UILabel *labState = [[UILabel alloc] initWithFrame:CGRectMake(vi.frame.size.width / 2, 0, vi.frame.size.width / 2, 30)];
            labState.textColor = [UIColor redColor];
            labState.font = [UIFont systemFontOfSize:12];
            labState.textAlignment = NSTextAlignmentRight;
            labState.text = [NSString stringWithFormat:@"超时:%@", model.time];
            [vi addSubview:labState];

            [self.viewRecords addSubview:vi];
        }
        CGRect frame = self.viewRecords.frame;
        frame.size.height = (self.dataModel.arrUnusually.count + 1) * 30;
        self.viewRecords.frame = frame;
        self.dataModel.cellHeight = CGRectGetMaxY(self.viewRecords.frame) + 8;

    } else {
        self.viewRecords.hidden = YES;
        self.dataModel.cellHeight = 81 + 8;
    }

}


#pragma mark - Setter

- (void)setDataModel:(AttendanceModel *)dataModel {
    if (dataModel) {
        _dataModel = dataModel;
        [self updateUI];
    }
}

#pragma mark - getter

- (UILabel *)labDate {
    if (!_labDate) {
        _labDate = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, AppWidth / 2 - 20, 40)];
        _labDate.textColor = [UIColor darkTextColor];
        _labDate.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:_labDate];
    }
    return _labDate;
}

- (UILabel *)labStatus {
    if (!_labStatus) {
        _labStatus = [[UILabel alloc] initWithFrame:CGRectMake(AppWidth / 2, 0, AppWidth / 2 - 20, 40)];
        _labStatus.textColor = [UIColor lightGrayColor];
        _labStatus.font = [UIFont systemFontOfSize:14];
        _labStatus.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_labStatus];
    }
    return _labStatus;
}

- (UILabel *)labFirstRecord {
    if (!_labFirstRecord) {
        _labFirstRecord = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, AppWidth / 2, 40)];
        _labFirstRecord.textColor = [UIColor lightGrayColor];
        _labFirstRecord.backgroundColor = [UIColor brownColor];
        _labFirstRecord.font = [UIFont systemFontOfSize:14];
        _labFirstRecord.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labFirstRecord];
    }
    return _labFirstRecord;
}

- (UILabel *)labLastRecord {
    if (!_labLastRecord) {
        _labLastRecord = [[UILabel alloc] initWithFrame:CGRectMake(AppWidth / 2, 41, AppWidth / 2, 40)];
        _labLastRecord.textColor = [UIColor lightGrayColor];
        _labLastRecord.backgroundColor = [UIColor grayColor];
        _labLastRecord.font = [UIFont systemFontOfSize:14];
        _labLastRecord.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labLastRecord];
    }
    return _labLastRecord;
}

- (UIView *)viewRecords {
    if (!_viewRecords) {
        _viewRecords = [[UIView alloc] initWithFrame:CGRectMake(12, 81, AppWidth - 24, 30)];
        _viewRecords.backgroundColor = [UIColor colorWithRed:(CGFloat) (240.0 / 255.0) green:(CGFloat) (240.0 / 255.0) blue:(CGFloat) (240.0 / 255.0) alpha:1];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, 30)];
        lab.textColor = [UIColor lightGrayColor];
        lab.font = [UIFont systemFontOfSize:13];
        lab.text = @"异常记录:";
        [_viewRecords addSubview:lab];
        [self.contentView addSubview:_viewRecords];
    }
    return _viewRecords;
}
@end

//
// Created by Sariel on 16/11/28.
// Copyright (c) 2016 Sariel. All rights reserved.
//

#import "AttendanceCell.h"

#define AppWidth ([UIScreen mainScreen].bounds.size.width - 32)
#define ColorBlue   [UIColor colorWithRed:(18.0 / 255.0) green:(86.0 / 255.0) blue:(158.0 / 255.0) alpha:1]
#define ColorGreen  [UIColor colorWithRed:(35.0 / 255.0) green:(151.0 / 255.0) blue:(16.0 / 255.0) alpha:1]
#define ColorYellow [UIColor colorWithRed:(253.0 / 255.0) green:(204.0 / 255.0) blue:(1.0 / 255.0) alpha:1]
#define ColorRed    [UIColor colorWithRed:(208.0 / 255.0) green:(2.0 / 255.0) blue:(27.0 / 255.0) alpha:1]
#define ColorBrownDeep    [UIColor colorWithRed:(90.0 / 255.0) green:(42.0 / 255.0) blue:(0.0 / 255.0) alpha:1]
#define ColorBrownLight    [UIColor colorWithRed:(203.0 / 255.0) green:(96.0 / 255.0) blue:(0.0 / 255.0) alpha:1]
#define ColorGrayLine [UIColor colorWithRed:(CGFloat)(229.0 / 255.0) green:(CGFloat)(229.0 / 255.0) blue:(CGFloat)(229.0 / 255.0) alpha:1]

@interface AttendanceCell ()

@property(nonatomic, strong) UIView *viewBG;    // 背景层
@property(nonatomic, strong) UILabel *labDate; // 日期
@property(nonatomic, strong) UILabel *labStatus;   // 状态
@property(nonatomic, strong) UILabel *labFirstRecord; // 第一条数据
@property(nonatomic, strong) UILabel *labLastRecord;   // 最后一条数据
@property(nonatomic, strong) UIView *viewRecords;      // 超时记录

@end

@implementation AttendanceCell {

}

#pragma mark - System

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:(CGFloat) (242.0 / 255.0) green:(CGFloat) (242.0 / 255.0) blue:(CGFloat) (242.0 / 255.0) alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
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
            self.labStatus.textColor = ColorBlue;
        }
            break;
        case kUnusuallyTypeOverTime: {
            // 超时
            self.labStatus.text = @"间隔过长";
            self.labStatus.textColor = ColorRed;
        }
            break;
        case kUnusuallyTypeLessStation: {
            // 站点数太少
            self.labStatus.text = @"站点太少";
            self.labStatus.textColor = ColorRed;
        }
            break;
        default: {
            // 正常
            self.labStatus.text = @"打卡正常";
            self.labStatus.textColor = ColorGreen;
        }
            break;
    }

    // 第一次打卡时间和最后一次打卡时间
    if (self.dataModel.dateFirstRecord) {
        self.labFirstRecord.text = [[NSString stringWithFormat:@"%@", self.dataModel.dateFirstRecord] substringWithRange:NSMakeRange(10, 10)];
    } else {
        self.labFirstRecord.text = @"无记录";
    }
    if (self.dataModel.dateLastRecord) {
        self.labLastRecord.text = [[NSString stringWithFormat:@"%@", self.dataModel.dateLastRecord] substringWithRange:NSMakeRange(10, 10)];
    } else {
        self.labLastRecord.text = @"无记录";
    }

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
            viLine.backgroundColor = ColorGrayLine;
            [vi addSubview:viLine];

            UILabel *labDate = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, vi.frame.size.width / 2 - 12, 30)];
            labDate.textColor = [UIColor lightGrayColor];
            labDate.font = [UIFont systemFontOfSize:12];
            labDate.text = [NSString stringWithFormat:@"%@", model.dateInfo];
            [vi addSubview:labDate];

            UILabel *labState = [[UILabel alloc] initWithFrame:CGRectMake(vi.frame.size.width / 2, 0, vi.frame.size.width / 2 - 12, 30)];
            labState.textColor = ColorRed;
            labState.font = [UIFont systemFontOfSize:12];
            labState.textAlignment = NSTextAlignmentRight;
            labState.text = [NSString stringWithFormat:@"超时:%@", model.time];
            [vi addSubview:labState];

            [self.viewRecords addSubview:vi];
        }
        CGRect frame = self.viewRecords.frame;
        frame.size.height = (self.dataModel.arrUnusually.count + 1) * 30;
        self.viewRecords.frame = frame;
        self.viewBG.frame = CGRectMake(0, 0, AppWidth, CGRectGetMaxY(self.viewRecords.frame) + 8);
        self.dataModel.cellHeight = CGRectGetMaxY(self.viewBG.frame) + 10;

    } else {
        self.viewRecords.hidden = YES;
        self.viewBG.frame = CGRectMake(0, 0, AppWidth, 81 + 8);
        self.dataModel.cellHeight = CGRectGetMaxY(self.viewBG.frame) + 10;
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
        [self.viewBG addSubview:_labDate];

        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40, AppWidth, 1)];
        viewLine.backgroundColor = ColorGrayLine;
        [self.viewBG addSubview:viewLine];
    }
    return _labDate;
}

- (UILabel *)labStatus {
    if (!_labStatus) {
        _labStatus = [[UILabel alloc] initWithFrame:CGRectMake(AppWidth / 2, 0, AppWidth / 2 - 20, 40)];
        _labStatus.textColor = [UIColor lightGrayColor];
        _labStatus.font = [UIFont systemFontOfSize:14];
        _labStatus.textAlignment = NSTextAlignmentRight;
        [self.viewBG addSubview:_labStatus];
    }
    return _labStatus;
}

- (UILabel *)labFirstRecord {
    if (!_labFirstRecord) {
        _labFirstRecord = [[UILabel alloc] initWithFrame:CGRectMake(12, 41, AppWidth / 2 - 12, 40)];
        _labFirstRecord.textColor = ColorBrownDeep;
        _labFirstRecord.font = [UIFont systemFontOfSize:14];
        _labFirstRecord.textAlignment = NSTextAlignmentCenter;
        [self.viewBG addSubview:_labFirstRecord];
    }
    return _labFirstRecord;
}

- (UILabel *)labLastRecord {
    if (!_labLastRecord) {
        _labLastRecord = [[UILabel alloc] initWithFrame:CGRectMake(AppWidth / 2, 41, AppWidth / 2 - 12, 40)];
        _labLastRecord.textColor = ColorBrownLight;
        _labLastRecord.font = [UIFont systemFontOfSize:14];
        _labLastRecord.textAlignment = NSTextAlignmentCenter;
        [self.viewBG addSubview:_labLastRecord];

        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 40)];
        viewLine.backgroundColor = ColorGrayLine;
        [_labLastRecord addSubview:viewLine];

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
        [self.viewBG addSubview:_viewRecords];
    }
    return _viewRecords;
}

- (UIView *)viewBG {
    if (!_viewBG) {
        _viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AppWidth, 50)];
        _viewBG.backgroundColor = [UIColor whiteColor];
        _viewBG.layer.borderColor = [UIColor blackColor].CGColor;
        _viewBG.layer.borderWidth = 1;
        [self.contentView addSubview:_viewBG];
    }
    return _viewBG;
}
@end

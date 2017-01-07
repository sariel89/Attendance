//
// Created by Sariel on 2017/1/4.
// Copyright (c) 2017 Sariel. All rights reserved.
//

#import "AttendanceFilterView.h"

@interface AttendanceFilterView () <UIPickerViewDataSource, UIPickerViewDelegate>
@property(nonatomic, strong) UIView *viewBG;
@property(nonatomic, strong) UIToolbar *toolBar;
@property(nonatomic, strong) UIPickerView *viewPicker;

@property (nonatomic, strong) NSArray *arrDatas;
@end

@implementation AttendanceFilterView {
}

#pragma mark - System Method

- (instancetype)init {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)]];
        _arrDatas = @[];
    }
    return self;
}

#pragma mark - Action
/**
 * 展示 View
 * @param arrNames
 */
- (void)showFilterWithNames:(NSArray *)arrNames {
    if (!arrNames || 0 == arrNames.count) {
        return;
    }

    [[UIApplication sharedApplication].keyWindow addSubview:self];

    // 刷新数据
    self.arrDatas = arrNames;
    [self.viewPicker reloadAllComponents];

    // 显示View
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.viewBG.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -self.viewBG.frame.size.height);
    }];
}

/**
 * 隐藏View
 */
- (void)hiddenView {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.viewBG.transform = CGAffineTransformIdentity;
    }                completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

/// 点击确定按钮
- (void)tapDoneBtn {
    NSInteger selectedNameIndex = [self.viewPicker selectedRowInComponent:0];
    NSInteger selectedDateIndex = [self.viewPicker selectedRowInComponent:1];
    if (self.tapDoneItemBlock) {
        self.tapDoneItemBlock([NSString stringWithFormat:@"%d|%d", selectedNameIndex, selectedDateIndex]);
    }

    [self hiddenView];
}

#pragma mark - UIPickerViewDelegate, UIPickerDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0: {
            if (0 == row) {
                return @"全部";
            } else {
                return self.arrDatas[row - 1];
            }
        }
            break;
        default:{
            // 日期
            if (0 == row) {
                return @"全部";
            } else {
                return [NSString stringWithFormat:@"%d日", row];
            }
        }
            break;
    }
    return @"";
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger row = 0;
    switch (component) {
        case 0: {
            row = self.arrDatas.count;
        }
            break;
        default:{
            row = 32;
        }
            break;
    }
    return row;
}

#pragma mark - Getter
- (UIView *)viewBG {
    if (!_viewBG) {
        _viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 260)];
        _viewBG.backgroundColor = [UIColor whiteColor];
        [self addSubview:_viewBG];
    }
    return _viewBG;
}

- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.viewBG.frame.size.width, 44)];
        UIBarButtonItem *itemCacel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(hiddenView)];
        itemCacel.width = 60;
        UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *itemDone = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(tapDoneBtn)];
        itemDone.width = 60;
        _toolBar.items = @[itemCacel, itemSpace, itemDone];
        [self.viewBG addSubview:_toolBar];
    }
    return _toolBar;
}

- (UIPickerView *)viewPicker {
    if (!_viewPicker) {
        _viewPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.toolBar.frame.size.height, self.toolBar.frame.size.width, 216)];
        _viewPicker.dataSource = self;
        _viewPicker.delegate = self;
        [self.viewBG addSubview:_viewPicker];
    }
    return _viewPicker;
}
@end

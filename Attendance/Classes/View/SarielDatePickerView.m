//
//  SarielDatePickerView.m
//  GCDTest
//
//  Created by sariel on 2016/12/26.
//  Copyright © 2016年 sariel. All rights reserved.
//

#import "SarielDatePickerView.h"

@interface SarielDatePickerView() <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *arrDatas;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIPickerView *viewPicker;
//@property (nonatomic, strong) 

@end

@implementation SarielDatePickerView

#pragma mark - System
- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidden = YES;
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 256);
        self.toolBar.hidden = NO;
    }
    return self;
}

#pragma mark - UI
/// 显示 view
- (void)showView {
    if (!self.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.hidden = NO;
        [self.viewPicker reloadAllComponents];
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -256);
        }];
    }
    
}

/// 隐藏 view
- (void) hiddenView {
    if (self.superview) {
        [UIView animateWithDuration:0.3f animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.hidden = YES;
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - Action
- (void) tapToolBarItemCancel {
    [self hiddenView];
}

- (void) tapToolBarItemDone {
    
    NSMutableString *strSelected = [[NSMutableString alloc] init];
    switch (self.showType) {
        case kDateShowType_OnlyYear: {
            NSInteger selectedYearCompIndex = [self.viewPicker selectedRowInComponent:0];
            [strSelected appendString:self.arrDatas[0][selectedYearCompIndex]];
        }
            break;
        case kDateShowType_YearAndMonth: {
            NSInteger selectedYearCompIndex = [self.viewPicker selectedRowInComponent:0];
            NSInteger selectedMonthCompIndex = [self.viewPicker selectedRowInComponent:1];
            
            [strSelected appendString:self.arrDatas[0][selectedYearCompIndex]];
            [strSelected appendString:[NSString stringWithFormat:@"-%@", self.arrDatas[1][selectedMonthCompIndex]]];
        }
            break;
        case kDateShowType_All: {
            NSInteger selectedYearCompIndex = [self.viewPicker selectedRowInComponent:0];
            NSInteger selectedMonthCompIndex = [self.viewPicker selectedRowInComponent:1];
            NSInteger selectedDayCompIndex = [self.viewPicker selectedRowInComponent:2];
            
            [strSelected appendString:self.arrDatas[0][selectedYearCompIndex]];
            [strSelected appendString:[NSString stringWithFormat:@"-%@", self.arrDatas[1][selectedMonthCompIndex]]];
            [strSelected appendString:[NSString stringWithFormat:@"-%@", self.arrDatas[2][selectedDayCompIndex]]];
        }
            break;
            
        default:
            break;
    }
    
    if (self.sarielDatePickerBlock && strSelected.length > 0) {
        self.sarielDatePickerBlock(strSelected);
    }
    
    [self hiddenView];
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@" 选中某一个 component");
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.arrDatas.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component < self.arrDatas.count) {
        return [(NSArray *)self.arrDatas[component] count];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component < self.arrDatas.count) {
        NSArray *arr = self.arrDatas[component];
        if (row < arr.count) {
            NSString *title = @"";
            switch (component) {
                case 0: {
                    title = [NSString stringWithFormat:@"%@年", arr[row]];
                }
                    break;
                case 1: {
                    title = [NSString stringWithFormat:@"%@月", arr[row]];
                }
                    break;
                case 2: {
                    title = [NSString stringWithFormat:@"%@日", arr[row]];
                }
                    break;
                default:
                    break;
            }
            return title;
        }
    }
    return @"";
}




#pragma mark - Getter
- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        _toolBar.backgroundColor = [UIColor whiteColor];
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _toolBar.frame.size.width, 0.5)];
        viewLine.backgroundColor = [UIColor lightGrayColor];
        [_toolBar addSubview:viewLine];
        
        UIBarButtonItem *itemCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(tapToolBarItemCancel)];
        itemCancel.width = 60;
        
        UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *itemDone = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(tapToolBarItemDone)];
        itemDone.width = 60;
        
        _toolBar.items = @[itemCancel, itemSpace, itemDone];
        [self addSubview:_toolBar];
    }
    return _toolBar;
}
- (UIPickerView *)viewPicker {
    if (!_viewPicker) {
        _viewPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 216)];
        _viewPicker.dataSource = self;
        _viewPicker.delegate = self;
        [self addSubview:_viewPicker];
    }
    return _viewPicker;
}

- (NSArray *)arrDatas {
    if (!_arrDatas) {
        NSMutableArray *arrYear = [[NSMutableArray alloc] init];
        NSInteger nowYear = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] component:NSCalendarUnitYear fromDate:[NSDate date]];
        
        for (NSInteger i = nowYear - 10; i < nowYear + 10; i ++) {
            [arrYear addObject:[NSString stringWithFormat:@"%ld", (long)i]];
        }
        
        NSArray *arrMonth = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
        NSMutableArray *arrDays = [[NSMutableArray alloc] init];
        for (int i = 1; i < 32; i ++) {
            [arrDays addObject:[NSString stringWithFormat:@"%02d", i]];
        }
        
        switch (self.showType) {
            case kDateShowType_OnlyYear: {
                _arrDatas = @[arrYear];
            }
                break;
            case kDateShowType_YearAndMonth: {
                _arrDatas = @[arrYear, arrMonth];
            }
                break;
            case kDateShowType_All: {
                _arrDatas = @[arrYear, arrMonth, arrDays];
            }
                break;
                
            default: {
                _arrDatas = @[arrYear, arrMonth, arrDays];
            }
                break;
        }
    }
    return _arrDatas;
}

@end

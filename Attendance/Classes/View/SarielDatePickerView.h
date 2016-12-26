//
//  SarielDatePickerView.h
//  GCDTest
//
//  Created by sariel on 2016/12/26.
//  Copyright © 2016年 sariel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, kDateShowType) {
    kDateShowType_OnlyYear = 1 << 0,
    kDateShowType_YearAndMonth = 1 << 1,
    kDateShowType_All   = 1 << 2,
};

@interface SarielDatePickerView : UIView

@property (nonatomic, assign) kDateShowType showType;

@property (nonatomic, copy) void (^sarielDatePickerBlock)(NSString *strDate);

- (void) showView;

@end

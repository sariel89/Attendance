//
// Created by Sariel on 2017/1/3.
// Copyright (c) 2017 Sariel. All rights reserved.
//

#import "HUD.h"
#import "MBProgressHUD.h"

#define keyWindow [UIApplication sharedApplication].keyWindow

@implementation HUD {

}

+ (void)showHUD {
    [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
}

+ (void)hiddenHUD {
    [MBProgressHUD hideHUDForView:keyWindow animated:YES];
}

+ (void)toast:(NSString *)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;
    hud.offset = CGPointMake(0, MBProgressMaxOffset);
    [hud hideAnimated:YES afterDelay:1.5f];
}
@end
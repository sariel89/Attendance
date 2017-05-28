//
//  NameListViewController.h
//  Attendance
//
//  Created by sariel on 2017/5/28.
//  Copyright © 2017年 Sariel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameListViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (weak, nonatomic) IBOutlet UICollectionView *nameList;
@end

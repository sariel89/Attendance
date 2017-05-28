//
//  NameListCell.h
//  Attendance
//
//  Created by sariel on 2017/5/28.
//  Copyright © 2017年 Sariel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameListCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *desc;

- (void) updateUI;

@end

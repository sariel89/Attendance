//
//  NameListViewController.m
//  Attendance
//
//  Created by sariel on 2017/5/28.
//  Copyright © 2017年 Sariel. All rights reserved.
//

#import "NameListViewController.h"
#import "NameListCell.h"

@interface NameListViewController ()
@property(nonatomic, strong) NSArray *arrNames;
@end

@implementation NameListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnDate.layer.borderColor = [UIColor blackColor].CGColor;
    self.btnDate.layer.borderWidth = 1;
    [self.btnDate addTarget:self action:@selector(pressDateBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) pressDateBtn {
    NSLog(@"press date btn");
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDatasource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NameListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell updateUI];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrNames.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end

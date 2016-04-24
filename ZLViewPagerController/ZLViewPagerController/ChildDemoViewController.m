//
//  ChildDemoViewController.m
//  ZLViewPagerController
//
//  Created by ZhangLe on 16/4/24.
//  Copyright © 2016年 30days-tech. All rights reserved.
//

#import "ChildDemoViewController.h"

@implementation ChildDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 66;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    NSLog(@"----- %s -----", __func__);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:(arc4random()%255 + 50)/255.0 green:(arc4random()%255 + 50)/255.0 blue:(arc4random()%255 + 50)/255.0 alpha:1.0];
    cell.textLabel.text = [NSString stringWithFormat:@"-------DemoTableViewCell-------%ld-------%@", indexPath.row, self.title];
    
    return cell;
}

@end

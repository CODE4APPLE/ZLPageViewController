//
//  ZLScrollPageViewController.h
//  ZLViewPagerController
//
//  Created by ZhangLe on 16/4/24.
//  Copyright © 2016年 30days-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLScrollPageViewController : UIViewController

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray<__kindof UIViewController*> *pageControllers;

@end

//
//  ViewController.m
//  ZLViewPagerController
//
//  Created by ZhangLe on 16/4/24.
//  Copyright © 2016年 30days-tech. All rights reserved.
//

#import "ViewController.h"
#import "ChildDemoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildVC];
    
    //self.selectedPageIndex = 2;
    
    NSLog(@"----%s----", __func__);
}

- (void)setupChildVC {
    ChildDemoViewController *wordVc1 = [[ChildDemoViewController alloc] init];
    wordVc1.title = @"小码哥";
    //[self addChildViewController:wordVc1];
    
    // 段子
    ChildDemoViewController *wordVc2 = [[ChildDemoViewController alloc] init];
    wordVc2.title = @"M了个J";
    //[self addChildViewController:wordVc2];
    
    // 段子
    ChildDemoViewController *wordVc3 = [[ChildDemoViewController alloc] init];
    wordVc3.title = @"啊峥";
    //[self addChildViewController:wordVc3];
    
    self.pageControllers = @[wordVc1, wordVc2, wordVc3];
    //self.selectedIndex = 0;
//    
//    ChildDemoViewController *wordVc4 = [[ChildDemoViewController alloc] init];
//    wordVc4.title = @"吖了个峥";
//    [self addChildViewController:wordVc4];
//    
//    // 全部
//    ChildDemoViewController *allVc = [[ChildDemoViewController alloc] init];
//    allVc.title = @"全部";
//    [self addChildViewController:allVc];
//    
//    // 视频
//    ChildDemoViewController *videoVc = [[ChildDemoViewController alloc] init];
//    videoVc.title = @"视频";
//    [self addChildViewController:videoVc];
//    
//    // 声音
//    ChildDemoViewController *voiceVc = [[ChildDemoViewController alloc] init];
//    voiceVc.title = @"声音";
//    [self addChildViewController:voiceVc];
//    
//    // 图片
//    ChildDemoViewController *pictureVc = [[ChildDemoViewController alloc] init];
//    pictureVc.title = @"图片";
//    [self addChildViewController:pictureVc];
//    
//    // 段子
//    ChildDemoViewController *wordVc = [[ChildDemoViewController alloc] init];
//    wordVc.title = @"段子";
//    [self addChildViewController:wordVc];
}


@end

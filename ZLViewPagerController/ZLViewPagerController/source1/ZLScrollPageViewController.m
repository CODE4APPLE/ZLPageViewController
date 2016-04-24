//
//  ZLScrollPageViewController.m
//  ZLViewPagerController
//
//  Created by ZhangLe on 16/4/24.
//  Copyright © 2016年 30days-tech. All rights reserved.
//

#import "ZLScrollPageViewController.h"
#import "UIView+Frame.h"

@interface ZLScrollPageViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) UIView *contentView;

@property (weak, nonatomic) UIScrollView *pageScrollView;

@property (assign, nonatomic) NSInteger selIndex;

@property (assign, nonatomic) CGFloat lastOffsetX;

@property (assign, nonatomic) BOOL isAnimating;

@property (assign, nonatomic) BOOL isInitial;

@end

static CGFloat const kNavBarHeight = 64.0;
static NSString *const kPageCollectionViewDidEndScrolling = @"PageCollectionViewDidEndScrolling";

@implementation ZLScrollPageViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _selIndex = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupAllChildViewController {
    NSUInteger count = self.childViewControllers.count;
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.pageScrollView.contentSize = CGSizeMake(screenWidth * count, 0);
    [self addNextPageViewController:_selIndex];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_isInitial) {
        _isInitial = YES;
        
        // 没有子控制器，不需要设置标题
        if (self.childViewControllers.count == 0) return;
        
        [self setupAllChildViewController];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat contentY = self.navigationController ? kNavBarHeight : CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat contentWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat contentHeight = screenHeight - contentY;
    
    if (self.contentView.height == 0) {
        self.contentView.frame = CGRectMake(0, contentY, contentWidth, contentHeight);
    }
    
    self.pageScrollView.frame = CGRectMake(0, 0, contentWidth, contentHeight);
}

#pragma mark - lazy load view

- (UIView *)contentView {
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}

- (UIScrollView *)pageScrollView {
    if (!_pageScrollView) {
        UIScrollView *pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        pageScrollView.delegate = self;
        pageScrollView.bounces = NO;
        pageScrollView.pagingEnabled = YES;
        pageScrollView.backgroundColor = [UIColor whiteColor];
        pageScrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:pageScrollView];
        _pageScrollView = pageScrollView;
    }
    return _pageScrollView;
}

#pragma UIScrollView delegate 

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    NSInteger offsetXInt = offsetX;
    NSInteger screenWInt = screenWidth;
    
    NSInteger extraInt = offsetXInt % screenWInt;
    if (extraInt > screenWidth * 0.5) {
        offsetX = offsetX + (screenWidth - extraInt);
        [self.pageScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        _isAnimating = YES;
    }
    else if (extraInt < screenWidth * 0.5 && extraInt > 0) {
        offsetX = offsetX - extraInt;
        [self.pageScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        _isAnimating = YES;
    }
    
    NSInteger pageIndex = offsetX / screenWidth;
    
    if (_selIndex == pageIndex) return;

    [self addNextPageViewController:pageIndex];
    
//    UIViewController *vc = self.childViewControllers[pageIndex];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kPageCollectionViewDidEndScrolling object:vc];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _isAnimating = NO;
}

- (void)addNextPageViewController:(NSInteger)index {
    _selIndex = index;
    
    [self.pageScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    UIViewController *vc = self.childViewControllers[index];
    vc.view.frame = CGRectMake(index * screenWidth, 0, CGRectGetWidth(self.pageScrollView.frame), CGRectGetHeight(self.pageScrollView.frame));
    [self.pageScrollView addSubview:vc.view];
}

- (void)removeLastPageViewController:(NSInteger)index {
    UIViewController *vc = self.childViewControllers[_selIndex];
    [vc.view removeFromSuperview];
}

@end

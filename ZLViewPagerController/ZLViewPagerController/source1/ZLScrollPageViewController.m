//
//  ZLScrollPageViewController.m
//  ZLViewPagerController
//
//  Created by ZhangLe on 16/4/24.
//  Copyright © 2016年 30days-tech. All rights reserved.
//

#import "ZLScrollPageViewController.h"
#import "HMSegmentedControl.h"

@interface ZLScrollPageViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UIScrollView *pageScrollView;

@property (strong, nonatomic) HMSegmentedControl *segmentedControl;

@property (assign, nonatomic) NSInteger selIndex;

@property (assign, nonatomic) CGFloat lastOffsetX;

@property (assign, nonatomic) BOOL isAnimating;

@end

static CGFloat const kNavBarHeight = 64.0;

NS_INLINE CGRect frameForControllerAtIndex(NSInteger index, CGRect frame)
{
    return CGRectMake(index * CGRectGetWidth(frame), 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
}

@implementation ZLScrollPageViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    _selIndex = 0;
    _isAnimating = NO;
}

- (void)setPageControllers:(NSArray<__kindof UIViewController *> *)pageControllers {
    _pageControllers = pageControllers;
    
    // setup contentSize
    NSUInteger count = pageControllers.count;
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.pageScrollView.contentSize = CGSizeMake(screenWidth * count, 0);
    self.selectedIndex = 0;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    if (_selectedIndex < _pageControllers.count) {
        UIViewController *viewControlle = _pageControllers[selectedIndex];
        [self removeViewController:viewControlle atIndex:selectedIndex];
        [self addViewController:viewControlle atIndex:selectedIndex];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.pageScrollView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat contentWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    self.segmentedControl.frame = CGRectMake(0, 20, contentWidth, 44);
    
    CGFloat contentY = self.navigationController ? kNavBarHeight : CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    contentY += CGRectGetHeight(self.segmentedControl.frame);
    CGFloat contentHeight = screenHeight - contentY;
    
    if (CGRectGetHeight(self.contentView.frame) == 0) {
        self.contentView.frame = CGRectMake(0, contentY, contentWidth, contentHeight);
    }
    
    self.pageScrollView.frame = CGRectMake(0, 0, contentWidth, contentHeight);
}

#pragma mark - lazy load view

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIScrollView *)pageScrollView {
    if (!_pageScrollView) {
        _pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _pageScrollView.delegate = self;
        _pageScrollView.bounces = NO;
        _pageScrollView.pagingEnabled = YES;
        _pageScrollView.backgroundColor = [UIColor whiteColor];
        _pageScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _pageScrollView;
}

- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"习惯培养", @"每周挑战", @"校内表现"]];
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
        _segmentedControl.selectionIndicatorHeight = 2.0f;
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        [_segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

#pragma mark - HMSegmentedControl action

- (void)segmentedControlAction:(HMSegmentedControl *)sender {
    NSInteger pageIndex = sender.selectedSegmentIndex;
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat offsetX = screenWidth * pageIndex;
    [self.pageScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    UIViewController *viewController = _pageControllers[pageIndex];
    [self removeViewController:viewController atIndex:pageIndex];
    [self addViewController:viewController atIndex:pageIndex];
    
    _selIndex = pageIndex;
}

#pragma mark - UIScrollView delegate

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

    UIViewController *viewController = _pageControllers[pageIndex];
    [self.segmentedControl setSelectedSegmentIndex:pageIndex animated:YES];
    [self removeViewController:viewController atIndex:pageIndex];
    [self addViewController:viewController atIndex:pageIndex];
    
    _selIndex = pageIndex;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _isAnimating = NO;
}

#pragma mark - add child viewController

- (void)addViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    if (!viewController.parentViewController) {
        [self addChildViewController:viewController];
        viewController.view.frame = frameForControllerAtIndex(index, _pageScrollView.frame);
        [_pageScrollView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
    } else {
        viewController.view.frame = frameForControllerAtIndex(index, _pageScrollView.frame);
    }
}

#pragma mark - remove viewController

- (void)removeViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    if (viewController.parentViewController) {
        [self removeViewController:viewController];
    }
}

- (void)removeViewController:(UIViewController *)viewController {
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}

@end


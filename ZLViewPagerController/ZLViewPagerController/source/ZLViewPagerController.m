//
//  ZLViewPagerController.m
//  ZLViewPagerController
//
//  Created by ZhangLe on 16/4/24.
//  Copyright © 2016年 30days-tech. All rights reserved.
//

#import "ZLViewPagerController.h"
#import "ZLViewPagerFlowLayout.h"
#import "UIView+Frame.h"

@interface ZLViewPagerController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UICollectionView *pageCollectionView;

@property (assign, nonatomic) BOOL isInitial;

@property (assign, nonatomic) BOOL isAnimating;

@property (assign, nonatomic) CGFloat lastOffsetX;

@property (assign, nonatomic) NSInteger selectIndex;

@end

static CGFloat const kNavBarHeight = 64.0;
//static CGFloat const kTitleScrollViewHeight = 44.0;
//static CGFloat const kUnderLineHeight = 2.0;
static NSString *const kCellID = @"viewPager";
static NSString *const kPageCollectionViewDidEndScrolling = @"PageCollectionViewDidEndScrolling";

@implementation ZLViewPagerController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)awakeFromNib {
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setSelectedPageIndex:(NSInteger)selectedPageIndex {
    if (_selectedPageIndex != selectedPageIndex) {
        _selectedPageIndex = selectedPageIndex;
        
        CGFloat offsetX = selectedPageIndex * CGRectGetWidth([UIScreen mainScreen].bounds);
        [self.pageCollectionView setContentOffset:CGPointMake(offsetX, 0)];
        _selectIndex = selectedPageIndex;
    }
}

#pragma mark - lazy load View

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

- (UICollectionView *)pageCollectionView {
    if (!_pageCollectionView) {
        ZLViewPagerFlowLayout *flowLayout = [[ZLViewPagerFlowLayout alloc] init];
        _pageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _pageCollectionView.dataSource = self;
        _pageCollectionView.delegate = self;
        _pageCollectionView.bounces = NO;
        _pageCollectionView.pagingEnabled = YES;
        _pageCollectionView.showsHorizontalScrollIndicator = NO;
        _pageCollectionView.backgroundColor = [UIColor whiteColor];
        [self.contentView insertSubview:_pageCollectionView atIndex:0];
    }
    return _pageCollectionView;
}

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.pageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellID];
    
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
    
    self.pageCollectionView.frame = CGRectMake(0, 0, contentWidth, contentHeight);
}

- (void)setupAllChildViewController {
    NSUInteger count = self.childViewControllers.count;
    
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    _pageCollectionView.contentSize = CGSizeMake(screenWidth * count, 0);
}

#pragma mark - UICollectionView flowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.childViewControllers count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIViewController *vc = self.childViewControllers[indexPath.item];
    
    vc.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.pageCollectionView.frame), CGRectGetHeight(self.pageCollectionView.frame));
    
    [cell.contentView addSubview:vc.view];
    
    return cell;
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
        [self.pageCollectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        _isAnimating = YES;
    }
    else if (extraInt < screenWidth * 0.5 && extraInt > 0) {
        offsetX = offsetX - extraInt;
        [self.pageCollectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        _isAnimating = YES;
    }
    
    NSInteger pageIndex = offsetX / screenWidth;
    
    if (_selectIndex == pageIndex) return;
    
    _selectIndex = pageIndex;
    
    UIViewController *vc = self.childViewControllers[pageIndex];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPageCollectionViewDidEndScrolling object:vc];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _isAnimating = NO;
}

@end

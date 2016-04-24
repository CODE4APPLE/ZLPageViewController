//
//  ZLViewPagerFlowLayout.m
//  ZLViewPagerController
//
//  Created by ZhangLe on 16/4/24.
//  Copyright © 2016年 30days-tech. All rights reserved.
//

#import "ZLViewPagerFlowLayout.h"

@implementation ZLViewPagerFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if (CGRectGetHeight(self.collectionView.bounds)) {
        self.itemSize = self.collectionView.bounds.size;
    }
}

@end

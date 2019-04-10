//
//  JTTutuGifView.m
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/4/6.
//  Copyright © 2019年 wangjintao. All rights reserved.
//

#import "JTTutuGifView.h"
#import "JTEmojiModel.h"
#import "JTTutuGifCell.h"

@interface JTTutuGifView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,weak)UICollectionView *collectionView;
@property (nonatomic,weak)UIPageControl *pageControl;

@end
@implementation JTTutuGifView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat leftMargin = 8;
    CGFloat topMargin = 10;
    CGFloat bottomMargin = 20;
    CGFloat itemWidth = (self.width - 2 * leftMargin) / 4.0;
    CGFloat itemHeight = (self.height - topMargin - bottomMargin) / 2.0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.sectionInset = UIEdgeInsetsMake(10, 8, 20, 8);
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collection.pagingEnabled = YES;
    collection.backgroundColor = [UIColor jt_colorWithHexString:@"F6F6F8"];
    collection.dataSource = self;
    collection.delegate = self;
    collection.showsHorizontalScrollIndicator = NO;
    
    [collection registerClass:[JTTutuGifCell class] forCellWithReuseIdentifier:@"asdfasfdas"];
    collection.delegate = self;
    [self addSubview:collection];
    self.collectionView = collection;
    [collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(178);
    }];
    
    UIPageControl *page = [[UIPageControl alloc] init];
    [self addSubview:page];
    page.numberOfPages = 2;
    page.currentPage = 0;
    page.hidesForSinglePage = YES;
    page.pageIndicatorTintColor = [UIColor lightGrayColor];
    page.currentPageIndicatorTintColor = [UIColor grayColor];
    self.pageControl = page;
    [page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
}
- (void)setModelArr:(NSArray<JTEmojiModel *> *)modelArr{
    _modelArr = modelArr;
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _modelArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JTTutuGifCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"asdfasfdas" forIndexPath:indexPath];
    JTEmojiModel *model = self.modelArr[indexPath.row];
    cell.model = model;
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = index;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 发通知
    JTEmojiModel *model = self.modelArr[indexPath.row];
    if (model.type == JTEmojiTypeBlankSpace) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:JTTutuGifKeyboardActionNotification object:model];
}



@end

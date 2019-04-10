//
//  JTEmojiView.m
//  EHuaTuFramework
//
//  Created by wangjintao on 2019/4/3.
//  Copyright © 2019年 ZhiYun. All rights reserved.
//

#import "JTEmojiView.h"
#import "JTEmojiModel.h"
#import "JTEmojiPageCell.h"

@interface JTEmojiView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,weak)UICollectionView *collectionView;
@property (nonatomic,weak)UIPageControl *pageControl;
@property (nonatomic,strong)NSArray *dataArray;

@end
@implementation JTEmojiView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(self.width, 178);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collection.pagingEnabled = YES;
    collection.backgroundColor = [UIColor jt_colorWithHexString:@"F6F6F8"];
    collection.dataSource = self;
    collection.showsHorizontalScrollIndicator = NO;
    
    [collection registerClass:[JTEmojiPageCell class] forCellWithReuseIdentifier:@"asdfasfdas"];
    collection.delegate = self;
    [self addSubview:collection];
    self.collectionView = collection;
    [collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(178);
    }];
    
    UIPageControl *page = [[UIPageControl alloc] init];
    [self addSubview:page];
    page.numberOfPages = 3;
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
- (void)prapareData{
    NSMutableArray *array = [NSMutableArray array];
    NSInteger pageCount = (self.emojiModelArr.lastObject.page + 1);
    for (int i = 0; i < pageCount; i++) {
        NSArray <JTEmojiModel *> *subArr = [self.emojiModelArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"page = %d",i]]];
        [array addObject:subArr];
    }
    self.dataArray = array;
}

- (void)setEmojiModelArr:(NSArray<JTEmojiModel *> *)emojiModelArr{
    _emojiModelArr = emojiModelArr;
    if (emojiModelArr.count == 0) {
        return;
    }
    [self prapareData];
    self.pageControl.numberOfPages = self.dataArray.count;
    self.pageControl.currentPage = 0;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JTEmojiPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"asdfasfdas" forIndexPath:indexPath];
    cell.modelArr = self.dataArray[indexPath.row];
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = index;
}
@end

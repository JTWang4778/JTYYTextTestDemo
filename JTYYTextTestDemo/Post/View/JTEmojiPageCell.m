//
//  JTEmojiPageCell.m
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/4/5.
//  Copyright © 2019年 wangjintao. All rights reserved.
//

#import "JTEmojiPageCell.h"
#import "JTEmojiCell.h"
#import "JTEmojiModel.h"

@interface JTEmojiPageCell()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,weak)UICollectionView *collectionView;

@end
@implementation JTEmojiPageCell
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
    CGFloat itemWidth = (self.width - 2 * leftMargin) / 9.0;
    CGFloat itemHeight = (self.height - topMargin - bottomMargin) / 3.0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.sectionInset = UIEdgeInsetsMake(10, 8, 20, 8);
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collection.pagingEnabled = NO;
    collection.backgroundColor = [UIColor jt_colorWithHexString:@"F6F6F8"];
    collection.dataSource = self;
    
    [collection registerClass:[JTEmojiCell class] forCellWithReuseIdentifier:@"asdfasfdas"];
        collection.delegate = self;
    [self addSubview:collection];
    self.collectionView = collection;
    [collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
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
    JTEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"asdfasfdas" forIndexPath:indexPath];
    if (self.modelArr.count > indexPath.row) {
        JTEmojiModel *model = self.modelArr[indexPath.row];
        cell.model = model;
    }else{
        cell.model = nil;
    }
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 发通知
    JTEmojiModel *model = self.modelArr[indexPath.row];
    if (model.type == JTEmojiTypeBlankSpace) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:JTEmojiKeyboardActionNotification object:model];
}
@end

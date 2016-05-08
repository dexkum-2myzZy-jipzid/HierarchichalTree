//
//  CLCustomLayout.m
//  HierarchichalTree
//
//  Created by ChanLiang on 5/8/16.
//  Copyright © 2016 JackChan. All rights reserved.
//

#import "CLCustomLayout.h"
#import "CLCollectionViewLayoutAttributes.h"

@interface CLCustomLayout ()

@property (nonatomic,strong) NSDictionary *layoutInfoDict;
@property (nonatomic,assign) NSInteger maxNumRows;
@property (nonatomic,assign) UIEdgeInsets inset;
@property (nonatomic,assign) CGSize itemSize;

@end

@implementation CLCustomLayout


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.inset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}


-(void)prepareLayout{
    
    self.itemSize = CGSizeMake((self.collectionView.frame.size.width - 80)/3, 80);
    
    NSMutableDictionary *layoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellInfo =[NSMutableDictionary dictionary];
    NSIndexPath *indexPath;
    NSInteger sectionNum = [self.collectionView numberOfSections];
    for (NSInteger i = 0; i < sectionNum; i++) {
        NSInteger itemNum = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < itemNum; j++) {
            indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            CLCollectionViewLayoutAttributes *attribute = [self attributesWithChildrenAtIndexPath:indexPath];
            [cellInfo setObject:attribute forKey:indexPath];
        }
    }
    
    for (NSInteger section = 2; section >= 0; section--) {
        NSInteger numItem = [self.collectionView numberOfItemsInSection:section];
        NSInteger childHeight = 0;
        for (NSInteger item = 0; item < numItem; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            CLCollectionViewLayoutAttributes *attribute = [cellInfo objectForKey:indexPath];
            attribute.frame = [self frameForCellAtIndexPath:indexPath withChildHeight:childHeight];
            childHeight = [self adjustFramesOfChildrenAndConnectorsForClassAtIndexPath:indexPath withDict:cellInfo andChildHeight:childHeight];
            cellInfo[indexPath] = attribute;
        }
    }
    [layoutInfo setObject:cellInfo forKey:@"cellInfo"];
    
    NSMutableDictionary *supplementaryInforDict = [self setupSupplementaryInfoDictionaryWithCellInfo:cellInfo];
    [layoutInfo setObject:supplementaryInforDict forKey:@"suppInfo"];
    
    self.layoutInfoDict = layoutInfo;
}




- (CGSize)collectionViewContentSize{
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), 20 + 8*(20 + _itemSize.height));
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *attributesArray = [NSMutableArray array];
    NSDictionary *cellInfo = _layoutInfoDict[@"cellInfo"];
    for (NSIndexPath *key in cellInfo) {
        CLCollectionViewLayoutAttributes *attributes = cellInfo[key];
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [attributesArray addObject:attributes];
        }
    }
    
    NSDictionary *suppInfo = _layoutInfoDict[@"suppInfo"];
    for (NSIndexPath *key in suppInfo) {
        UICollectionViewLayoutAttributes *supplementaryAttributes = suppInfo[key];
        if (CGRectIntersectsRect(rect, supplementaryAttributes.frame)) {
            [attributesArray addObject:supplementaryAttributes];
        }
    }
    return [attributesArray copy];
}

#pragma mark -

- (CLCollectionViewLayoutAttributes*)attributesWithChildrenAtIndexPath:(NSIndexPath*)indexPath{
    
    CLCollectionViewLayoutAttributes *attributes = [CLCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    if ([indexPath isEqual:[NSIndexPath indexPathForItem:0 inSection:0]]) {
        NSMutableArray *children = [[NSMutableArray alloc]init];
        for (NSInteger item = 0; item < 7; item++ ) {
            NSIndexPath *childIndexPath = [NSIndexPath indexPathForItem:item inSection:1];
            [children addObject:childIndexPath];
        }
        attributes.children = [children copy];
    }else if ([indexPath isEqual:[NSIndexPath indexPathForItem:2 inSection:1]]){
        NSMutableArray *children = [[NSMutableArray alloc]init];
        for (NSInteger item = 0; item < 1; item++ ) {
            NSIndexPath *childIndexPath = [NSIndexPath indexPathForItem:item inSection:2];
            [children addObject:childIndexPath];
        }
        attributes.children = [children copy];
    }else if ([indexPath isEqual:[NSIndexPath indexPathForItem:4 inSection:1]]){
        NSMutableArray *children = [[NSMutableArray alloc]init];
        for (NSInteger item = 1; item < 3; item++ ) {
            NSIndexPath *childIndexPath = [NSIndexPath indexPathForItem:item inSection:2];
            [children addObject:childIndexPath];
        }
        attributes.children = [children copy];
    }
    
    return attributes;
}

-(CGRect)frameForCellAtIndexPath:(NSIndexPath*)indexPath withChildHeight:(NSInteger)childHeight{
    CGFloat x = 20 + (_itemSize.width + 20) * indexPath.section;
    CGFloat y = 20 + (_itemSize.height + 20) * (indexPath.item + childHeight);
    CGRect rect = CGRectMake(x, y, _itemSize.width, _itemSize.height);
    return rect;
}

- (NSInteger)adjustFramesOfChildrenAndConnectorsForClassAtIndexPath:(NSIndexPath*)indexPath withDict:(NSMutableDictionary *)cellInfo andChildHeight:(NSInteger)childHeight{
    CLCollectionViewLayoutAttributes *fatherAttributes = cellInfo[indexPath];
    NSArray *children = fatherAttributes.children;
    if (children) {
        for (NSInteger i = 0; i < children.count; i++) {
            NSIndexPath *childIndexPath = children[i];
            CLCollectionViewLayoutAttributes *childAttributes = cellInfo[childIndexPath];
            CGFloat y = fatherAttributes.frame.origin.y + (20 + _itemSize.height)*i;
            if (y < childAttributes.frame.origin.y) {
                y = childAttributes.frame.origin.y;
            }
            childAttributes.frame = CGRectMake(childAttributes.frame.origin.x, y,_itemSize.width,_itemSize.height);
            cellInfo[childIndexPath] = childAttributes;
            if (i > 0) {
                childHeight++;
            }
        }
    }
    return childHeight;
}

- (NSMutableDictionary*)setupSupplementaryInfoDictionaryWithCellInfo:(NSDictionary*)cellInfo{
    //supplementary
    NSMutableDictionary *supplementaryInfo = [NSMutableDictionary dictionary];
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
        for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *supplementaryAttributes =
            [UICollectionViewLayoutAttributes
             layoutAttributesForSupplementaryViewOfKind:@"ConnectionViewKind" withIndexPath:indexPath];
            CLCollectionViewLayoutAttributes *cellAttributes = cellInfo[indexPath];
            CGFloat x = cellAttributes.frame.origin.x - 20;
            CGFloat y = cellAttributes.frame.origin.y;
            CGFloat height = 100;
            if (cellAttributes.children) {
                for (NSInteger child = 0; child < cellAttributes.children.count; child++) {
                    height = child * 100 + 100;
                }
            }
            supplementaryAttributes.frame = CGRectMake(x, y, 20, height);
            [supplementaryInfo setObject: supplementaryAttributes forKey:indexPath];
        }
    }
    return supplementaryInfo;
}

#pragma mark -

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.layoutInfoDict[@"cellInfo"][indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    return self.layoutInfoDict[@"suppInfo"][indexPath];
}



@end

//
//  CLCollectionViewController.m
//  HierarchichalTree
//
//  Created by ChanLiang on 5/8/16.
//  Copyright © 2016 JackChan. All rights reserved.
//

#import "CLCollectionViewController.h"
#import "CLCollectionViewCell.h"
#import "CLCustomLayout.h"
#import "CLHCollectionReusableView.h"

@interface CLCollectionViewController ()

@property (nonatomic,strong) NSArray *sectionArray;

@end

@implementation CLCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[CLCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[CLHCollectionReusableView class] forSupplementaryViewOfKind:@"ConnectionViewKind" withReuseIdentifier:@"resuseSupplementary"];
    
    // Do any additional setup after loading the view.
    self.collectionView.collectionViewLayout = [[CLCustomLayout alloc]init];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    NSArray *firstSectionArray  = @[@"NSObject"];
    NSArray *secondSectionArray = @[@"NSLayoutContraint",@"NSLayoutManager",@"NSParagraphStyle",@"UIAcceleration",@"UIBarItem",@"UIActivity",@"UIBezierPath"];
    NSArray *thirdSectionArray  = @[@"NSMutableParagraphStyle",@"UIBarButtonItem",@"UITabBarItem"];
    self.sectionArray           = @[firstSectionArray,secondSectionArray,thirdSectionArray];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return _sectionArray.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_sectionArray[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CLCollectionViewCell *cell = (CLCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.label.text = _sectionArray[indexPath.section][indexPath.item];
    cell.backgroundColor = [UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CLHCollectionReusableView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:@"ConnectionViewKind" withReuseIdentifier:@"resuseSupplementary" forIndexPath:indexPath];
    
    if ([indexPath isEqual:[NSIndexPath indexPathForItem:0 inSection:1]]  || [indexPath isEqual:[NSIndexPath indexPathForItem:1 inSection:2]]) {
        supplementaryView.imageView.image = [UIImage imageNamed:@"firstChildNotSingle"];
    }else if ([indexPath isEqual:[NSIndexPath indexPathForItem:0 inSection:2]]){
        supplementaryView.imageView.image = [UIImage imageNamed:@"singleChild"];
    }else if ([indexPath isEqual:[NSIndexPath indexPathForItem:2 inSection:2]]  || [indexPath isEqual:[NSIndexPath indexPathForItem:6 inSection:1]]) {
        supplementaryView.imageView.image = [UIImage imageNamed:@"lastChild"];
    }else if ([indexPath isEqual:[NSIndexPath indexPathForItem:0 inSection:0]]){
        supplementaryView.imageView.image = nil;
    }else if([indexPath isEqual:[NSIndexPath indexPathForItem:4 inSection:1]]){
        supplementaryView.imageView.image = [UIImage imageNamed:@"childSP"];
    }else{
        supplementaryView.imageView.image = [UIImage imageNamed:@"child"];
    }
    
    return supplementaryView;
}

@end

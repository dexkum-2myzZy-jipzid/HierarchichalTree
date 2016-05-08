//
//  CLCollectionViewCell.m
//  HierarchichalTree
//
//  Created by ChanLiang on 5/8/16.
//  Copyright © 2016 JackChan. All rights reserved.
//

#import "CLCollectionViewCell.h"

@implementation CLCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLabel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupLabel];
    }
    return self;
}


- (void)setupLabel{
    self.label = [[UILabel alloc]initWithFrame:self.contentView.bounds];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont systemFontOfSize:14];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.label];
}

@end

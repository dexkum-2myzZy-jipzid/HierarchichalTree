//
//  CLHCollectionReusableView.m
//  HierarchichalTree
//
//  Created by ChanLiang on 5/8/16.
//  Copyright © 2016 JackChan. All rights reserved.
//

#import "CLHCollectionReusableView.h"

@implementation CLHCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.imageView];
    }
    return self;
}

@end

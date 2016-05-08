//
//  CLCollectionViewLayoutAttributes.m
//  HierarchichalTree
//
//  Created by ChanLiang on 5/8/16.
//  Copyright © 2016 JackChan. All rights reserved.
//

#import "CLCollectionViewLayoutAttributes.h"

@implementation CLCollectionViewLayoutAttributes


- (BOOL)isEqual:(id)object{
    CLCollectionViewLayoutAttributes *otherAttributes = (CLCollectionViewLayoutAttributes*)object;
    if ([self.children isEqualToArray:otherAttributes.children]) {
        return [super isEqual:object];
    }
    return NO;
}

@end

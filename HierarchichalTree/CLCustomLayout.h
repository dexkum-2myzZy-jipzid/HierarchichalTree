//
//  CLCustomLayout.h
//  HierarchichalTree
//
//  Created by ChanLiang on 5/8/16.
//  Copyright © 2016 JackChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLCustomProtocal <NSObject>

@end

@interface CLCustomLayout : UICollectionViewLayout

@property (nonatomic,weak) id<CLCustomProtocal>CLCustomDataSource;

@end

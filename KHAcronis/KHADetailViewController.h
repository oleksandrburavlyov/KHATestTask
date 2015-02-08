//
//  KHADetailViewController.h
//  KHAcronis
//
//  Created by zgushonka on 2/7/15.
//  Copyright (c) 2015 zgushonka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
#import "KHANetworking.h"
#import "KHAIcon.h"

@interface KHADetailViewController : UIViewController <KHANetworkingDelegate>

- (void)updateDetailImageView;

@property (nonatomic, strong) KHAIcon *iconItem;
@end

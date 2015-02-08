//
//  KHAIconsTableViewController.h
//  KHAcronis
//
//  Created by zgushonka on 2/7/15.
//  Copyright (c) 2015 zgushonka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KHANetworking.h"


@interface KHAMasterTableViewController : UITableViewController <KHANetworkingDelegate>

- (IBAction)reloadPressed:(id)sender;

@end

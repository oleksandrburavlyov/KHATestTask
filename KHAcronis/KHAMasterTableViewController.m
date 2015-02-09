//
//  KHAIconsTableViewController.m
//  KHAcronis
//
//  Created by zgushonka on 2/7/15.
//  Copyright (c) 2015 zgushonka. All rights reserved.
//

#import "KHAMasterTableViewController.h"
#import "AppConstants.h"
#import "KHAIcon.h"
#import "KHADetailViewController.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

static NSString * const cellIdentifier = @"IconCellIdentifier";


@interface KHAMasterTableViewController ()

@property (nonatomic, strong) KHANetworking *network;
@property (nonatomic, strong) NSMutableArray *iconItems;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *reloadButton;
@end


@implementation KHAMasterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Master";
    
    //  create networking object
    self.network = [[KHANetworking alloc] initWithDelegate:self];

    //  get iconsJSON file list
    [self fetchFileList];
}

- (void)fetchFileList {
    NSString *urlString = [self URLStringForFileName:BaseJsonName];
    [self.network getJSONWithURLString:urlString];
}

- (IBAction)reloadPressed:(UIBarButtonItem *)sender {
    sender.enabled = NO;
    
    //  clear Master
    self.iconItems = nil;
    [self.tableView reloadData];
    
    //  clear Detail if iPad
    [self cleariPadDetailVC];
    
    [self fetchFileList];
}

- (void)cleariPadDetailVC {
    if (IS_IPAD) {
        UIViewController *vc = [[[self splitViewController] childViewControllers] lastObject];
        [self updateDetailView:vc withIconItem:nil];
    }
}



#pragma mark - KHANetworkingDelegate
- (void)networkRequestDidReceiveJsonAnswer:(NSDictionary *)parsedJson {
    [self.iconItems removeAllObjects];
    for (NSDictionary *dictionary in parsedJson) {
        KHAIcon *iconItem = [[KHAIcon alloc] initFromDictionary:dictionary];
        [self.iconItems addObject:iconItem];
    }
    [self sortIconsArray];
    [self.tableView reloadData];
    self.reloadButton.enabled = YES;
}

- (void)networkRequestDidReceiveImage:(UIImage *)image forUrl:(NSURL *)url {
    NSString *imageName = [url lastPathComponent];
    for (KHAIcon *iconItem in self.iconItems) {
        if ([iconItem.thumbnailName isEqualToString:imageName]) {
            iconItem.thumbnail = image;
        }
    }
    [self.tableView reloadData];
}

- (void)networkRequestDidFinishWithError:(NSError *)error {
    self.reloadButton.enabled = YES;
    NSLog(@"Error at %@ - %@ : %@", [self class], NSStringFromSelector(_cmd), [error localizedDescription]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE_NETWORK_ERROR
                                                    message:ALERT_MESSAGE_NETWORK_ERROR
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = self.iconItems ? [self.iconItems count] : 0;
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    KHAIcon *iconItem = self.iconItems[indexPath.row];
    cell.textLabel.text = iconItem.name;
    cell.detailTextLabel.text = iconItem.descr;
    cell.imageView.image = iconItem.thumbnail;
    
    //  if NO image then place default image and fetch thumbnail for the iconItem
    if (!cell.imageView.image) {
        cell.imageView.image = [UIImage imageNamed:@"file.png"];
        
        NSString *urlString = [self URLStringForFileName:iconItem.thumbnailName];
        [self.network getImageWithURLString:urlString];
        
        
    }
    return cell;
}



#pragma mark - utils
- (NSString *)URLStringForFileName:(NSString *)fileName {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BaseURLString, fileName];
    return urlString;
}

- (NSMutableArray *)iconItems {
    if (!_iconItems) {
        _iconItems = [NSMutableArray array];
    }
    return _iconItems;
}

- (void)sortIconsArray {
    [self.iconItems sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        KHAIcon *icon1 = (KHAIcon *)obj1;
        KHAIcon *icon2 = (KHAIcon *)obj2;
        return [icon1.name compare:icon2.name];
    }];
}


- (KHAIcon *)iconItemForSelectedRow {
    NSInteger rowSelected = [self.tableView indexPathForSelectedRow].row;
    KHAIcon *iconItem = self.iconItems[rowSelected];
    return iconItem;
}



#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destVC = [segue destinationViewController];
    [self updateDetailView:destVC withIconItem:[self iconItemForSelectedRow]];
    
    if (IS_IPAD) {
        destVC.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        destVC.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

- (void)updateDetailView:(UIViewController *)controller withIconItem:(KHAIcon *)iconItem {
    if ([controller isKindOfClass:[KHADetailViewController class]]) {
        KHADetailViewController *detailVC = (KHADetailViewController *) controller;
        detailVC.iconItem = iconItem;
    }
}


@end

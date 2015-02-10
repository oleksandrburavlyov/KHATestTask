//
//  KHADetailViewController.m
//  KHAcronis
//
//  Created by zgushonka on 2/7/15.
//  Copyright (c) 2015 zgushonka. All rights reserved.
//

#import "KHADetailViewController.h"
#import "AppConstants.h"


@interface KHADetailViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIncicator;
@end


@implementation KHADetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self configureView];
}
//  */

- (void)setIconItem:(KHAIcon *)newIconItem {
    if (_iconItem != newIconItem) {
        _iconItem = newIconItem;
    }
    
    // Clear view
    if (!newIconItem) {
        [self configureView];
    }
}

- (void)configureView {
    self.imageView.image = self.iconItem.image;
    [self.activityIncicator stopAnimating];
    if (self.iconItem) {
        self.title = [NSString stringWithFormat:@"Detail: %@", self.iconItem.name];
        self.imageView.backgroundColor = [UIColor clearColor];
        
        if (!self.iconItem.image) {
            [self fetchImage];
        }
    }
    else {
        self.title = @"Detail";
        self.imageView.backgroundColor = [UIColor lightGrayColor];
    }
}


#pragma mark - Networking
- (void)fetchImage {
    [self.activityIncicator startAnimating];
    
    __weak KHADetailViewController *weakSelf = self;
    __block KHAIcon *iconItem = self.iconItem;
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BaseURLString, self.iconItem.imageName];
    [[KHANetworking sharedInstance] getImageWithURLString:urlString withCallback:^(UIImage *image, NSError *error) {
        [self.activityIncicator stopAnimating];
        if (!error) {
            iconItem.image = image;
            weakSelf.imageView.image = image;
        }
        else {
            [weakSelf networkRequestDidFinishWithError:error];
        }
    }];
}

- (void)networkRequestDidFinishWithError:(NSError *)error {
    [self.activityIncicator stopAnimating];
    self.imageView.image = [UIImage imageNamed:@"file.png"];
    
    NSLog(@"Error at %@ - %@ : %@", [self class], NSStringFromSelector(_cmd), [error localizedDescription]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE_NETWORK_ERROR
                                                    message:ALERT_MESSAGE_NETWORK_ERROR
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

@end

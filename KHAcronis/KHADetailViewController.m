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
@property (nonatomic, strong) KHANetworking *network;
@end


@implementation KHADetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.network = [[KHANetworking alloc] initWithDelegate:self];    
    [self updateDetailImageView];
}

- (void)updateDetailImageView {
    self.imageView.image = self.iconItem.image;
    [self.activityIncicator stopAnimating];
    if (self.iconItem) {
        self.title = [NSString stringWithFormat:@"Detail: %@", self.iconItem.name];
        self.imageView.backgroundColor = [UIColor clearColor];
        
        if (!self.imageView.image) {
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
    
    KHANetworking *networking = [[KHANetworking alloc] initWithDelegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BaseURLString, self.iconItem.imageName];
    [networking getImageWithURLString:urlString];
}

- (void)networkRequestDidReceiveImage:(UIImage *)image forUrl:(NSURL *)url {
    [self.activityIncicator stopAnimating];
    NSString *imageName = [url lastPathComponent];
    if ([imageName isEqualToString:self.iconItem.imageName]) {
        self.iconItem.image = image;
        self.imageView.image = image;
    }
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

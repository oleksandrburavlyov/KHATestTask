
//
//  KHANetworking.m
//  KHAcronis
//
//  Created by zgushonka on 2/7/15.
//  Copyright (c) 2015 zgushonka. All rights reserved.
//

#import "KHANetworking.h"
#import <UIKit/UIKit.h>

@interface KHANetworking ()

@property (nonatomic, strong) NSURLSession *session;
@property (atomic) NSInteger taskCount;
@end


@implementation KHANetworking

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration];
        self.taskCount = 0;
    }
    return self;
}

- (void)getJSONWithURLString:(NSString *)jsonURLString withCallback:(void (^)(NSDictionary *dictionary, NSError *error))callbackBlock;{
    [self startNetworkIndicator];
    
    __weak KHANetworking *weakSelf = self;
    NSURL *url = [NSURL URLWithString:jsonURLString];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError = nil;
        NSDictionary *jsonDictionary = nil;
        if (!error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode == 200) {
                jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf stopNetworkIndicator];
            if (callbackBlock) {
                NSError *returnError = error ?: jsonError;
                callbackBlock(jsonDictionary, returnError);
            }
        });
    }];
    [dataTask resume];
}

- (void)getImageWithURLString:(NSString *)imageURL withCallback:(void (^)(UIImage *image, NSError *error))callbackBlock {
    [self startNetworkIndicator];
    
    __weak KHANetworking *weakSelf = self;
    NSURL *url = [NSURL URLWithString:imageURL];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf stopNetworkIndicator];
            if (callbackBlock) {
                callbackBlock([UIImage imageWithData:data],error);
            }
        });
    }];
    [dataTask resume];
}

- (void)startNetworkIndicator {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.taskCount++;
}

- (void)stopNetworkIndicator {
    self.taskCount--;
    if (self.taskCount == 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

@end

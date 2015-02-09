
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
@end


@implementation KHANetworking

- (instancetype)initWithDelegate:(id<KHANetworkingDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return _session;
}

- (void)getJSONWithURLString:(NSString *)jsonURLString withCallback:(void (^)(NSDictionary *dictionary, NSError *error))callbackBlock;{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    id <KHANetworkingDelegate> delegate = self.delegate;
    NSURL *url = [NSURL URLWithString:jsonURLString];
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithURL:url
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (!error) {
                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                        if (httpResponse.statusCode == 200) {
                            NSError *jsonError;
                            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                           options:NSJSONReadingAllowFragments
                                                                                             error:&jsonError];
                            if (!jsonError) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                    [delegate networkRequestDidReceiveJsonAnswer:jsonDictionary];
                                });
                            }
                            else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                    [delegate networkRequestDidFinishWithError:jsonError];
                                });
                            }
                        }
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                            [delegate networkRequestDidFinishWithError:error];
                        });
                    }
                }];
    [dataTask resume];
}

- (void)getImageWithURLString:(NSString *)imageURL withCallback:(void (^)(UIImage *image, NSError *error))callbackBlock {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    id <KHANetworkingDelegate> delegate = self.delegate;
    NSURL *url = [NSURL URLWithString:imageURL];
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithURL:url
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                    if (!error) {
//                        UIImage *image = [UIImage imageWithData:data];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//                            [delegate networkRequestDidReceiveImage:image forUrl:url];
//                        });
//                    }
//                    else {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//                            [delegate networkRequestDidFinishWithError:error];
//                        });
//                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (callbackBlock) {
                            callbackBlock([UIImage imageWithData:data],error);
                        }
                    });
                }];
    [dataTask resume];
}

@end

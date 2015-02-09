//
//  KHANetworking.h
//  KHAcronis
//
//  Created by zgushonka on 2/7/15.
//  Copyright (c) 2015 zgushonka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol KHANetworkingDelegate;


@interface KHANetworking : NSObject
- (instancetype)initWithDelegate:(id <KHANetworkingDelegate>)delegate;

- (void)getJSONWithURLString:(NSString *)jsonURL withCallback:(void (^)(NSDictionary *dictionary, NSError *error))callbackBlock;
- (void)getImageWithURLString:(NSString *)imageURL withCallback:(void (^)(UIImage *image, NSError *error))callbackBlock;

@property (nonatomic, weak) id <KHANetworkingDelegate> delegate;
@end


@protocol KHANetworkingDelegate <NSObject>
@optional
- (void)networkRequestDidReceiveJsonAnswer:(NSDictionary *)parsedJson;
- (void)networkRequestDidReceiveImage:(UIImage *)image forUrl:(NSURL *)url;

- (void)networkRequestDidFinishWithError:(NSError *)error;
@end

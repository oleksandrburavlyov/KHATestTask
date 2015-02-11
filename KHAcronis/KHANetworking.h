//
//  KHANetworking.h
//  KHAcronis
//
//  Created by zgushonka on 2/7/15.
//  Copyright (c) 2015 zgushonka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface KHANetworking : NSObject

+ (instancetype)sharedInstance;
- (void)getJSONWithURLString:(NSString *)jsonURL withCallback:(void (^)(NSDictionary *dictionary, NSError *error))callbackBlock;
- (void)getImageWithURLString:(NSString *)imageURL withCallback:(void (^)(UIImage *image, NSError *error))callbackBlock;
@end


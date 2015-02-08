//
//  KHAIcon.h
//  KHAcronis
//
//  Created by zgushonka on 2/7/15.
//  Copyright (c) 2015 zgushonka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface KHAIcon : NSObject
- (instancetype)initFromDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *descr;
@property (nonatomic, strong, readonly) NSString *imageName;
@property (nonatomic, strong, readonly) NSString *thumbnailName;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *thumbnail;
@end

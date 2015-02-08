//
//  KHAIcon.m
//  KHAcronis
//
//  Created by zgushonka on 2/7/15.
//  Copyright (c) 2015 zgushonka. All rights reserved.
//

#import "KHAIcon.h"

#define NAME @"name"
#define DESCRIPTION @"description"
#define IMAGE_NAME @"image"
#define THUMBNAIL_NAME @"thumbnail"


@interface KHAIcon ()

@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSString *descr;
@property (nonatomic, strong, readwrite) NSString *imageName;
@property (nonatomic, strong, readwrite) NSString *thumbnailName;
@end


@implementation KHAIcon

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self parseDictionary:dictionary];
        self.image = nil;
        self.thumbnail = nil;
    }
    return self;
}

- (void)parseDictionary:(NSDictionary *)dictionary {
    self.name = [dictionary objectForKey:NAME];
    self.descr = [dictionary objectForKey:DESCRIPTION];
    self.imageName = [dictionary objectForKey:IMAGE_NAME];
    self.thumbnailName = [dictionary objectForKey:THUMBNAIL_NAME];
}

@end

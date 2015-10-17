//
//  Entry.m
//  GoJournal
//
//  Created by Elber Carneiro on 10/11/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "Entry.h"

@implementation Entry

- (instancetype)initWithText:(NSString *)text {
    if (self == [super init]) {
        self.text = text;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    if (self == [super init]) {
        self.image = image;
    }
    return self;
}

- (instancetype)initWithVideoURL:(NSURL *)url {
    if (self == [super init]) {
        self.video = url;
    }
    return self;
}

@end

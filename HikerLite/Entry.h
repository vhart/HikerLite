//
//  Entry.h
//  GoJournal
//
//  Created by Elber Carneiro on 10/11/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface Entry : NSObject

@property (nonatomic) NSString *text;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSURL *video;
@property (nonatomic) NSDate *timestamp;
@property (nonatomic) NSString *longitude;
@property (nonatomic) NSString *latitude;

- (instancetype)initWithText:(NSString *)text;
- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithVideoURL:(NSURL *)url;

@end

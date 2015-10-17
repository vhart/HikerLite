//
//  GJEntry.h
//  GoJournal
//
//  Created by Varindra Hart on 10/13/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "PFUser.h"
#import <Parse/Parse.h>
@interface GJEntry : PFObject <PFSubclassing>

@property (nonatomic) PFFile *file;
@property (nonatomic) NSString *mediaType;
@property (nonatomic) NSString *fileExt;
@property (nonatomic) PFGeoPoint *location;
@property (nonatomic) NSString *textMedia;
@property (nonatomic) NSDate *createdAt;

+ (NSString *) parseClassName;

@end

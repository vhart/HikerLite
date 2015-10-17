//
//  GJEntry.m
//  GoJournal
//
//  Created by Varindra Hart on 10/13/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "GJEntry.h"

@implementation GJEntry

@dynamic file;
@dynamic mediaType;
@dynamic fileExt;
@dynamic location;
@dynamic textMedia;
@dynamic createdAt;

+ (NSString *) parseClassName{
    
    return @"GJEntry";
}

@end

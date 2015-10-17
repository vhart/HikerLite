//
//  GJOutings.m
//  GoJournal
//
//  Created by Varindra Hart on 10/13/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "GJOutings.h"

@implementation GJOutings

@dynamic outingName;
@dynamic createdAt;
@dynamic entriesArray;

+ (NSString *)parseClassName{
    
    return @"GJOutings";
}

- (instancetype)initWithNewEntriesArray{
    
    if (self = [super init]){
        
        self.entriesArray = [NSMutableArray new];
        return self;
        
    }
    
    else
        return nil;
}
@end

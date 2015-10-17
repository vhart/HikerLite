//
//  GJOutings.h
//  GoJournal
//
//  Created by Varindra Hart on 10/13/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "PFUser.h"
#import "GJEntry.h"

@interface GJOutings : PFObject <PFSubclassing>

@property (nonatomic) NSString *outingName;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSMutableArray <GJEntry *> *entriesArray;

+ (NSString *)parseClassName;
- (instancetype)initWithNewEntriesArray;
@end

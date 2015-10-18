//
//  GMSMarker+GJEntryArray.h
//  HikerLite
//
//  Created by Varindra Hart on 10/18/15.
//  Copyright © 2015 Varindra Hart. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "GJOutings.h"

@interface GMSMarker (GJEntryArray)

@property (nonatomic) NSMutableArray <GJEntry *> *entriesArrayForLocation;

@end

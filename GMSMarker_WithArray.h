//
//  GMSMarker_WithArray.h
//  HikerLite
//
//  Created by Varindra Hart on 10/18/15.
//  Copyright © 2015 Varindra Hart. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "GJEntry.h"

@interface GMSMarker_WithArray : GMSMarker
@property (nonatomic) NSMutableArray <GJEntry *> *entriesArrayForLocation;
@end

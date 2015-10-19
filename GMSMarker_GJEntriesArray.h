//
//  GMSMarker_GJEntriesArray.h
//  HikerLite
//
//  Created by Varindra Hart on 10/18/15.
//  Copyright © 2015 Varindra Hart. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import <UIKit/UIKit.h>
#import "GJOutings.h"
#import "GJEntry.h"

@interface GMSMarker ()

@property (nonatomic) NSMutableArray <GJEntry *> *entriesArrayForLocation;

@end

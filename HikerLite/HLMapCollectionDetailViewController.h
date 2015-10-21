//
//  HLMapCollectionDetailViewController.h
//  HikerLite
//
//  Created by Varindra Hart on 10/20/15.
//  Copyright © 2015 Varindra Hart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJOutings.h"
#import "GMSMarker_WithArray.h"
@interface HLMapCollectionDetailViewController : UICollectionViewController

@property (nonatomic) GMSMarker_WithArray *viewedMarker;

@end

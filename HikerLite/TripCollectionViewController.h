//
//  TripCollectionViewController.h
//  GoJournal
//
//  Created by Elber Carneiro on 10/11/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJOutings.h"

@class LiquidFloatingActionButton;

@interface TripCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic) GJOutings *currentOuting;

@end

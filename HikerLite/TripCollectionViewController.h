//
//  TripCollectionViewController.h
//  GoJournal
//
//  Created by Elber Carneiro on 10/11/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiquidFloatingActionButton-Swift.h"
#import "GJOutings.h"

@interface TripCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, LiquidFloatingActionButtonDataSource, LiquidFloatingActionButtonDelegate>

@property (nonatomic) GJOutings *currentOuting;

@end

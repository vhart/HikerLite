//
//  TextEntryViewController.h
//  HikerLite
//
//  Created by Elber Carneiro on 10/18/15.
//  Copyright © 2015 Varindra Hart. All rights reserved.
//

#import "GJOutings.h"
#import <UIKit/UIKit.h>

@interface TextEntryViewController : UIViewController

@property (nonatomic) GJOutings *currentOuting;
@property (nonatomic) CLLocationManager *locationManager;

@end

//
//  OutingCell.h
//  HikerLite
//
//  Created by Elber Carneiro on 10/18/15.
//  Copyright © 2015 Varindra Hart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *previewIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *checkmark;

@end

//
//  OutingCell.m
//  HikerLite
//
//  Created by Elber Carneiro on 10/18/15.
//  Copyright © 2015 Varindra Hart. All rights reserved.
//

#import "OutingCell.h"

@implementation OutingCell

- (void)awakeFromNib {
    self.containerView.layer.cornerRadius = 10;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.checkmark.image = [UIImage imageNamed:@"checkmark"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

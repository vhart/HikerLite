//
//  EntryCell.h
//  GoJournal
//
//  Created by Elber Carneiro on 10/10/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <UIKit/UIKit.h>

@interface EntryCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PFImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIView *descriptionContainer;

@end

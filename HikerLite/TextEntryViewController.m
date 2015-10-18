//
//  TextEntryViewController.m
//  HikerLite
//
//  Created by Elber Carneiro on 10/18/15.
//  Copyright © 2015 Varindra Hart. All rights reserved.
//

#import "TextEntryViewController.h"

@interface TextEntryViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextView *entryTextView;

@end

@implementation TextEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.containerView.layer.cornerRadius = 10;
    [self.entryTextView becomeFirstResponder];
}

- (IBAction)didTapSave:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

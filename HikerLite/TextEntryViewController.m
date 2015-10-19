//
//  TextEntryViewController.m
//  HikerLite
//
//  Created by Elber Carneiro on 10/18/15.
//  Copyright © 2015 Varindra Hart. All rights reserved.
//

#import "TextEntryViewController.h"
#import "GJEntry.h"

@interface TextEntryViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextView *entryTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardOffsetConstraint;

@end

@implementation TextEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.containerView.layer.cornerRadius = 10;
    [self.entryTextView becomeFirstResponder];
    
    [self registerForKeyboardNotifications];
}

// Setting up keyboard notifications.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardWillShowNotification is sent.
- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if (self.keyboardOffsetConstraint.constant == 16) {
        self.keyboardOffsetConstraint.constant += kbSize.height;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    self.keyboardOffsetConstraint.constant = 16;
}

#pragma mark - Button actions

- (IBAction)didTapSave:(UIBarButtonItem *)sender {
    
    GJEntry *newEntry = [GJEntry new];
    newEntry.createdDate = [NSDate date];
    newEntry.mediaType = @"public.text";
    newEntry.textMedia = self.entryTextView.text;
    newEntry.location = [PFGeoPoint geoPointWithLocation:self.locationManager.location];
    
    [self.currentOuting.entriesArray addObject:newEntry];
    [self.currentOuting saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"Text saved");
    }];
    
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapCancel:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

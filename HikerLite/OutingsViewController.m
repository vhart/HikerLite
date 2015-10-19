//
//  OutingsViewController.m
//  HikerLite
//
//  Created by Elber Carneiro on 10/19/15.
//  Copyright © 2015 Varindra Hart. All rights reserved.
//

#import "GJOutings.h"
#import "OutingCell.h"
#import "OutingsViewController.h"

@interface OutingsViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic) NSMutableArray <GJOutings *> *outings;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *createOutingView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *createOutingName;

@end

@implementation OutingsViewController

static NSString * const cellIdentifier = @"outingCellIdentifier";
static NSString * const selectedOuting = @"selectedOuting";

#pragma mark - Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss:)];

    [self setupCells];
    
    [self fetchOutings];
    
    [self setupCreateOutingView];
}

#pragma mark - Setup methods

- (void)setupCells {
    
    UINib *cellNib = [UINib nibWithNibName:@"OutingCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupCreateOutingView {
    self.createOutingView.layer.cornerRadius = 10;
    self.createOutingView.layer.borderColor = [UIColor redColor].CGColor;
    self.createOutingView.layer.borderWidth = 1;
    
    self.createOutingName.delegate = self;
    self.createOutingName.placeholder = @"New outing name";
}

- (void)fetchOutings {
    PFQuery *query = [PFQuery queryWithClassName:@"GJOutings"];
    //[query includeKey:@"entriesArray"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count!=0) {
            
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO];
            [objects sortedArrayUsingDescriptors:@[descriptor]];
            
            self.outings = [NSMutableArray arrayWithArray:objects];
            NSLog(@"self.outings: %@", self.outings);

            [self.tableView reloadData];
        } 
    }];
}

#pragma mark - Button action methods

- (IBAction)didTapSave:(UIButton *)sender {
    
    GJOutings *newOuting = [[GJOutings alloc]initWithNewEntriesArray];
    newOuting.createdDate = [NSDate date];
    newOuting.outingName = self.createOutingName.text;
    [newOuting saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        NSLog(@"Outing created");
        [self.outings addObject:newOuting];
        [self.tableView reloadData];
    
    }];
    
    [self.createOutingName endEditing:YES];
    self.createOutingName.text = @"";
}

- (void)dismiss:(UIBarButtonSystemItem)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.createOutingName.placeholder = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.createOutingName.placeholder = @"New outing name";
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.outings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OutingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.name.text = [self.outings[indexPath.row] outingName];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSUserDefaults standardUserDefaults] setValue:@(indexPath.row) forKey:selectedOuting];
    
    OutingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSLog(@"Changed selected outing to %d", indexPath.row);
    cell.checkmark.hidden = NO;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OutingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSLog(@"Changed selected outing to %d", indexPath.row);
    cell.checkmark.hidden = YES;
}


@end

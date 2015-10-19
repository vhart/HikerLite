//
//  TripCollectionViewController.m
//  GoJournal
//
//  Created by Elber Carneiro on 10/11/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "EntryCell.h"
#import "HLMapView.h"
#import "LiquidFloatingActionButton-Swift.h"
#import "OutingsViewController.h"
#import "TextEntryViewController.h"
#import "TripCollectionViewController.h"

#import <AFNetworking/AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TripCollectionViewController () <CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSMutableArray <LiquidFloatingCell *> *cells;
@property (nonatomic) LiquidFloatingActionButton *floatingActionButton;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@property (nonatomic) NSString *forecast;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic) NSInteger selectedOuting;

@end

@implementation TripCollectionViewController

static NSString * const reuseIdentifier = @"entryCellIdentifier";
static NSString * const selectedOuting = @"selectedOuting";
static NSString * const apiKey = @"53bac750b0228783a50a48bda0d2d1ce";

#pragma mark - Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCollectionView];
    
    [self setupFloatingActionButton];
    
    [self setupLocation];
    
    [self setupLocationManager];
    
    [self setupImagePicker];
    
    [self fetchSelectedOuting];
    
    [self fetchWeatherData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.currentOuting = nil;
    [self fetchOutings];
    
    [self.floatingActionButton close];
}

#pragma mark - Setup methods

- (void)setupCollectionView {
    
    // collection view layout setup
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    NSLog(@"layout: %@", layout);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // collection view setup
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    // register cell prototype
    [self.collectionView registerNib:[UINib nibWithNibName:@"EntryCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // add collection view to view controller
    [self.view addSubview:self.collectionView];
}

- (void)setupFloatingActionButton {
    
    NSInteger buttonRadius = floor(0.135 * self.view.frame.size.width);
    NSLog(@"self.view.frame.size.width: %f", self.view.frame.size.width);
    
    CGRect frame = CGRectMake(self.view.frame.size.width - buttonRadius - 16,
                              self.view.frame.size.height - buttonRadius - 16,
                              buttonRadius,
                              buttonRadius);
    
    self.floatingActionButton = [[LiquidFloatingActionButton alloc] initWithFrame:frame];
    self.floatingActionButton.delegate = self;
    self.floatingActionButton.dataSource = self;
    
    self.cells = [[NSMutableArray alloc] init];
    
    LiquidFloatingCell *cellCamera = [[LiquidFloatingCell alloc] initWithIcon:[UIImage imageNamed:@"cameraIcon"]];
    LiquidFloatingCell *cellText = [[LiquidFloatingCell alloc] initWithIcon:[UIImage imageNamed:@"composeIcon"]];
    LiquidFloatingCell *cellMap = [[LiquidFloatingCell alloc] initWithIcon:[UIImage imageNamed:@"pinIcon"]];
    LiquidFloatingCell *cellOutings = [[LiquidFloatingCell alloc] initWithIcon:[UIImage imageNamed:@"outingsIcon"]];
    
    [self.cells addObject:cellCamera];
    [self.cells addObject:cellText];
    [self.cells addObject:cellMap];
    [self.cells addObject:cellOutings];
    
    [self.view addSubview:self.floatingActionButton];
}

- (void)setupLocation {
    self.latitude = 40.7;
    self.longitude = -74.0;
}

- (void)setupLocationManager {
    
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
    }
    
}

- (void)setupImagePicker{
    
    self.imagePicker = [UIImagePickerController new];
    self.imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeMovie, (NSString *) kUTTypeImage ,nil];
    self.imagePicker.videoMaximumDuration = 5.0f;
    self.imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    
}

#pragma mark - Data fetching

- (void)fetchWeatherData {
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    NSString *stringURL = [NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%f,%f", apiKey,self.longitude, self.latitude];
    NSLog(@"%@", stringURL);
    
    [manager GET:stringURL  parameters: nil success:^(AFHTTPRequestOperation * _Nonnull operation, id _Nonnull responseObject)
     {
         
         NSTimeInterval now = [responseObject[@"currently"][@"time"] doubleValue];
         NSLog(@"now: %f", now);
         
         NSDictionary *hourlyData = responseObject[@"hourly"][@"data"];
         NSLog(@"hourly data: %@", hourlyData);
         
         
         for (NSDictionary *data in hourlyData) {
             NSTimeInterval dataTime = [data[@"time"] doubleValue];
             if (dataTime > now) {
                 self.forecast = data[@"icon"];
                 NSLog(@"dataTime: %f, forecast: %@", dataTime, self.forecast);
                 break;
             }
         }
         
         [self.view setNeedsDisplay];
         
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"%@", error);
     }];
}

- (void)fetchOutings {
    
    PFQuery *query = [PFQuery queryWithClassName:@"GJOutings"];
    [query includeKey:@"entriesArray"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count!=0) {
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:YES];
            [objects sortedArrayUsingDescriptors:@[descriptor]];
            
            self.currentOuting = objects[self.selectedOuting];
            NSLog(@"entries count: %ld", self.currentOuting.entriesArray.count);
            [self.currentOuting.entriesArray removeObjectIdenticalTo:[NSNull null]];
            [self.collectionView reloadData];
            
        } else {
            
            self.currentOuting = [[GJOutings alloc]initWithNewEntriesArray];
            self.currentOuting.createdDate = [NSDate date];
            self.currentOuting.outingName = @"Demo Outing";
            
            [self.currentOuting saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                NSLog(@"Outing created");
            }];
        }
    }];

}

- (void)fetchSelectedOuting {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:selectedOuting] == nil) {
        self.selectedOuting = 0;
        [[NSUserDefaults standardUserDefaults] setValue:@(self.selectedOuting) forKey:selectedOuting];
    } else {
        self.selectedOuting = [[[NSUserDefaults standardUserDefaults] valueForKey:selectedOuting] integerValue];
    }
    
    NSLog(@"self.selectedOuting: %ld", self.selectedOuting);
}

#pragma mark - LiquidFloatingActionButtonDataSource

- (NSInteger)numberOfCells:(LiquidFloatingActionButton *)liquidFloatingActionButton {
    return self.cells.count;
}

- (LiquidFloatingCell *)cellForIndex:(NSInteger)index {
    return self.cells[index];
}

#pragma mark - LiquidFloatingActionButtonDelegate

- (void)liquidFloatingActionButton:(LiquidFloatingActionButton *)liquidFloatingActionButton didSelectItemAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
            [self cameraAction];
            break;
        case 1:
            [self performSegueWithIdentifier:@"textSegue" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"mapSegue" sender:self];
            break;
        default:
            [self performSegueWithIdentifier:@"outingsSegue" sender:self];
            break;
    }
    
}

#pragma mark - UICollectionView customization

// cell size
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}

// snapping while scrolling
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    // Determine which table cell the scrolling will stop on.
    CGFloat cellWidth = self.collectionView.bounds.size.width;
    NSInteger cellIndex = floor(targetContentOffset->x / cellWidth);
    
    // Round to the next cell if the scrolling will stop over halfway to the next cell.
    if ((targetContentOffset->x - (floor(targetContentOffset->x / cellWidth) * cellWidth)) > cellWidth) {
        cellIndex++;
    }
    
    // Adjust stopping point to exact beginning of cell.
    targetContentOffset->x = cellIndex * cellWidth;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.currentOuting.entriesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EntryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if ([self.currentOuting.entriesArray[indexPath.row].mediaType  isEqualToString:@"public.image"]) {
        
        cell.photoView.hidden = NO;
        cell.descriptionContainer.hidden = YES;
        cell.descriptionLabel.hidden = YES;
        cell.videoView.hidden = YES;
        
        cell.photoView.layer.cornerRadius = 10;
        
        cell.photoView.file = [self.currentOuting.entriesArray[indexPath.row] file];
        [cell.photoView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
            NSLog(@"Image loaded!");
        }];
        
    } else if ([self.currentOuting.entriesArray[indexPath.row].mediaType isEqualToString:@"public.movie"]) {
        
        cell.photoView.hidden = YES;
        cell.descriptionContainer.hidden = YES;
        cell.descriptionLabel.hidden = YES;
        cell.videoView.hidden = NO;
        
        cell.videoView.layer.cornerRadius = 10;
        
        GJEntry *videoEntry = self.currentOuting.entriesArray[indexPath.row];
        
        [videoEntry.file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            
            if (data) {
                
                NSString *urlString = [[NSString alloc]initWithData:data encoding:NSUTF16StringEncoding];
                NSURL *url = [NSURL URLWithString:urlString];
        
                // ASYNC LOADING:
        
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                
                dispatch_async(queue, ^{
                    NSLog(@"%@",videoEntry.file.url);
                    AVAsset *asset = [AVAsset assetWithURL:url];
                    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
                        
                        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
                        //NSLog(@"%@", CGRectCreateDictionaryRepresentation(cell.videoView.bounds));
                        layer.frame = cell.videoView.bounds;
                        layer.videoGravity = AVLayerVideoGravityResizeAspect;
                        
                        [player play];
                        
                        [cell.videoView.layer addSublayer:layer];
                    });
                });
            }
        }];
    } else {
        
        cell.photoView.hidden = YES;
        cell.descriptionContainer.hidden = NO;
        cell.descriptionLabel.hidden = NO;
        cell.videoView.hidden = YES;
        
        cell.descriptionContainer.layer.cornerRadius = 10;
        cell.descriptionContainer.layer.borderWidth = 1;
        // pick a better green
        cell.descriptionContainer.layer.borderColor = [UIColor greenColor].CGColor;
        
        cell.descriptionLabel.text = [self.currentOuting.entriesArray[indexPath.row] textMedia];
    }
    
    return cell;
    
}

#pragma mark - Camera and Video Methods

- (void)cameraAction {
    
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"%@",info);
    
    GJEntry *newEntry = [GJEntry new];
    [self.currentOuting.entriesArray addObject:newEntry];
    newEntry.mediaType = info[UIImagePickerControllerMediaType];
    newEntry.createdDate = [NSDate date];
    newEntry.location = [PFGeoPoint geoPointWithLocation:self.locationManager.location];
    
    if ([newEntry.mediaType isEqualToString:@"public.image"]) {
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        
        [newEntry fileFromImage:chosenImage];
        
        [self.currentOuting saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            
            NSLog(@"succeeded at saving");
        }];
    }
    
    else if([newEntry.mediaType isEqualToString:@"public.movie"]){
        NSURL *movieURL = info[UIImagePickerControllerMediaURL];
        [newEntry fileFromVideoURL:movieURL];
        
        [self.currentOuting saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            NSLog(@"succeeded at saving video");
        }];
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"textSegue"]) {
        
        TextEntryViewController *vc = (TextEntryViewController *) [[segue destinationViewController] topViewController];
        vc.currentOuting = self.currentOuting;
        vc.locationManager = self.locationManager;
        
    } else if ([segue.identifier isEqualToString:@"mapSegue"]) {
        
        HLMapView *vc = (HLMapView *) [[segue destinationViewController] topViewController];
        vc.currentOuting = self.currentOuting;
        
    }
}


@end

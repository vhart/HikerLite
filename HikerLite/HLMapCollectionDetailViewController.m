//
//  HLMapCollectionDetailViewController.m
//  HikerLite
//
//  Created by Varindra Hart on 10/20/15.
//  Copyright © 2015 Varindra Hart. All rights reserved.
//

#import "HLMapCollectionDetailViewController.h"
#import "EntryCell.h"
#import "HLMapView.h"

#import "OutingsViewController.h"
#import "TextEntryViewController.h"
#import "TripCollectionViewController.h"

#import <AFNetworking/AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HLMapCollectionDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *collectionViewContainer;
@end

@implementation HLMapCollectionDetailViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self setupCollectionView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    [self.collectionViewContainer addSubview:self.collectionView];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return self.viewedMarker.entriesArrayForLocation.count;
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


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EntryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if ([self.viewedMarker.entriesArrayForLocation[indexPath.row].mediaType  isEqualToString:@"public.image"]) {
        
        cell.photoView.hidden = NO;
        cell.descriptionContainer.hidden = YES;
        cell.descriptionLabel.hidden = YES;
        cell.videoView.hidden = YES;
        
        cell.photoView.layer.cornerRadius = 10;
        
        cell.photoView.file = [self.viewedMarker.entriesArrayForLocation[indexPath.row] file];
        [cell.photoView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
            NSLog(@"Image loaded!");
        }];
        
    } else if ([self.viewedMarker.entriesArrayForLocation[indexPath.row].mediaType isEqualToString:@"public.movie"]) {
        
        cell.photoView.hidden = YES;
        cell.descriptionContainer.hidden = YES;
        cell.descriptionLabel.hidden = YES;
        cell.videoView.hidden = NO;
        
        cell.videoView.layer.cornerRadius = 10;
        
        GJEntry *videoEntry = self.viewedMarker.entriesArrayForLocation[indexPath.row];
        
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
        cell.descriptionContainer.layer.borderColor = [UIColor colorWithRed:112/255.0 green:142/255.0 blue:50/255.0 alpha:1].CGColor;
        
        cell.descriptionLabel.text = [self.viewedMarker.entriesArrayForLocation[indexPath.row] textMedia];
    }
    
    return cell;
    
}

@end

//
//  TripCollectionViewController.m
//  GoJournal
//
//  Created by Elber Carneiro on 10/11/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "TripCollectionViewController.h"
#import "Entry.h"
#import "EntryCell.h"

@interface TripCollectionViewController ()

@property (nonatomic) NSMutableArray <Entry *> *entries;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSMutableArray <LiquidFloatingCell *> *cells;
@property (nonatomic) LiquidFloatingActionButton *floatingActionButton;

@end

@implementation TripCollectionViewController

static NSString * const reuseIdentifier = @"entryCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(self.view.frame.size.width - 56 - 16,
                              self.view.frame.size.height - 56 - 16,
                              56,
                              56);
    
    self.floatingActionButton = [[LiquidFloatingActionButton alloc] initWithFrame:frame];
    //self.floatingActionButton.animateStyle
    self.floatingActionButton.delegate = self;
    self.floatingActionButton.dataSource = self;
    
    LiquidFloatingCell *cell = [[LiquidFloatingCell alloc] initWithIcon:[UIImage imageNamed:@"pinIcon"]];
    [self.cells addObject:cell];
    [self.cells addObject:cell];
    [self.cells addObject:cell];
    
    [self.view addSubview:self.floatingActionButton];
    
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
    
    // setup demo content
    self.entries = [[NSMutableArray alloc] init];
    [self setupDemoContent];
}

- (void)setupDemoContent {
    
    UIImage *image1 = [UIImage imageNamed:@"wilderness1"];
    Entry *entryOne = [[Entry alloc] initWithImage:image1];
    [self.entries addObject:entryOne];
    
    UIImage *image2 = [UIImage imageNamed:@"wilderness2"];
    Entry *entryTwo = [[Entry alloc] initWithImage:image2];
    [self.entries addObject:entryTwo];
    
    NSString *text1 = @"It's a beautiful sunny day! I hear the birds in my ear and in my mind. Seriously, they won't stop chirping. On an on and on. All afternoon. I haven't seen another human being for two days now. The berries are getting harder and harder to find. I almost caught a squirrel. So hungry.";
    Entry *entryThree = [[Entry alloc] initWithText:text1];
    [self.entries addObject:entryThree];
    
    UIImage *image3 = [UIImage imageNamed:@"wilderness2"];
    Entry *entryFour = [[Entry alloc] initWithImage:image3];
    [self.entries addObject:entryFour];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"vid" ofType:@"m4v"];
    NSLog(@"%@", path);
    NSURL *url = [NSURL fileURLWithPath:path];
    Entry *entryFive = [[Entry alloc] initWithVideoURL:url];
    [self.entries addObject:entryFive];
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"vid2" ofType:@"m4v"];
    NSLog(@"%@", path2);
    NSURL *url2 = [NSURL fileURLWithPath:path2];
    Entry *entrySix = [[Entry alloc] initWithVideoURL:url2];
    [self.entries addObject:entrySix];
    [self.entries addObject:entrySix];
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
    return self.entries.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EntryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (self.entries[indexPath.row].image != nil) {
        
        cell.photoView.hidden = NO;
        cell.descriptionLabel.hidden = YES;
        cell.videoView.hidden = YES;
        
        cell.photoView.layer.cornerRadius = 10;
        
        cell.photoView.image = self.entries[indexPath.row].image;
        
    } else if (self.entries[indexPath.row].video != nil) {
        
        cell.photoView.hidden = YES;
        cell.descriptionLabel.hidden = YES;
        cell.videoView.hidden = NO;
        
        cell.videoView.layer.cornerRadius = 10;
        
        // ASYNC LOADING:
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        
        dispatch_async(queue, ^{
            
            AVAsset *asset = [AVAsset assetWithURL:self.entries[indexPath.row].video];
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
                
                AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
                NSLog(@"%@", CGRectCreateDictionaryRepresentation(cell.videoView.bounds));
                layer.frame = cell.videoView.bounds;
                layer.videoGravity = AVLayerVideoGravityResizeAspect;
                
                [player play];
                
                [cell.videoView.layer addSublayer:layer];
            });
        });
        
    } else {
        
        cell.photoView.hidden = YES;
        cell.descriptionLabel.hidden = NO;
        cell.videoView.hidden = YES;
        
        cell.descriptionLabel.layer.cornerRadius = 10;
        
        cell.descriptionLabel.text = self.entries[indexPath.row].text;
    }
    
    return cell;

}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - Navigation

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

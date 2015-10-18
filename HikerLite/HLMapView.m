//
//  HLMapView.m
//  HikerLite
//
//  Created by Varindra Hart on 10/18/15.
//  Copyright © 2015 Varindra Hart. All rights reserved.
//

#import "HLMapView.h"
@import GoogleMaps;
#import "GMSMarker+GJEntryArray.h"

@interface HLMapView () <GMSMapViewDelegate>
@property (nonatomic) GMSMapView *mapView_;
@property (nonatomic) NSMutableArray <GMSMarker *> *markersArray;
@property (nonatomic) NSMutableArray <GJEntry *> *allEntries;
@end

@implementation HLMapView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss:)];
    [self setUpMapsAndMarkers];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpMapsAndMarkers{
    
    self.allEntries = [[NSMutableArray alloc] initWithArray:self.currentOuting.entriesArray copyItems:YES];
    
    [self makeSectionalMarkersForMap];
    
//    CLLocationCoordinate2D center = [self findCenterForMarkers];
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:44.9
                                                            longitude:-73.4
                                                                 zoom:15];
    self.mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView_.myLocationEnabled = YES;
    //self.viewForMap = self.mapView_;
    self.view = self.mapView_;
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(44.9,-73.4);
    //    marker.title = @"Sydney";
    //    marker.snippet = @"Australia";
    marker.map = self.mapView_;
    
    
    
    for (GMSMarker *marker in self.markersArray) {
        marker.map = self.mapView_;
    }
    
    
}

- (void)dismiss:(UIBarButtonItem *)doneButton{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Location Methods and Sorting;

- (CLLocationCoordinate2D)findCenterPoint:(CLLocationCoordinate2D)_lo1 :(CLLocationCoordinate2D)_loc2 {
    CLLocationCoordinate2D center;
    
    double lon1 = _lo1.longitude * M_PI / 180;
    double lon2 = _loc2.longitude * M_PI / 180;
    
    double lat1 = _lo1.latitude * M_PI / 180;
    double lat2 = _loc2.latitude * M_PI / 180;
    
    double dLon = lon2 - lon1;
    
    double x = cos(lat2) * cos(dLon);
    double y = cos(lat2) * sin(dLon);
    
    double lat3 = atan2( sin(lat1) + sin(lat2), sqrt((cos(lat1) + x) * (cos(lat1) + x) + y * y) );
    double lon3 = lon1 + atan2(y, cos(lat1) + x);
    
    center.latitude  = lat3 * 180 / M_PI;
    center.longitude = lon3 * 180 / M_PI;
    
    return center;
}

- (void)makeSectionalMarkersForMap{
    
    while (self.allEntries.count != 0) {
        
        GMSMarker *newMarker = [[GMSMarker alloc]init];
        newMarker.entriesArrayForLocation = [NSMutableArray new];
        
        GJEntry *topEntry = self.allEntries.firstObject;
        newMarker.position = CLLocationCoordinate2DMake(topEntry.location.latitude, topEntry.location.longitude);
        
        [newMarker.entriesArrayForLocation addObject:topEntry];
        [self.allEntries removeObject:topEntry];
        
        for (GJEntry *entry in self.allEntries) {
            if ([newMarker.entriesArrayForLocation.firstObject.location distanceInKilometersTo:entry.location] < .25f) {
                [newMarker.entriesArrayForLocation addObject:entry];
                [self.allEntries removeObject:entry];
            }
        }
        
        [self.markersArray addObject:newMarker];
        
    }
}

//- (CLLocationCoordinate2D)findCenterForMarkers{
//    
//  
//    return ;
//}


#pragma mark - GMS Delegate

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    
    //Code for viewing media for that location.
    /*
     
     - Instatiate some Collection View Controller from storyboard.
     - Pass over marker.entriesArrayForLocation to the Collection View Controller
     - self.navigationController pushViewController: Collection View Controller animated:YES completion:nil
     
     */
    
    return YES;
}

@end

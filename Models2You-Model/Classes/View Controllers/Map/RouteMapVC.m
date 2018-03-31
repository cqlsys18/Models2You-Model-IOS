//
//  MapVCViewController.m
//  Models2You-Model
//
//  Created by RajeshYadav on 17/08/16.
//  Copyright © 2016 Valtus Real Estate, LLC. All rights reserved.
//

#import "RouteMapVC.h"
#import "GoogleMapsDistanceMatrixApiWrapper.h"
#import "RouteSteps.h"
#import "UserAnnotation.h"
#import "Config.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "DisplayToast.h"

#define ANNOTATION_VIEW_IDENTIFIER      @"pin_annot_view"
#define USER_LOCATION_AV_IDENTIFIER     @"user_annot_view"

#define ROUTE_DIRECTION_ICON_DEFAULT_WIDTH 50
#define ROUTE_DIRECTION_DESC_DEFAULT_HEIGHT 21
#define TABLE_VIEW_CELL_DEFAULT_HEIGHT 44

@interface RouteMapVC (){
    NSMutableArray *_routeDetails;
    NSString *_startAddress;
    NSString *_endAddress;
    MKPolyline *_routeOverLayPolyline;
}

@property (nonatomic, strong) UserAnnotation *annotation;
    @property (nonatomic, strong) UserAnnotation *annotationDestination;
@property (nonatomic, strong) CLLocation *userLocation;

@end

@implementation RouteMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super initUI];
    
    [self initUI];
    
    //Update current location from AppDelegate class
    //////////////////////////////////////////////////////////////////////////////////////////
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(delegate){
        self.sourceLocation = delegate.curLocation.coordinate;
    }
    //////////////////////////////////////////////////////////////////////////////////////////
    
    self.mapView.delegate = self;
    //self.mapView.showsUserLocation = true;
   
    // testing update status code
    [self updateStatusText];
    
    // Get device location update
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLocationUpdateNotification:) name:DEVICE_LOCATION_UPDATE object:nil];
    
    [self receiveLocationUpdateNotification:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
//-(void) viewDidAppear:(BOOL)animated{
    // update constraint value of direction detail view
    CGRect rcFrame = CGRectZero;
    rcFrame = self.viewRouteDetailBg.frame;
    rcFrame.origin.y = self.view.bounds.size.height;
    rcFrame.size.width = self.view.bounds.size.width;
    rcFrame.size.height = self.view.bounds.size.height;
    self.viewRouteDetailBg.frame = rcFrame;
    self.viewRouteDetailBg.translatesAutoresizingMaskIntoConstraints = true;
    
    
    // update rounded view
    rcFrame = self.viewRouteDetailRoundedInner.frame;
    rcFrame.size.width = self.view.bounds.size.width - (rcFrame.origin.x*2);
    rcFrame.size.height = self.view.bounds.size.height - (rcFrame.origin.y*2);
    self.viewRouteDetailRoundedInner.frame = rcFrame;
    self.viewRouteDetailRoundedInner.translatesAutoresizingMaskIntoConstraints = true;
    
    // update rounded view
    rcFrame = self.viewRouteDetailRoundedInner.frame;
    rcFrame.size.width = self.viewRouteDetailRoundedInner.frame.size.width - (rcFrame.origin.x*2);
    rcFrame.size.height = self.viewRouteDetailRoundedInner.frame.size.height - (rcFrame.origin.y*2);
    self.tableViewRouteDetails.frame = rcFrame;
    self.tableViewRouteDetails.translatesAutoresizingMaskIntoConstraints = true;
    
    rcFrame = self.btnPopupClose.frame;
    rcFrame.origin.x = (self.viewRouteDetailRoundedInner.frame.origin.x + self.viewRouteDetailRoundedInner.frame.size.width) - (rcFrame.size.width)/2 ;
    //rcFrame.origin.y = rcFrame.size.height/2;
    self.btnPopupClose.frame = rcFrame;
    self.btnPopupClose.translatesAutoresizingMaskIntoConstraints = true;
    
    // hide time left label initially
    self.lblTimeLeft.hidden = true;
    self.lblTimeLeftTitle.hidden = true;
}

#pragma mark - Init

- (void)initUI {
    self.viewRouteDetailRoundedInner.layer.cornerRadius = 4;
    self.btnShowDirection.layer.cornerRadius = 4;
    
    //[self addAnnotation];
    
    if(self.isPostponeBtnTextChange){
        self.btnArrived.hidden = YES;
        [_btnPostponeOrContinue setImage:[UIImage imageNamed:@"ContinueBtn"] forState:UIControlStateNormal];
    }else{
        self.btnArrived.hidden = NO;
        [_btnPostponeOrContinue setImage:[UIImage imageNamed:@"PostponeBtn"] forState:UIControlStateNormal];
    }
}

#pragma mark - private method
-(void) showDirectionDetailView{
    
    [UIView beginAnimations:@"show" context:nil];
    [UIView setAnimationDuration:0.8];
    CGRect rcFrame = CGRectZero;
    rcFrame = self.viewRouteDetailBg.frame;
    rcFrame.origin.y = 0;
    self.viewRouteDetailBg.frame = rcFrame;

    [UIView commitAnimations];
}

-(void) hideDirectionDetailView{
    [UIView animateWithDuration:1.0f
                     animations:^{
                         // update constraint value of direction detail view
                         CGRect rcFrame = CGRectZero;
                         rcFrame = self.viewRouteDetailBg.frame;
                         rcFrame.origin.y = self.view.bounds.size.height;;
                         self.viewRouteDetailBg.frame = rcFrame;
                     }
                     completion:^(BOOL finished){
                         // Do nothing
                     }];
}

-(void) updateRemainingTime:(NSString *)timeStr{
    if(self.lblTimeLeft){
        self.lblTimeLeft.text = timeStr;
        self.lblTimeLeft.hidden = false;
        self.lblTimeLeftTitle.hidden = false;
    }
}

#pragma mark - Notification
- (void) receiveLocationUpdateNotification:(NSNotification *) notification
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(delegate){
        
        self.sourceLocation = delegate.curLocation.coordinate;
        
        //TODO: test geo location update notification
//        self.lblTimeLeft.text = [NSString stringWithFormat:@"%f,%f", delegate.curLocation.coordinate.latitude, delegate.curLocation.coordinate.longitude];
//        self.lblTimeLeft.hidden = false;
        
            CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
            [geoCoder reverseGeocodeLocation:delegate.curLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                
                if (error) {
                    
//                    [[DisplayToast sharedManager] showErrorWithStatus:@"Error while fetching the address of this cell phone."];
                    return;
                }
                
                CLPlacemark *placemark = [placemarks firstObject];
                
                NSMutableArray *comps = [NSMutableArray array];
                
                if (placemark.subThoroughfare)
                    [comps addObject:placemark.subThoroughfare];
                if (placemark.thoroughfare)
                    [comps addObject:placemark.thoroughfare];
                if (placemark.subLocality)
                    [comps addObject:placemark.subLocality];
                if (placemark.locality)
                    [comps addObject:placemark.locality];
                if (placemark.subAdministrativeArea)
                    [comps addObject:placemark.subAdministrativeArea];
                if (placemark.administrativeArea)
                    [comps addObject:placemark.administrativeArea];
                if (placemark.postalCode)
                    [comps addObject:placemark.postalCode];
                
                NSString *startAddressString = [comps componentsJoinedByString:@", "];
                NSLog(@"%@", startAddressString);
                
                [self updateLocationAddress:startAddressString];
                
            }];
        
        // update user location if delay on API calling
        [self updateLocationAddress:nil];
        
        // update path from current location
        [self updateStatusText];
    }
}

-(void) updateLocationAddress:(NSString *)newAddress{
    //Update model pin on mapview as per location changes
    if (_annotation)
        [_mapView removeAnnotation:_annotation];
    
    
    if (_annotation == nil) {
        _annotation = [[UserAnnotation alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:self.sourceLocation.latitude longitude:self.sourceLocation.longitude]];
        _annotation.isUserLocation = YES;
    }
    
    NSString *title = nil;
    if(newAddress != nil){
        title = [NSString stringWithFormat:@"Current Location: %@", newAddress];
    }else{
        title = @"Current Location";
    }
    _annotation.customTitle = title;
    
    _annotation.coordinate = CLLocationCoordinate2DMake(self.sourceLocation.latitude, self.sourceLocation.longitude);
    
    [self.mapView addAnnotation:_annotation];
}

#pragma mark - Action Delegate
-(IBAction)actionBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)actionShowDirection:(id)sender{
    //[self showDirectionDetailView];
    
    // TODO: check google app and open direction in google apple
    //BOOL canHandle = [[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"comgooglemaps://"]];
    
    //TODO: Check condition; currently it is not getting installed status of google map
    BOOL canHandle = [[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"comgooglemapsurl://"]];
    
    NSURL *URL = nil;
    
    if (canHandle)
    {
        // for google app
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f", _sourceLocation.latitude, _sourceLocation.longitude, _destinationLocation.latitude, _destinationLocation.longitude]];
        NSLog(@"Goolge map found");
    }
    else
    {
        // for apple app
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f", _sourceLocation.latitude, _sourceLocation.longitude, _destinationLocation.latitude, _destinationLocation.longitude]];
        NSLog(@"Apple map found");
    }
    
    if(URL != nil){
        [[UIApplication sharedApplication] openURL:URL];
    }
}

-(IBAction)actionClose:(id)sender{
    [self hideDirectionDetailView];
}

- (IBAction)actionArrived:(id)sender{
    if(_delegate && [(id)_delegate respondsToSelector:@selector(arrivedBtnPressed)]){
        [_delegate arrivedBtnPressed];
    }
}

- (IBAction)actionPostponeOrContinue:(id)sender{
    
    if(!self.isPostponeBtnTextChange){
        self.btnArrived.hidden = YES;
        self.isPostponeBtnTextChange = true;
        [_btnPostponeOrContinue setImage:[UIImage imageNamed:@"ContinueBtn"] forState:UIControlStateNormal];
    }else{
        self.btnArrived.hidden = NO;
        self.isPostponeBtnTextChange = false;
        [_btnPostponeOrContinue setImage:[UIImage imageNamed:@"PostponeBtn"] forState:UIControlStateNormal];
    }
    
    if(_delegate && [(id)_delegate respondsToSelector:@selector(postPoneOrContinueBtnPressed)]){
        [_delegate postPoneOrContinueBtnPressed];
    }
}

- (IBAction)actionCancel:(id)sender{
    if(_delegate && [(id)_delegate respondsToSelector:@selector(cancelBtnPressed)]){
        [_delegate cancelBtnPressed];
    }
}

#pragma mark - Map View Delegate
- (void)addAnnotation{
    
    NSString *title = nil;
    UserAnnotation *annot = nil;
    if(self.sourceLocation.latitude != 0 && self.sourceLocation.longitude != 0){
        if(_startAddress != nil){
            title = [NSString stringWithFormat:@"Current Location: %@", _startAddress];
        }else{
            title = @"Start Point";
        }
        
        if (_annotation)
            [_mapView removeAnnotation:_annotation];
        
        if(_annotation == nil){
            _annotation = [[UserAnnotation alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:self.sourceLocation.latitude longitude:self.sourceLocation.longitude]];
            _annotation.isUserLocation = YES;
        }
        
        _annotation.coordinate = CLLocationCoordinate2DMake(self.sourceLocation.latitude, self.sourceLocation.longitude);
        _annotation.customTitle = title;
        
        [self.mapView addAnnotation:_annotation];
    }
    
    if(self.destinationLocation.latitude != 0 && self.destinationLocation.longitude != 0){
        if(_endAddress != nil){
            title = [NSString stringWithFormat:@"Event Point: %@", _endAddress];
            
        }else{
            title = @"Event Point";
        }
        
        if(_annotationDestination){
            [_mapView removeAnnotation:_annotationDestination];
        }
        
        if(_annotationDestination == nil){
            _annotationDestination = [[UserAnnotation alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:self.destinationLocation.latitude longitude:self.destinationLocation.longitude]];
            _annotationDestination.customTitle = title;
        }
        [self.mapView addAnnotation:_annotationDestination];
    }
    
    if(self.sourceLocation.latitude != 0 && self.sourceLocation.longitude != 0 && self.destinationLocation.latitude != 0 && self.destinationLocation.longitude != 0){
        MKCoordinateRegion region;
        
        CLLocationDegrees maxLat = -90;
        CLLocationDegrees maxLon = -180;
        CLLocationDegrees minLat = 90;
        CLLocationDegrees minLon = 180;
        CLLocation* currentLocation = nil;
        for(int loopIndex = 0; loopIndex < 2; loopIndex++)
        {
            if(loopIndex == 0){ // check source
                currentLocation = [[CLLocation alloc] initWithLatitude:self.sourceLocation.latitude longitude:self.sourceLocation.longitude];
            }else if(loopIndex == 1){// check destination
                currentLocation = [[CLLocation alloc] initWithLatitude:self.destinationLocation.latitude longitude:self.destinationLocation.longitude];
            }
            
            if(currentLocation.coordinate.latitude > maxLat)
                maxLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.latitude < minLat)
                minLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.longitude > maxLon)
                maxLon = currentLocation.coordinate.longitude;
            if(currentLocation.coordinate.longitude < minLon)
                minLon = currentLocation.coordinate.longitude;
        }
        
        region.center.latitude     = (maxLat + minLat) / 2;
        region.center.longitude    = (maxLon + minLon) / 2;
        region.span.latitudeDelta  = maxLat - minLat + 0.005;
        region.span.longitudeDelta = maxLon - minLon + 0.005;
        
        [self.mapView setRegion:region animated:YES];
    }else if(self.sourceLocation.latitude != 0 && self.sourceLocation.longitude != 0){
        // make source as center
        MKCoordinateRegion mapRegion;
        mapRegion.center = self.sourceLocation;
        mapRegion.span.latitudeDelta = 0.005;
        mapRegion.span.longitudeDelta = 0.005;
        [self.mapView setRegion:mapRegion animated: YES];
    }else if(self.destinationLocation.latitude != 0 && self.destinationLocation.longitude != 0){
        // make destination as center
        MKCoordinateRegion mapRegion;
        mapRegion.center = self.sourceLocation;
        mapRegion.span.latitudeDelta = 0.005;
        mapRegion.span.longitudeDelta = 0.005;
        [self.mapView setRegion:mapRegion animated: YES];
    }
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    routeLineRenderer.strokeColor = [UIColor colorWithRed:45.0/255.0 green:186.0/255.0 blue:228.0/255.0 alpha:1.0];
    routeLineRenderer.lineWidth = 5;
    return routeLineRenderer;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    UserAnnotation *annot = annotation;
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
  
        if (annot.isUserLocation) {
            MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:USER_LOCATION_AV_IDENTIFIER];
            if (!pinView) {
                
                pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annot reuseIdentifier:USER_LOCATION_AV_IDENTIFIER];
                pinView.pinColor = MKPinAnnotationColorGreen;
                pinView.canShowCallout = YES;
            }
            return pinView;
        }
        
        MKPinAnnotationView *av = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:ANNOTATION_VIEW_IDENTIFIER];
        if (!av) {
            av = [[MKPinAnnotationView alloc] initWithAnnotation:annot reuseIdentifier:ANNOTATION_VIEW_IDENTIFIER];
            av.canShowCallout = YES;
            //av.pinColor = MKPinAnnotationColorGreen;
            //av.image = [UIImage imageNamed:@"AnnotationImage"];
        }
        
        av.annotation = annot;
    return av;
    
}
//
//- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
//{
//    NSLog(@"%@",view.annotation.title);
//    NSLog(@"%@",view.annotation.subtitle);
//}

#pragma mark - Miscellaneous Functions

- (void)updateStatusText {
    
    [GoogleMapsDistanceMatrixApiWrapper getDistancesBetweenOrigins:@[[[CLLocation alloc] initWithLatitude:_sourceLocation.latitude longitude:_sourceLocation.longitude]]
                                                      destinations:@[[[CLLocation alloc] initWithLatitude:_destinationLocation.latitude longitude:_destinationLocation.longitude]]
                                                        unitSystem:IMPERIAL
                                                          inFormat:JSON success:^(id responseObject) {
                                                              
                                                              NSDictionary *result = responseObject;
                                                              
                                                              if ([result[GOOGLE_PARAM_STATUS] isEqualToString:GOOGLE_STATUS_OK]) {
                                                                  NSLog(@"Server Response: %@", result.description);
                                                                  [self parseResponse:result];
                                                              } else {
                                                                  NSLog(@"Google Maps Distance Matrix API response status:%@", result[GOOGLE_PARAM_STATUS]);
                                                                  [self parseResponse:nil];
                                                              }
                                                          } failure:^(NSError *error) {
                                                              NSLog(@"Error while calling google maps distance matrix api.\n%@", error);
                                                              [self parseResponse:nil];
                                                          }];
}

- (void)parseResponse:(NSDictionary *)response {
    
    if(_routeOverLayPolyline){
        [self.mapView removeOverlay:_routeOverLayPolyline];
    }
    
    if(response != nil){
        NSArray *routes = [response objectForKey:@"routes"];
        NSDictionary *route = [routes lastObject];
        if (route != nil && route.count > 0) {
            NSString *overviewPolyline = [[route objectForKey: @"overview_polyline"] objectForKey:@"points"];
            _routeOverLayPolyline = [self polylineWithEncodedString:overviewPolyline];
            [self.mapView addOverlay:_routeOverLayPolyline];
            
            // set start and end address on pin
            [self setStartEndAddress:route];
            
            // parse path between start point to end point
            [self parseRouteSteps:route];
        }
    }else{
        [self addAnnotation];
    }
        
}

-(void) setStartEndAddress:(NSDictionary *)response{
    _startAddress = [[[response objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"start_address"];
    _endAddress = [[[response objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"end_address"];
    
    [self addAnnotation];
}

-(void)parseRouteSteps:(NSDictionary *)response{
    
    NSArray *arrSteps = [[[response objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"steps"];
    NSDictionary *routeStepsInfo = nil;
    
    if(_routeDetails == nil){
       
        _routeDetails = [[NSMutableArray alloc] initWithCapacity:2];
        
        RouteSteps *routeSteps = nil;
        
        // fetch steps from start point to end point
        for (int loopIndex=0;loopIndex<arrSteps.count; loopIndex++) {
            
            routeStepsInfo = [arrSteps objectAtIndex:loopIndex];
            if(routeStepsInfo != nil){
                routeSteps = [[RouteSteps alloc] init];
                routeSteps.title = [self stringByStrippingHTML:[routeStepsInfo objectForKey:@"html_instructions"]];
                routeSteps.distance = [[routeStepsInfo objectForKey:@"distance"] objectForKey:@"text"];
                routeSteps.duration = [[routeStepsInfo objectForKey:@"duration"] objectForKey:@"text"];
                routeSteps.startLocationLat = [NSNumber numberWithDouble:[[[routeStepsInfo objectForKey:@"start_location"] objectForKey:@"lat"] doubleValue]];
                routeSteps.startLocationLon = [NSNumber numberWithDouble:[[[routeStepsInfo objectForKey:@"start_location"] objectForKey:@"lng"] doubleValue]];
                routeSteps.endLocationLat = [NSNumber numberWithDouble:[[[routeStepsInfo objectForKey:@"end_location"] objectForKey:@"lat"] doubleValue]];
                routeSteps.endLocationLon = [NSNumber numberWithDouble:[[[routeStepsInfo objectForKey:@"end_location"] objectForKey:@"lng"] doubleValue]];
                routeSteps.travelMode = [routeStepsInfo objectForKey:@"travel_mode"];
                routeSteps.polyline = [[routeStepsInfo objectForKey:@"polyline"] objectForKey:@"points"];
                routeSteps.maneuver = [self stringByStrippingHTML:[routeStepsInfo objectForKey:@"maneuver"]];
                [_routeDetails addObject:routeSteps];
                routeSteps = nil;
            }
        }
        
        [self.tableViewRouteDetails reloadData];
    }
}

- (NSString *)stringByStrippingHTML: (NSString *) html {
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString: html];
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString: @"<" intoString: NULL];
        // find end of tag
        [theScanner scanUpToString: @">" intoString: &text];
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat: @"%@>", text]
                                               withString: @" "];
    } // while //
    return html;
}

- (MKPolyline *)polylineWithEncodedString:(NSString *)encodedString {
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:coordIdx];
    free(coords);
    
    return polyline;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource method implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(_routeDetails && _routeDetails.count > 0)
        return _routeDetails.count;
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger totalCellHeight = TABLE_VIEW_CELL_DEFAULT_HEIGHT;
    NSInteger labelWidth = self.tableViewRouteDetails.frame.size.width - ROUTE_DIRECTION_ICON_DEFAULT_WIDTH;
    NSString *textInfo = nil;
    UIFont *customFont = nil;
    
    CGRect rcFrame = CGRectZero;
    
    RouteSteps *routeSteps = nil;
    routeSteps = [_routeDetails objectAtIndex:indexPath.row];
    
    if(routeSteps){
        customFont = [UIFont systemFontOfSize:16];
        textInfo = routeSteps.title;
        
        CGRect rect = [textInfo boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:customFont}
                                                  context:nil];
        rcFrame.size.height = rect.size.height;
        totalCellHeight = rect.size.height;
        totalCellHeight += ROUTE_DIRECTION_DESC_DEFAULT_HEIGHT + 5;
        
        if(totalCellHeight <= TABLE_VIEW_CELL_DEFAULT_HEIGHT){
            totalCellHeight = TABLE_VIEW_CELL_DEFAULT_HEIGHT;
        }
    }
    
    
    
    return totalCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ROUTE_DETAIL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    RouteSteps *routeSteps = nil;
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(cell){
        
        cell.translatesAutoresizingMaskIntoConstraints = true;
        
        UIImageView *imageViewIcon = nil;
        UILabel *labelText = nil;
        NSString *textInfo = nil;
        CGRect rcFrame = CGRectZero;
        CGRect rcNewFrame = CGRectZero;
        NSInteger labelWidth = self.tableViewRouteDetails.frame.size.width - ROUTE_DIRECTION_ICON_DEFAULT_WIDTH;
        
        routeSteps = [_routeDetails objectAtIndex:indexPath.row];
        
        // direction icon
        imageViewIcon = (UIImageView *)[cell viewWithTag:1000];
        textInfo = [self getDriectionImageNamge:routeSteps.maneuver];
        if(textInfo){
            imageViewIcon.image = [UIImage imageNamed:textInfo];
        }
        
        // title
        labelText = (UILabel *)[cell viewWithTag:2000];
        labelText.translatesAutoresizingMaskIntoConstraints = true;
        rcFrame = labelText.frame;
        rcFrame.size.width = labelWidth;
        textInfo = [NSString stringWithFormat:@"%@", routeSteps.title];
        labelText.text = textInfo;
        rcNewFrame = [textInfo boundingRectWithSize:CGSizeMake(rcFrame.size.width, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:labelText.font}
                                             context:nil];
        rcFrame.size.height = rcNewFrame.size.height;
        NSInteger numberOfLines =        ceilf(rcNewFrame.size.height / ROUTE_DIRECTION_DESC_DEFAULT_HEIGHT);
        
        rcFrame.size.height = numberOfLines*ROUTE_DIRECTION_DESC_DEFAULT_HEIGHT;
        
        rcNewFrame = rcFrame;
        labelText.frame = rcFrame;
        rcFrame = labelText.frame;
        
        // description
        labelText = (UILabel *)[cell viewWithTag:3000];
        labelText.translatesAutoresizingMaskIntoConstraints = true;
        rcFrame = labelText.frame;
        rcFrame.size.width = labelWidth;
        labelText.text = [NSString stringWithFormat:@"Distance: %@ Time: %@", routeSteps.distance, routeSteps.duration, nil];
        rcFrame.origin.y = rcNewFrame.origin.y + rcNewFrame.size.height;
        labelText.frame = rcFrame;
    }
    
    return cell;
}

-(NSString *) getDriectionImageNamge:(NSString *)direction{
    NSString *imageName = nil;
    
    if([direction isEqualToString:@"turn-sharp-left"]){
        imageName = @"turn-sharp-left";
    }else if([direction isEqualToString:@"turn-sharp-right"]){
        imageName = @"turn-sharp-right";
    }else if([direction isEqualToString:@"turn-slight-right"]){
        imageName = @"turn-slight-right";
    }else if([direction isEqualToString:@"turn-slight-left"]){
        imageName = @"turn-slight-left";
    }else if([direction isEqualToString:@"merge"]){
        imageName = @"merge";
    }else if([direction isEqualToString:@"roundabout-left"]){
        imageName = @"roundabout-left";
    }else if([direction isEqualToString:@"roundabout-right"]){
        imageName = @"roundabout-right";
    }else if([direction isEqualToString:@"uturn-left"]){
        imageName = @"uturn-left";
    }else if([direction isEqualToString:@"uturn-right"]){
        imageName = @"uturn-right";
    }else if([direction isEqualToString:@"turn-left"]){
        imageName = @"tr";
    }else if([direction isEqualToString:@"ramp-right"]){
        imageName = @"ramp-right";
    }else if([direction isEqualToString:@"turn-right"]){
        imageName = @"tr";
    }else if([direction isEqualToString:@"fork-right"]){
        imageName = @"fork-right";
    }else if([direction isEqualToString:@"straight"]){
        imageName = @"top";
    }else if([direction isEqualToString:@"fork-left"]){
        imageName = @"fork-left";
    }else if([direction isEqualToString:@"ferry-train"]){
        imageName = @"ferry-train";
    }else if([direction isEqualToString:@"ramp-left"]){
        imageName = @"ramp-left";
    }else if([direction isEqualToString:@"ferry"]){
        imageName = @"ferry";
    }else if([direction isEqualToString:@"keep-left"]){
        imageName = @"left";
    }else if([direction isEqualToString:@"keep-right"]){
        imageName = @"right";
    }
    
    
    return imageName;
}

@end

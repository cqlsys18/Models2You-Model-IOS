//
//  MapVCViewController.h
//  Models2You-Model
//
//  Created by RajeshYadav on 17/08/16.
//  Copyright © 2016 Valtus Real Estate, LLC. All rights reserved.
//

#import "BaseVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol RouteMapVCDelegate;

@interface RouteMapVC : BaseVC <MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextView *txtStepsView;

@property (weak, nonatomic) IBOutlet UIView *viewRouteDetailBg;
@property (weak, nonatomic) IBOutlet UIView *viewRouteDetailRoundedInner;
@property (weak, nonatomic) IBOutlet UITableView *tableViewRouteDetails;
@property (weak, nonatomic) IBOutlet UIButton *btnPopupClose;

@property (weak, nonatomic) IBOutlet UIButton *btnShowDirection;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* viewRouteDetail_YConstraint;

@property (weak, nonatomic) IBOutlet UIButton *btnArrived;
@property (weak, nonatomic) IBOutlet UIButton *btnPostponeOrContinue;

@property (weak, nonatomic) IBOutlet UILabel *lblTimeLeft;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeLeftTitle;
@property (weak, nonatomic) IBOutlet UIView *viewTime;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property CLLocationCoordinate2D destinationLocation;
@property CLLocationCoordinate2D sourceLocation;

@property (strong, nonatomic) NSString *allSteps;

@property (nonatomic, retain) id<RouteMapVCDelegate> delegate;

@property bool isPostponeBtnTextChange;

-(void) updateRemainingTime:(NSString *)timeStr;

- (IBAction)actionBack:(id)sender;
- (IBAction)actionShowDirection:(id)sender;
- (IBAction)actionClose:(id)sender;
- (IBAction)actionArrived:(id)sender;
- (IBAction)actionPostponeOrContinue:(id)sender;
- (IBAction)actionCancel:(id)sender;

@end


@protocol RouteMapVCDelegate

- (void)arrivedBtnPressed;
- (void)postPoneOrContinueBtnPressed;
- (void)cancelBtnPressed;

@end

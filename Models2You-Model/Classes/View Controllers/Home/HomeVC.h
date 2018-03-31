//
//  HomeVC.h
//  Models2You-Model
//
//  Created by user on 9/16/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "BaseVC.h"

#import <CoreLocation/CoreLocation.h>
#import "BookingListVC.h"

@interface HomeVC : BaseVC <CLLocationManagerDelegate, BookingListViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblNumBooking;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalEarnings;
@property (weak, nonatomic) IBOutlet UISwitch *availabilitySwitch;

@property (weak, nonatomic) IBOutlet UIImageView *ivAvailabilityBack;
@property (weak, nonatomic) IBOutlet UIImageView *ivViewBookingBack;
@property (weak, nonatomic) IBOutlet UIImageView *ivExitBack;

- (IBAction)actionSetStatus:(id)sender;
- (IBAction)actionViewBooking:(id)sender;
- (IBAction)actionExit:(id)sender;

@end

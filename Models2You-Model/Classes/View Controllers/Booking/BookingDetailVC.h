//
//  BookingDetailVC.h
//  Models2You-Model
//
//  Created by user on 9/17/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "BaseVC.h"

#import "Booking.h"
#import "MarqueeLabel.h"

@interface BookingDetailVC : BaseVC

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblBookDate;
@property (weak, nonatomic) IBOutlet UILabel *lblAppointmentTime;
@property (weak, nonatomic) IBOutlet UILabel *lblAppointmentDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet MarqueeLabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblWear;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UILabel *lblRate;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeLeft;
@property (weak, nonatomic) IBOutlet UIView *viewTime;
@property (weak, nonatomic) IBOutlet UIView *viewStatus;

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIView *tblContentView;

@property (nonatomic, strong) Booking *booking;
@property (nonatomic, retain) NSString *notificationMsg;
@property (nonatomic) long long bookingId;

@property (weak, nonatomic) IBOutlet UIView *viewPendingActions;
@property (weak, nonatomic) IBOutlet UIView *viewCurrentActions;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnOnMyWay;
@property (weak, nonatomic) IBOutlet UIButton *btnArrived;
@property (weak, nonatomic) IBOutlet UIButton *btnPostponeOrContinue;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;

@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (weak, nonatomic) IBOutlet UIButton *btnDeny;

-(void) refreshScreenData;

- (IBAction)actionBack:(id)sender;
- (IBAction)actionCancel:(id)sender;
- (IBAction)actionDeny:(id)sender;
- (IBAction)actionAccept:(id)sender;
- (IBAction)actionOnMyWay:(id)sender;
- (IBAction)actionArrived:(id)sender;
- (IBAction)actionPostponeOrContinue:(id)sender;
- (IBAction)actionCallClient:(id)sender;

@end

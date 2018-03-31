//
//  BookingListVC.h
//  Models2You-Model
//
//  Created by user on 9/17/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "BaseVC.h"

#import "Booking.h"

@protocol BookingListViewDelegate <NSObject>

- (void)curBookingCountFetched:(int)count;

@end

@interface BookingListVC : BaseVC <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BOOKING_CATEGORY bookingCat;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@property (nonatomic, strong) id<BookingListViewDelegate> delegate;

- (IBAction)actionBack:(id)sender;

@end

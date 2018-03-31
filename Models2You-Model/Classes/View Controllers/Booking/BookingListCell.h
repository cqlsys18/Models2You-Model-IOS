//
//  BookingListCell.h
//  Models2You-Model
//
//  Created by user on 9/17/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivBack;
@property (weak, nonatomic) IBOutlet UILabel *lblClientName;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblAppointmentTime;
@property (weak, nonatomic) IBOutlet UILabel *lblCalDay;

@end

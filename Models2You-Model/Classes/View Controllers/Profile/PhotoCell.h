//
//  PhotoCell.h
//  Models2You-Model
//
//  Created by user on 11/5/15.
//  Copyright © 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoCell;

@protocol PhotoCellDelegate <NSObject>

- (void)actionRemove:(PhotoCell *)cell;
- (void)actionCheckUncheck:(PhotoCell *)cell;

@end

@interface PhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnRemove;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckUncheck;

@property (nonatomic, strong) id<PhotoCellDelegate> delegate;

- (IBAction)actionRemove:(id)sender;
- (IBAction)actionCheckUncheck:(id)sender;

@end

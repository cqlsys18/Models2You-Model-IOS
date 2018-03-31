//
//  SelectPhotoVC.h
//  Models2You-Model
//
//  Created by user on 11/7/15.
//  Copyright © 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "BaseVC.h"

#import "PhotoCell.h"

@protocol SelectPhotoViewDelegate <NSObject>

- (void)photoPicked:(NSString *)strUrl;

@end

@interface SelectPhotoVC : BaseVC <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PhotoCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) id<SelectPhotoViewDelegate> delegate;
@property (nonatomic, strong) NSString *strPicture;

- (IBAction)actionCancel:(id)sender;
- (IBAction)actionDone:(id)sender;

@end

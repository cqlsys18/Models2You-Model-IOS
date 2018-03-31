//
//  ManagePhotoVC.h
//  Models2You-Model
//
//  Created by user on 11/4/15.
//  Copyright © 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "BaseVC.h"

#import <PEPhotoCropEditor/PECropViewController.h>
#import "PhotoCell.h"

@interface ManagePhotoVC : BaseVC <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PECropViewControllerDelegate, PhotoCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *viewAdd;
@property (weak, nonatomic) IBOutlet UILabel *lblEditDone;

- (IBAction)actionAddPhoto:(id)sender;
- (IBAction)actionEditDone:(id)sender;

@end

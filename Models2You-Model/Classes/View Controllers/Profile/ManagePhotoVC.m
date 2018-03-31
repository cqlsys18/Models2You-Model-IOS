//
//  ManagePhotoVC.m
//  Models2You-Model
//
//  Created by user on 11/4/15.
//  Copyright © 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "ManagePhotoVC.h"

#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "AccountManager.h"
#import "SVProgressHUD.h"
#import "WebServiceClient.h"
#import "UIImage+dataOfCustomSize.h"
#import "Photo.h"
#import "Utils.h"

#import "DisplayToast.h"

@interface ManagePhotoVC ()

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic) BOOL isEditMode;

@end

@implementation ManagePhotoVC

@synthesize photos, isEditMode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Init

- (void)initUI {
    
    self.showMenuBtn = YES;
    
    [super initUI];
}

- (void)loadData {
    
    photos = [NSMutableArray array];
    
    [[DisplayToast sharedManager] showWithStatus:@"Loading..."];
    
    [[WebServiceClient sharedClient] getAllPhotosWithSuccess:^(id responseObject) {
        
        NSDictionary *result = responseObject;
        
        if ([result[RES_KEY_SUCCESS] isEqualToNumber:RES_VALUE_SUCCESS]) {
            
            [[DisplayToast sharedManager] dismiss];
            
            NSArray *ones = result[RES_KEY_PHOTOS];
            
            for (NSDictionary *one in ones) {
                
                Photo *photo = [Photo new];
                photo.photoUrl = one[PARAM_URL];
                photo.photoId = [one[PARAM_ID] longLongValue];
                
                [photos addObject:photo];
            }
            
            [_collectionView reloadData];
            
        } else {
            [[DisplayToast sharedManager] dismiss];
            [[DisplayToast sharedManager] showErrorWithStatus:result[RES_KEY_ERROR]];
        }
        
    } failure:^(NSError *error) {
        [[DisplayToast sharedManager] dismiss];
        [[DisplayToast sharedManager] showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - Collection View Data Source / Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return photos.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat size = (self.view.frame.size.width - 40) / 3;
    
    return CGSizeMake(size, size);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell.ivPhoto sd_cancelCurrentImageLoad];
    [cell.ivPhoto removeActivityIndicator];
    cell.ivPhoto.image = nil;
    
    [cell.ivPhoto setImageWithURL:[NSURL URLWithString:[photos[indexPath.row] photoUrl]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    if (isEditMode)
        cell.btnRemove.hidden = NO;
    else
        cell.btnRemove.hidden = YES;
    
    cell.delegate = self;
    
    return cell;
}

#pragma mark - Action Delegate

- (IBAction)actionAddPhoto:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        [alert addAction:[UIAlertAction actionWithTitle:@"From camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self pickPhoto:UIImagePickerControllerSourceTypeCamera];
        }]];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        [alert addAction:[UIAlertAction actionWithTitle:@"From photo library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self pickPhoto:UIImagePickerControllerSourceTypePhotoLibrary];
        }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (IBAction)actionEditDone:(id)sender {
    
    isEditMode = !isEditMode;
    
    if (isEditMode) {
        
        _viewAdd.hidden = YES;
        _lblEditDone.text = @"DONE";
    } else {
        
        _viewAdd.hidden = NO;
        _lblEditDone.text = @"EDIT";
    }
    
    [_collectionView reloadData];
}

#pragma mark - Pick Photo

- (void)pickPhoto:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
    
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - Image Picker Controller Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *originalImage, *editedImage, *imageToUse;
    
    editedImage = (UIImage *) [info objectForKey:
                               UIImagePickerControllerEditedImage];
    originalImage = (UIImage *) [info objectForKey:
                                 UIImagePickerControllerOriginalImage];
    
    if (editedImage) {
        imageToUse = editedImage;
    } else {
        imageToUse = originalImage;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = imageToUse;
    
    controller.keepingCropAspectRatio = YES;
    // e.g.) Cropping center square
    CGFloat width = imageToUse.size.width;
    CGFloat height = imageToUse.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentViewController:navigationController animated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PECropView Controller Delegate

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage {
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    [[DisplayToast sharedManager] showWithStatus:@"Uploading..."];
    
    [[WebServiceClient sharedClient] addPhoto:[croppedImage dataOfCustomImageSize:CGSizeMake(270, 270)] success:^(id responseObject) {
        
        NSDictionary *result = responseObject;
        
        if ([result[RES_KEY_SUCCESS] isEqualToNumber:RES_VALUE_SUCCESS]) {
            
            [[DisplayToast sharedManager] dismiss];
            
            Photo *photo = [Photo new];
            photo.photoUrl = result[PARAM_URL];
            photo.photoId = [result[PARAM_ID] longLongValue];
            
            [photos addObject:photo];
            
            [_collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:photos.count - 1 inSection:0]]];
            
        } else {
            [[DisplayToast sharedManager] dismiss];
            [[DisplayToast sharedManager] showErrorWithStatus:result[RES_KEY_ERROR]];
        }
        
    } failure:^(NSError *error) {
        [[DisplayToast sharedManager] dismiss];
        [[DisplayToast sharedManager] showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Photo Cell Delegate

- (void)actionRemove:(PhotoCell *)cell {
    
    if (photos.count == 3) {
        
        [[DisplayToast sharedManager] showInfoWithStatus:@"Cannot delete the last 3 remaining photo."];
    } else {
        
        NSIndexPath *idxPath = [_collectionView indexPathForCell:cell];
        
        Photo *photo = photos[idxPath.row];
        
        if ([[AccountManager sharedManager].picture isEqualToString:photo.photoUrl]) {
            
            [[DisplayToast sharedManager] showInfoWithStatus:@"Cannot delete as the current photo is a profile one now."];
            
            return;
        }
    
        [[WebServiceClient sharedClient] removePhoto:photo.photoId success:^(id responseObject) {
            
            NSLog(@"%@", responseObject);
        } failure:^(NSError *error) {
            
            NSLog(@"%@", error.localizedDescription);
        }];
        
        [photos removeObject:photo];
        [_collectionView deleteItemsAtIndexPaths:@[idxPath]];
    }
}

@end

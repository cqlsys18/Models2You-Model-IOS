//
//  SelectPhotoVC.m
//  Models2You-Model
//
//  Created by user on 11/7/15.
//  Copyright © 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "SelectPhotoVC.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import "WebServiceClient.h"
#import "Photo.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "Utils.h"
#import "DisplayToast.h"

@interface SelectPhotoVC ()

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic) NSUInteger selectedIdx;

@end

@implementation SelectPhotoVC

@synthesize photos, selectedIdx;

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
    
    _collectionView.allowsSelection = YES;
    
    [self.view removeGestureRecognizer:self.recognizer];
}

- (void)loadData {
    
    photos = [NSMutableArray array];
    selectedIdx = -1;
    
    [[DisplayToast sharedManager] showWithStatus:@"Loading..."];
    
    [[WebServiceClient sharedClient] getAllPhotosWithSuccess:^(id responseObject) {
        
        NSDictionary *result = responseObject;
        
        if ([result[RES_KEY_SUCCESS] isEqualToNumber:RES_VALUE_SUCCESS]) {
            
            [[DisplayToast sharedManager] dismiss];
            
            NSArray *ones = result[RES_KEY_PHOTOS];
            
            NSUInteger idx = 0;
            
            for (NSDictionary *one in ones) {
                
                Photo *photo = [Photo new];
                photo.photoUrl = one[PARAM_URL];
                photo.photoId = [one[PARAM_ID] longLongValue];
                
                [photos addObject:photo];
                
                if (selectedIdx == -1 && [self.strPicture isEqualToString:photo.photoUrl])
                    selectedIdx = idx;
                
                idx++;
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
    
    if (indexPath.row == selectedIdx)
        [cell.btnCheckUncheck setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
    else
        [cell.btnCheckUncheck setImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    
    cell.delegate = self;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedIdx = indexPath.row;
    
    [_collectionView reloadData];
}

#pragma mark - Action Delegate

- (IBAction)actionCancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionDone:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.delegate photoPicked:[photos[selectedIdx] photoUrl]];
}

#pragma mark - Photo Cell Delegate

- (void)actionCheckUncheck:(PhotoCell *)cell {
    
    NSIndexPath *idxPath = [_collectionView indexPathForCell:cell];
    
    selectedIdx = idxPath.row;
    
    [_collectionView reloadData];
}

@end

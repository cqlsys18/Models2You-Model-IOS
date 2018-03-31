//
//  SignupVC.m
//  Models2You-Model
//
//  Created by user on 9/18/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "SignupVC.h"

#import "UITextField+Custom.h"
#import "NSString+emailValidation.h"
#import "SVProgressHUD.h"
#import "WebServiceClient.h"
#import "AccountManager.h"
#import "UIImage+dataOfCustomSize.h"
#import "NSDate+Custom.h"
#import <AFNetworking/AFNetworking.h>
#import "Utils.h"

#import "DisplayToast.h"

#define PHOTO_OPTION_1 1000
#define PHOTO_OPTION_2 2000
#define PHOTO_OPTION_3 3000
#define PHOTO_OPTION_4 4000
#define SCREEN_SIZE             [[UIScreen mainScreen]bounds].size
@interface SignupVC ()
{
    UIPickerView *countryCodePV;
    NSArray *countryNameArr;
    NSArray *countryAreaCodeArr;
    NSString *countryCodeStr;
    NSString * phoneStr;
    NSString *countryStr;
}
@property (nonatomic) BOOL photoPicked;
@property (nonatomic) BOOL photoPickedOption1;
@property (nonatomic) BOOL photoPickedOption2;
@property (nonatomic) BOOL photoPickedOption3;
@property NSInteger photoPickupIndex;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSString *strMessage;
@property (strong, nonatomic) IBOutlet UITextField *countryCodeTF;

@property (weak, nonatomic) IBOutlet UIButton *btnTerms;

- (IBAction)actionTerms:(id)sender;

@end

@implementation SignupVC

@synthesize dateFormatter, strMessage;

- (void)viewDidLoad {
    [super viewDidLoad];
    countryCodePV = [[UIPickerView alloc]init];
    countryCodePV.delegate = self;
    //   countryTF.userInteractionEnabled = NO;
    _countryCodeTF.inputView  = countryCodePV;
    countryNameArr = @[ @"Afghanistan", @"Albania",@"Algeria", @"Andorra", @"Angola", @"Antarctica", @"Argentina",@"Armenia", @"Aruba", @"Australia", @"Austria", @"Azerbaijan",@"Bahrain", @"Bangladesh", @"Belarus", @"Belgium", @"Belize", @"Benin",@"Bhutan", @"Bolivia", @"Bosnia And Herzegovina", @"Botswana",@"Brazil", @"Brunei Darussalam", @"Bulgaria", @"Burkina Faso",@"Myanmar", @"Burundi", @"Cambodia", @"Cameroon", @"Canada",@"Cape Verde", @"Central African Republic", @"Chad", @"Chile", @"China",@"Christmas Island", @"Cocos (keeling) Islands", @"Colombia",@"Comoros", @"Congo", @"Cook Islands", @"Costa Rica", @"Croatia",@"Cuba", @"Cyprus", @"Czech Republic", @"Denmark", @"Djibouti",@"Timor-leste", @"Ecuador", @"Egypt", @"El Salvador",
                        @"Equatorial Guinea", @"Eritrea", @"Estonia", @"Ethiopia",@"Falkland Islands (malvinas)", @"Faroe Islands", @"Fiji", @"Finland",
                        @"France", @"French Polynesia", @"Gabon", @"Gambia", @"Georgia",
                        @"Germany", @"Ghana", @"Gibraltar", @"Greece", @"Greenland",
                        @"Guatemala", @"Guinea", @"Guinea-bissau", @"Guyana", @"Haiti",
                        @"Honduras", @"Hong Kong", @"Hungary", @"India",@"Indonesia",@"Iran",
                        @"Iraq", @"Ireland", @"Isle Of Man", @"Israel", @"Italy", @"Ivory Coast",@"Jamaica", @"Japan", @"Jordan", @"Kazakhstan", @"Kenya", @"Kiribati",@"Kuwait", @"Kyrgyzstan", @"Laos", @"Latvia", @"Lebanon", @"Lesotho",@"Liberia", @"Libya", @"Liechtenstein", @"Lithuania", @"Luxembourg",@"Macao", @"Macedonia", @"Madagascar", @"Malawi", @"Malaysia",@"Maldives", @"Mali", @"Malta", @"Marshall Islands", @"Mauritania",@"Mauritius", @"Mayotte", @"Mexico", @"Micronesia", @"Moldova",@"Monaco", @"Mongolia", @"Montenegro", @"Morocco", @"Mozambique",@"Namibia", @"Nauru", @"Nepal", @"Netherlands", @"New Caledonia",@"New Zealand", @"Nicaragua", @"Niger", @"Nigeria", @"Niue", @"Korea",@"Norway", @"Oman", @"Pakistan", @"Palau", @"Panama",@"Papua New Guinea", @"Paraguay", @"Peru", @"Philippines", @"Pitcairn",@"Poland", @"Portugal", @"Puerto Rico", @"Qatar", @"Romania",@"Russian Federation", @"Rwanda", @"Saint Barthélemy", @"Samoa",@"San Marino", @"Sao Tome And Principe", @"Saudi Arabia", @"Senegal",
                        @"Serbia", @"Seychelles", @"Sierra Leone",@"Singapore", @"Slovakia",@"Slovenia", @"Solomon Islands", @"Somalia", @"South Africa",@"Korea, Republic Of", @"Spain", @"Sri Lanka", @"Saint Helena",@"Saint Pierre And Miquelon", @"Sudan", @"Suriname", @"Swaziland",@"Sweden", @"Switzerland", @"Syrian Arab Republic", @"Taiwan",@"Tajikistan", @"Tanzania", @"Thailand", @"Togo", @"Tokelau", @"Tonga",
                        @"Tunisia", @"Turkey", @"Turkmenistan", @"Tuvalu",@"United Arab Emirates", @"Uganda", @"United Kingdom", @"Ukraine",
                        @"Uruguay", @"United States", @"Uzbekistan", @"Vanuatu",
                        @"Holy See (vatican City State)", @"Venezuela", @"Viet Nam",
                        @"Wallis And Futuna", @"Yemen", @"Zambia", @"Zimbabwe" ];
    
    
    countryAreaCodeArr = @[ @"93",@"355",@"213",
                            @"376",@"244",@"672",@"54",@"374",@"297",@"61",@"43",@"994",@"973",
                            @"880",@"375",@"32",@"501",@"229",@"975",@"591",@"387",@"267",@"55",
                            @"673",@"359",@"226",@"95",@"257",@"855",@"237",@"1",@"238",@"236",
                            @"235",@"56",@"86",@"61",@"61",@"57",@"269",@"242",@"682",@"506",
                            @"385",@"53",@"357",@"420",@"45",@"253",@"670",@"593",@"20",@"503",
                            @"240",@"291",@"372",@"251",@"500",@"298",@"679",@"358",@"33",
                            @ "689",@"241",@"220",@"995",@"49",@"233",@"350",@"30",@"299",@"502",
                            @ "224",@"245",@"592",@"509",@"504",@"852",@"36",@"91",@"62",@"98",
                            @"964",@"353",@"44",@"972",@"39",@"225",@"1876",@"81",@"962",@"7",
                            @"254",@"686",@"965",@"996",@"856",@"371",@"961",@"266",@"231",
                            @ "218",@"423",@"370",@"352",@"853",@"389",@"261",@"265",@"60",
                            @"960",@"223",@"356",@"692",@"222",@"230",@"262",@"52",@"691",
                            @"373",@"377",@"976",@"382",@"212",@"258",@"264",@"674",@"977",
                            @ "31",@"687",@"64",@"505",@"227",@"234",@"683",@"850",@"47",@"968",
                            @"92",@"680",@"507",@"675",@"595",@"51",@"63",@"870",@"48",@"351",
                            @"1",@"974",@"40",@"7",@"250",@"590",@"685",@"378",@"239",@"966",
                            @"221",@"381",@"248",@"232",@"65",@"421",@"386",@"677",@"252",@"27",
                            @"82",@"34",@"94",@"290",@"508",@"249",@"597",@"268",@"46",@"41",
                            @"963",@"886",@"992",@"255",@"66",@"228",@"690",@"676",@"216",@"90",
                            @"993",@"688",@"971",@"256",@"44",@"380",@"598",@"1",@"998",@"678",
                            @ "39",@"58",@"84",@"681",@"967",@"260",@"263" ];
    // Do any additional setup after loading the view.
    
    [self initData];
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

- (void)initData {
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.locale = [NSLocale currentLocale];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
}

- (void)initUI {
    
    [super initUI];
    
    [_btnTerms setAttributedTitle:[[NSAttributedString alloc] initWithString:_btnTerms.titleLabel.text attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}] forState:UIControlStateNormal];
    
    //[_txtRate setPlaceholderColor:[UIColor whiteColor]];
    [_txtPassword setPlaceholderColor:[UIColor whiteColor]];
    [_txtEmail setPlaceholderColor:[UIColor whiteColor]];
    [_txtConfirmPassword setPlaceholderColor:[UIColor whiteColor]];
    [_txtName setPlaceholderColor:[UIColor whiteColor]];
    [_txtAddress setPlaceholderColor:[UIColor whiteColor]];
    [_txtCity setPlaceholderColor:[UIColor whiteColor]];
    [_txtState setPlaceholderColor:[UIColor whiteColor]];
    [_txtZipCode setPlaceholderColor:[UIColor whiteColor]];
    [_txtPhone setPlaceholderColor:[UIColor whiteColor]];
    [_txtBirthday setPlaceholderColor:[UIColor whiteColor]];
    [_txtEyeColor setPlaceholderColor:[UIColor whiteColor]];
    [_txtHairColor setPlaceholderColor:[UIColor whiteColor]];
    [_txtHeight setPlaceholderColor:[UIColor whiteColor]];
    [_txtFavorites setPlaceholderColor:[UIColor whiteColor]];
    [_txtInstagram setPlaceholderColor:[UIColor whiteColor]];
    [_txtFacebook setPlaceholderColor:[UIColor whiteColor]];
    
    _datePicker.locale = [NSLocale currentLocale];
}

#pragma mark - Tap Gesture Delegate

- (void)tapGestureRecognized:(UIGestureRecognizer *)recognizer {
    [super tapGestureRecognized:nil];
    
    [self setHeightPickerHidden:YES];
    [self setDatePickerHidden:YES];
    
    [[DisplayToast sharedManager] dismiss];
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _txtEmail)
        [_txtPassword becomeFirstResponder];
    else if (textField == _txtPassword)
        [_txtConfirmPassword becomeFirstResponder];
    else if (textField == _txtConfirmPassword)
        [_txtName becomeFirstResponder];
    else if (textField == _txtName)
          [_txtAddress becomeFirstResponder];
      //  [_txtRate becomeFirstResponder];
    //else if (textField == _txtRate)
      //  [_txtAddress becomeFirstResponder];
    else if (textField == _txtAddress)
        [_txtCity becomeFirstResponder];
    else if (textField == _txtCity)
        [_txtState becomeFirstResponder];
    else if (textField == _txtState)
        [_txtZipCode becomeFirstResponder];
    else if (textField == _txtZipCode)
        [_txtPhone becomeFirstResponder];
    else if (textField == _txtPhone)
        [_txtEyeColor becomeFirstResponder];
    else if (textField == _txtEyeColor)
        [_txtHairColor becomeFirstResponder];
    else if (textField == _txtHairColor)
        [_txtFavorites becomeFirstResponder];
    else if (textField == _txtInstagram)
        [_txtFavorites becomeFirstResponder];
    else if (textField == _txtFacebook)
        [_txtFavorites becomeFirstResponder];
    else
        [textField resignFirstResponder];
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [super textFieldDidBeginEditing:textField];
    
    [self setDatePickerHidden:YES];
    [self setHeightPickerHidden:YES];
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
    
    if(self.photoPickupIndex == PHOTO_OPTION_1){
        _ivProfile.image = imageToUse;
        self.photoPicked = YES;
    }else if(self.photoPickupIndex == PHOTO_OPTION_2){
        _ivProfileOption1.image = imageToUse;
        self.photoPickedOption1 = YES;
    }else if(self.photoPickupIndex == PHOTO_OPTION_3){
        _ivProfileOption2.image = imageToUse;
        self.photoPickedOption2 = YES;
    }else if(self.photoPickupIndex == PHOTO_OPTION_4){
        _ivProfileOption3.image = imageToUse;
        self.photoPickedOption3 = YES;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
//    PECropViewController *controller = [[PECropViewController alloc] init];
//   // controller.delegate = self;
//    controller.image = imageToUse;
//
//    controller.keepingCropAspectRatio = NO;
//    // e.g.) Cropping center square
//    CGFloat width = imageToUse.size.width;
//    CGFloat height = imageToUse.size.height;
//    CGFloat length = MIN(width, height);
//    controller.imageCropRect = CGRectMake((width - length) / 2,
//                                          (height - length) / 2,
//                                          length,
//                                          length);
//    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
//    [self.navigationController presentViewController:navigationController animated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PECropView Controller Delegate

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage {
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    if(self.photoPickupIndex == PHOTO_OPTION_1){
        _ivProfile.image = croppedImage;
        self.photoPicked = YES;
    }else if(self.photoPickupIndex == PHOTO_OPTION_2){
        _ivProfileOption1.image = croppedImage;
        self.photoPickedOption1 = YES;
    }else if(self.photoPickupIndex == PHOTO_OPTION_3){
        _ivProfileOption2.image = croppedImage;
        self.photoPickedOption2 = YES;
    }else if(self.photoPickupIndex == PHOTO_OPTION_4){
        _ivProfileOption3.image = croppedImage;
        self.photoPickedOption3 = YES;
    }
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Action Delegate

- (IBAction)heightDoneButtonAction:(id)sender
{
    [self setHeightPickerHidden:YES];
}

- (IBAction)datedoneButtonAction:(id)sender
{
    [self setDatePickerHidden:YES];
}


- (IBAction)actionPhoto:(id)sender {
    self.photoPickupIndex = ((UIButton*)sender).tag;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        [alert addAction:[UIAlertAction actionWithTitle:@"From camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
          //  [self pickPhoto:UIImagePickerControllerSourceTypeCamera];
            UIImagePickerController * imagePickerController= [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }]];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        [alert addAction:[UIAlertAction actionWithTitle:@"From photo library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
          //  [self pickPhoto:UIImagePickerControllerSourceTypePhotoLibrary];
            UIImagePickerController * imagePickerController= [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (IBAction)actionBirthday:(id)sender {
    [self.view endEditing:YES];
    [self setHeightPickerHidden:YES];
    [self setDatePickerHidden:NO];
}

- (IBAction)actionDone:(id)sender {
    
    countryCodeStr = [NSString stringWithFormat:@"%@%@",countryStr,_txtPhone.text];
    phoneStr = [NSString stringWithFormat:@"%@", countryCodeStr];
    
   // AppDelegate * delegate =(AppDelegate*) [UIApplication sharedApplication].delegate;
  // UIViewController *views        = [self.storyboard instantiateViewControllerWithIdentifier:@"FormOneVC"];
// [self.navigationController pushViewController:views animated:YES];
    if ([self signupFormIsValid]) {
         if(!self.photoPickedOption1){
            if(self.photoPickedOption2){
                _ivProfileOption1.image = _ivProfileOption2.image;
            }else if(self.photoPickedOption3){
                _ivProfileOption1.image = _ivProfileOption3.image;
            }
            self.photoPickedOption1 = YES;
            self.photoPickedOption2 = NO;
        }
        if(!self.photoPickedOption2 && self.photoPickedOption1){
            if(self.photoPickedOption3){
                _ivProfileOption2.image = _ivProfileOption3.image;
            }
            self.photoPickedOption2 = YES;
            self.photoPickedOption3 = NO;
        }
        if(!self.photoPickedOption1 && self.photoPickedOption3){
            if(self.photoPickedOption2){
                _ivProfileOption1.image = _ivProfileOption3.image;
            }
            self.photoPickedOption3 = YES;
            self.photoPickedOption1 = NO;
        }
        
//       NSString * heightFootStr = [NSString stringWithFormat:@"%ld",[_heightPicker selectedRowInComponent:0]+4];
//        NSString * heightInchStr = [NSString stringWithFormat:@"%ld",(long)[_heightPicker selectedRowInComponent:1]];
//        NSMutableDictionary * signUpDic = [[NSMutableDictionary alloc]init];
//        [signUpDic setObject:_txtEmail.text forKey:@"email"];
//        [signUpDic setObject:_txtPassword.text forKey:@"pass"];
//        [signUpDic setObject:[_ivProfile.image dataOfCustomImageSize:CGSizeMake(270, 270)] forKey:@"photo"];
//        [signUpDic setObject:[_ivProfileOption1.image dataOfCustomImageSize:CGSizeMake(SERVER_UPLOAD_IMAGE_SIZE, SERVER_UPLOAD_IMAGE_SIZE)] forKey:@"picOne"];
//        [signUpDic setObject:[_ivProfileOption2.image dataOfCustomImageSize:CGSizeMake(SERVER_UPLOAD_IMAGE_SIZE, SERVER_UPLOAD_IMAGE_SIZE)] forKey:@"picTwo"];
//        [signUpDic setObject:[_ivProfileOption3.image dataOfCustomImageSize:CGSizeMake(SERVER_UPLOAD_IMAGE_SIZE, SERVER_UPLOAD_IMAGE_SIZE)] forKey:@"picThree"];
//        [signUpDic setObject:_txtName.text forKey:@"name"];
//        [signUpDic setObject:_txtAddress.text forKey:@"address"];
//        [signUpDic setObject:_txtCity.text forKey:@"city"];
//        [signUpDic setObject:_txtState.text forKey:@"state"];
//        [signUpDic setObject:_txtZipCode.text forKey:@"zipcode"];
//        [signUpDic setObject:_txtPhone.text forKey:@"phone"];
//        [signUpDic setObject:[NSDate mysqlDateStringFromDate:_datePicker.date] forKey:@"dob"];
//        [signUpDic setObject:_txtEyeColor.text forKey:@"eyeColor"];
//        [signUpDic setObject:_txtHairColor.text forKey:@"hairColor"];
//        [signUpDic setObject: heightFootStr forKey:@"heightFoot"];
//        [signUpDic setObject: heightInchStr forKey:@"heightInch"];
//        [signUpDic setObject:_txtFavorites.text forKey:@"favorites"];
//        [signUpDic setObject:_txtInstagram.text forKey:@"instagramId"];
//        [signUpDic setObject:_txtFacebook.text forKey:@"facebookId"];
//        [delegate.signUpDataDic setObject:signUpDic forKey:@"signDic"];
        
//        UIViewController *views        = [self.storyboard instantiateViewControllerWithIdentifier:@"FormOneVC"];
//        [self.navigationController pushViewController:views animated:YES];
        
//  [self.navigationController popViewControllerAnimated:YES];
//        [[WebServiceClient sharedClient] registerWithEmail:_txtEmail.text
//                                                  password:_txtPassword.text
//                                                     photo:[_ivProfile.image dataOfCustomImageSize:CGSizeMake(270, 270)]
//                                              photoOption1:self.photoPickedOption1 ? [_ivProfileOption1.image dataOfCustomImageSize:CGSizeMake(SERVER_UPLOAD_IMAGE_SIZE, SERVER_UPLOAD_IMAGE_SIZE)] : nil
//                                              photoOption2: self.photoPickedOption2 ? [_ivProfileOption2.image dataOfCustomImageSize:CGSizeMake(SERVER_UPLOAD_IMAGE_SIZE, SERVER_UPLOAD_IMAGE_SIZE)] : nil
//                                              photoOption3:self.photoPickedOption3 ? [_ivProfileOption3.image dataOfCustomImageSize:CGSizeMake(SERVER_UPLOAD_IMAGE_SIZE, SERVER_UPLOAD_IMAGE_SIZE)] : nil
//                                                      name:_txtName.text
//                                                      //rate:[_txtRate.text floatValue]
//                                                    rate:50.0 //[CHANGE_REQUEST: 04-Aug-16]: Remove Rate per hour from screen and send it hardcoded
//                                                   address:_txtAddress.text
//                                                      city:_txtCity.text
//                                                     state:_txtState.text
//                                                   zipcode:_txtZipCode.text
//                                                     phone:_txtPhone.text
//                                                       dob:[NSDate mysqlDateStringFromDate:_datePicker.date]
//                                                  eyeColor:_txtEyeColor.text
//                                                 hairColor:_txtHairColor.text
//                                                heightFoot:[_heightPicker selectedRowInComponent:0] + 4
//                                                heightInch:[_heightPicker selectedRowInComponent:1]
//                                                 favorites:_txtFavorites.text
//                                               instagramId:_txtInstagram.text
//                                                facebookId:_txtFacebook.text
//                                                   success:^(id responseObject)
//
//
//
         [[WebServiceClient sharedClient]registerWithEmail:_txtEmail.text password:_txtPassword.text photo:[_ivProfile.image dataOfCustomImageSize:CGSizeMake(270, 270)] photoOption1:self.photoPickedOption1 ? [_ivProfileOption1.image dataOfCustomImageSize:CGSizeMake(SERVER_UPLOAD_IMAGE_SIZE, SERVER_UPLOAD_IMAGE_SIZE)] : nil photoOption2:self.photoPickedOption2 ? [_ivProfileOption2.image dataOfCustomImageSize:CGSizeMake(SERVER_UPLOAD_IMAGE_SIZE, SERVER_UPLOAD_IMAGE_SIZE)] : nil photoOption3:self.photoPickedOption3 ? [_ivProfileOption3.image dataOfCustomImageSize:CGSizeMake(SERVER_UPLOAD_IMAGE_SIZE, SERVER_UPLOAD_IMAGE_SIZE)] : nil name:_txtName.text rate:50.0 address:_txtAddress.text city:_txtCity.text state:_txtState.text zipcode:_txtZipCode.text phone:phoneStr dob:[NSDate mysqlDateStringFromDate:_datePicker.date] eyeColor:_txtEyeColor.text hairColor:_txtHairColor.text heightFoot:[_heightPicker selectedRowInComponent:0] + 4 heightInch:[_heightPicker selectedRowInComponent:1] favorites:_txtFavorites.text instagramId:_txtInstagram.text facebookId:_txtFacebook.text pdf:nil success:^(id responseObject)
      {
           NSDictionary *result = responseObject;

            if ([result[RES_KEY_SUCCESS] isEqualToNumber:RES_VALUE_SUCCESS]) {
                [[DisplayToast sharedManager] dismiss];
                [[DisplayToast sharedManager] showInfoWithStatus:@"Registered successfully."];

//                UIViewController *views        = [self.storyboard instantiateViewControllerWithIdentifier:@"FormOneVC"];
//                [self.navigationController pushViewController:views animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [[DisplayToast sharedManager] dismiss];
                [[DisplayToast sharedManager] showErrorWithStatus:[NSString stringWithFormat:@"%@ %@", result[RES_KEY_ERROR], result[RES_KEY_ERROR_MESSAGES]]];
            }
        } failure:^(NSError *error) {
            [[DisplayToast sharedManager] dismiss];
            [[DisplayToast sharedManager] showErrorWithStatus:error.localizedDescription];

            NSError *underlyingError = error.userInfo[@"NSUnderlyingError"];

            NSLog(@"%@", [[NSString alloc] initWithData:underlyingError.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]);
        }];
    }
    else{
        [[DisplayToast sharedManager] showInfoWithStatus:strMessage];
    }
}

- (IBAction)actionDatePicked:(id)sender {
    _txtBirthday.text = [dateFormatter stringFromDate:_datePicker.date];
}

- (IBAction)actionHeight:(id)sender {
    [self.view endEditing:YES];
    [self setDatePickerHidden:YES];
    [self setHeightPickerHidden:NO];
}

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionTerms:(id)sender {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

//#pragma mark - Picker View Data Source
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    if (pickerView == countryCodePV)
//    {
//        return 1;
//    }
//    else
//    {
//         return 2;
//    }
//
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    if (pickerView == countryCodePV)
//    {
//        return [countryNameArr count];
//    }
//    else
//    {
//        if (component == 0)
//            return 3;
//        return 12;
//    }
//
//}
//
//#pragma mark - Picker View Delegate
//
////- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
////    if (pickerView == countryCodePV)
////    {
////
////    }
////    else
////    {
////
////    }
////
////}
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    if (pickerView == countryCodePV)
//    {
//        UIView * PickerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 40)];
//        //UIImageView * pickerimg = [[UIImageView alloc]initWithFrame:CGRectMake(40, 7, 27, 27)];
//       // pickerimg.image = [UIImage imageNamed:[countryFlagArr objectAtIndex:row]];
//       // pickerimg.contentMode = UIViewContentModeCenter;
//       // [PickerView addSubview:pickerimg];
//
//        UILabel * pickerimg1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 7, 40, 25)];
//        pickerimg1.text =[countryAreaCodeArr objectAtIndex:row];
//
//        UILabel * pickerimg2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width/2, 7, SCREEN_SIZE.width/2, 25)];
//        pickerimg2.text =[countryNameArr objectAtIndex:row];
//        [PickerView addSubview:pickerimg2];
//
//        [PickerView addSubview:pickerimg1];
//        return PickerView;
//
//    }
//    else
//    {
//        return [NSString stringWithFormat:@"%ld'", row + 4];
//        return [NSString stringWithFormat:@"%ld\"", (long)row];
//    }
//
//}
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    if (pickerView == countryCodePV)
//    {
//        NSString *countryStr = [countryNameArr objectAtIndex:row];
//        _countryCodeTF.text = countryStr;
//        countryCodeStr = [countryAreaCodeArr objectAtIndex:row];
//        phoneStr = [NSString stringWithFormat:@" (+%@)", countryCodeStr];
//    }
//    else
//    {
//        int foot = [pickerView selectedRowInComponent:0] + 4;
//        int inch = [pickerView selectedRowInComponent:1];
//        _txtHeight.text = [NSString stringWithFormat:@"%d' %d\"", foot, inch];
//    }
//
//}
#pragma mark - Picker View Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == countryCodePV)
            {
                return 1;
            }
            else
            {
                 return 2;
            }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == countryCodePV)
            {
                return [countryNameArr count];
            }
            else
            {
                if (component == 0)
                    return 3;
                return 12;
            }
}

#pragma mark - Picker View Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == countryCodePV)
    {
//        UIView * PickerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 40)];
//        //        //UIImageView * pickerimg = [[UIImageView alloc]initWithFrame:CGRectMake(40, 7, 27, 27)];
//        //       // pickerimg.image = [UIImage imageNamed:[countryFlagArr objectAtIndex:row]];
//        //       // pickerimg.contentMode = UIViewContentModeCenter;
//        //       // [PickerView addSubview:pickerimg];
//        //
//                UILabel * pickerimg1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 7, 40, 25)];
//                pickerimg1.text =[countryAreaCodeArr objectAtIndex:row];
//
//                UILabel * pickerimg2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width/2, 7, SCREEN_SIZE.width/2, 25)];
//                pickerimg2.text =[countryNameArr objectAtIndex:row];
//                [PickerView addSubview:pickerimg2];
//
//                [PickerView addSubview:pickerimg1];
               // return PickerView;
        return [NSString stringWithFormat:@"+%@(%@)",[countryAreaCodeArr objectAtIndex:row],[countryNameArr objectAtIndex:row]];
    }
    else
    {
        if (component == 0)
            return [NSString stringWithFormat:@"%d'", row + 4];
        return [NSString stringWithFormat:@"%d\"", row];
    }
   
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == countryCodePV)
            {
                countryStr = [NSString stringWithFormat:@"+%@",[countryAreaCodeArr objectAtIndex:row]];
                _countryCodeTF.text = countryStr;
               
            }
            else
            {
                int foot = [pickerView selectedRowInComponent:0] + 4;
                int inch = [pickerView selectedRowInComponent:1];
                _txtHeight.text = [NSString stringWithFormat:@"%d' %d\"", foot, inch];
            }
    
}
#pragma mark - Pick Photo

- (void)pickPhoto:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - Date Picker Show/Hide

- (void)setDatePickerHidden:(BOOL)hidden
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = _viewDatePicker.frame;
        if (hidden) {
            frame.origin.y = self.view.frame.size.height;
            _datePickerTopSpacingConstraint.constant = 0;
        } else {
            frame.origin.y = self.view.frame.size.height - frame.size.height;
            _datePickerTopSpacingConstraint.constant = -frame.size.height;
        }
        _viewDatePicker.frame = frame;
    }];
}

#pragma mark - Height Picker Show/Hide

- (void)setHeightPickerHidden:(BOOL)hidden {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = _viewHeightPicker.frame;
        if (hidden) {
            frame.origin.y = self.view.frame.size.height;
            _heightPickerTopSpacingConstraint.constant = 0;
        } else {
            frame.origin.y = self.view.frame.size.height - frame.size.height;
            _heightPickerTopSpacingConstraint.constant = -frame.size.height;
        }
        _viewHeightPicker.frame = frame;
    }];
}

#pragma mark - Form Validation

- (BOOL)signupFormIsValid {
    if (!self.photoPicked)
        strMessage = @"Please input photo.";
//    else if (!((self.photoPickedOption1 && self.photoPickedOption2) || (self.photoPickedOption1 && self.photoPickedOption3) || (self.photoPickedOption2 && self.photoPickedOption3)))
//        strMessage = @"Please input 3 optional photos.";
    
    else if ((!self.photoPickedOption1) || (!self.photoPickedOption2) || (!self.photoPickedOption3))
        strMessage = @"Please input 3 optional photos.";
    else if ([_txtEmail.text isEqualToString:@""])
        strMessage = @"Please input email address.";
    else if (![_txtEmail.text isValidEmail])
        strMessage = @"Invalid email address";
    else if ([_txtPassword.text isEqualToString:@""])
        strMessage = @"Please input password.";
    else if ([_txtConfirmPassword.text isEqualToString:@""])
        strMessage = @"Please input confirm password.";
    else if (![_txtPassword.text isEqualToString:_txtConfirmPassword.text])
        strMessage = @"Passwords don't match.";
    else if ([_txtName.text isEqualToString:@""])
        strMessage = @"Please input name.";
    //else if ([_txtRate.text isEqualToString:@""])
    //    strMessage = @"Please input hourly rate.";
    //else if ([_txtRate.text componentsSeparatedByString:@"."].count > 2)
      //  strMessage = @"Invalid hourly rate.";
    //else if ([_txtRate.text floatValue] < 50)
      //  strMessage = @"Hourly rate cannot be lower than $50.";
    else if ([_txtAddress.text isEqualToString:@""])
        strMessage = @"Please input address.";
    else if ([_txtCity.text isEqualToString:@""])
        strMessage = @"Please input city.";
    else if ([_txtState.text isEqualToString:@""])
        strMessage = @"Please input state.";
    else if ([_txtZipCode.text isEqualToString:@""])
        strMessage = @"Please input zipcode.";
    else if ([_txtPhone.text isEqualToString:@""])
        strMessage = @"Please input phone number.";
    else if ([_txtBirthday.text isEqualToString:@""])
        strMessage = @"Please input your date of birth.";
    else if ([_txtEyeColor.text isEqualToString:@""])
        strMessage = @"Please input eye color.";
    else if ([_txtHairColor.text isEqualToString:@""])
        strMessage = @"Please input hair color.";
    else if ([_txtHeight.text isEqualToString:@""])
        strMessage = @"Please input height.";
    else if ([_txtHeight.text componentsSeparatedByString:@"."].count > 2)
        strMessage = @"Invalid height";
    else if ([_txtFavorites.text isEqualToString:@""])
        strMessage = @"Please input hobbies.";
    else
        return YES;
    
    return NO;
}

@end

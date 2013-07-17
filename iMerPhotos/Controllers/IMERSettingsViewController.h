//
//  IMERSettingsViewController.h
//  iMerPhotos
//
//  Created by nguyenkhoi on 6/10/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMERUtils.h"
#import "IMERNSUserDefaults.h"

@interface IMERSettingsViewController : UIViewController<UIImagePickerControllerDelegate,UITextFieldDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UINavigationBarDelegate>{
    
    __weak IBOutlet UIImageView *avatarView;
    __weak IBOutlet UITextField *usernameTxt;
    __weak IBOutlet UILabel *joinedDateLbl;
    __weak IBOutlet UIButton *changePassBtn;
    __weak IBOutlet UITextField *oldPassTxt;
    __weak IBOutlet UITextField *newPassTxt;
    __weak IBOutlet UITextField *renewPassTxt;
    __weak IBOutlet UILabel *titleLbl;
    __weak IBOutlet UINavigationItem *navItem;
    __weak IBOutlet UIBarButtonItem *cancelBarBtn;
    IBOutlet UIBarButtonItem *saveBarBtn;
    __weak IBOutlet UIButton *logoutBtn;
    
    UIImagePickerController *imagePicker;
    UIImage *image;
    NSData* imageData;
    
    BOOL isSaveClick;
    BOOL isLogoutClick;
    BOOL isChangePassClick;
}

@property (nonatomic,retain) UIImagePickerController *imagePicker;
- (IBAction)beginTouchToChangePass:(id)sender;
- (IBAction)endChangePass:(id)sender;

- (IBAction)changePassAction:(id)sender;
- (IBAction)saveBtnAction:(id)sender;
- (IBAction)logoutBtnAction:(id)sender;
- (IBAction)cancelBtnAction:(id)sender;

@end

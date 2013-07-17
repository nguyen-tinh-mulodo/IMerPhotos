//
//  IMERViewController.h
//  iMerPhotos
//
//  Created by nguyenkhoi on 6/7/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
@interface IMERViewController : UIViewController<UITextFieldDelegate,ASIHTTPRequestDelegate>{
    
   
    __weak IBOutlet UITextField *emailTxt;
    __weak IBOutlet UITextField *pwdTxt;
    __weak IBOutlet UIButton *loginbutton;
    __weak IBOutlet UIButton *signupbutton;
    __weak IBOutlet UIButton *lostPassBtn;
    __weak IBOutlet UINavigationBar *navBar;
    
    __weak IBOutlet UINavigationItem *navItem;
    NSDictionary *responseDic;
}

- (IBAction)loginBtn:(id)sender;
- (IBAction)signupBtn:(id)sender;
- (IBAction)lostPassBtn:(id)sender;





@end

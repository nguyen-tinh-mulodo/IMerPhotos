//
//  IMERSignUpViewController.h
//  iMerPhotos
//
//  Created by nguyenkhoi on 6/10/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMERUtils.h"
#import "ASIFormDataRequest.h"
@interface IMERSignUpViewController : UIViewController<ASIHTTPRequestDelegate,UIAlertViewDelegate> {
     IBOutlet UITextField *emailTextField;
     IBOutlet UITextField *passwordTextField;
     IBOutlet UITextField *rePasswordTextField;
     IBOutlet UITextField *usernameTextField;
     IBOutlet UIButton *signupButton;
     IBOutlet UIButton *cancleButton;
    __weak IBOutlet UILabel *titleLbl;
    
    __weak IBOutlet UINavigationItem *navItem;
}

-(IBAction)signupPressed:(id)sender;
-(IBAction)canclePressed:(id)sender;


@end

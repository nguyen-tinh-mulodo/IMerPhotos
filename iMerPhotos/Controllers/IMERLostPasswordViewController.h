//
//  IMERLostPasswordViewController.h
//  iMerPhotos
//
//  Created by Lại Huy Thịnh on 10/06/2013.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface IMERLostPasswordViewController : UIViewController<ASIHTTPRequestDelegate,UIAlertViewDelegate>{
    
     IBOutlet UILabel *titleLbl;
     IBOutlet UITextField *emailTxt;
     IBOutlet UIButton *requestBtn;
     IBOutlet UIButton *cancelbtn;
    UIActivityIndicatorView *spinner;
    __weak IBOutlet UINavigationBar *navBar;
    __weak IBOutlet UINavigationItem *navItem;
}

- (IBAction)requestPwdBtn:(id)sender;

@end

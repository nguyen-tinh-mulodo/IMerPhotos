//
//  IMERLostPasswordViewController.m
//  iMerPhotos
//
//  Created by Lại Huy Thịnh on 10/06/2013.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import "IMERLostPasswordViewController.h"
#import "IMERUtils.h"
#import "IMERPostData.h"
#import "Constants.h"

@interface IMERLostPasswordViewController ()

@end

@implementation IMERLostPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIFont *buttonFont = [UIFont fontWithName:FONT size:17.0];
    UIColor *buttonColorDefault = [UIColor colorWithRed:90.0f/255.0f green:90.0f/255.0f blue:90.0f/255.0f alpha:1.0];
    UIColor *buttonColorHighlight = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    
    UIImage *btn = [UIImage imageNamed:@"Button.png"];
    UIImage *btnh = [UIImage imageNamed:@"ButtonHighlighted.png"];
    
    //customize requestBtn
    [requestBtn setBackgroundImage:btn forState:UIControlStateNormal];
    [requestBtn setBackgroundImage:btnh forState:UIControlStateHighlighted];
    [requestBtn.titleLabel setFont:buttonFont];
    [requestBtn setTitleColor:buttonColorDefault forState:UIControlStateNormal];
    [requestBtn setTitleColor:buttonColorHighlight forState:UIControlStateHighlighted];
    
    //customize cancelbtn
    [cancelbtn setBackgroundImage:btn forState:UIControlStateNormal];
    [cancelbtn setBackgroundImage:btnh forState:UIControlStateHighlighted];
    [cancelbtn.titleLabel setFont:buttonFont];
    [cancelbtn setTitleColor:buttonColorDefault forState:UIControlStateNormal];
    [cancelbtn setTitleColor:buttonColorHighlight forState:UIControlStateHighlighted];
    
    
    // Add spinner for thread load data from service
    spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 225, 20, 30)];
    [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    spinner.color = [UIColor blueColor];
    spinner.hidden = true;
    [self.view addSubview:spinner];
    
    navItem.titleView = [IMERUtils myLabelWithText:@"Get Password"];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)requestPwdBtn:(id)sender{
    if ([emailTxt.text isEqualToString:@""]) {
        // Email is null - show alert
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Email is empty!\n Please enter!"
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    } else {
        if (![IMERUtils validateEmail:emailTxt.text]) {
            // Email is not valid - Show alert
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Email is invalid!\n Please enter again!"
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            
        } else {
            // Init new data post dictionary
            [self initStartPostData];
            // Init new data post
            NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
            [dataPost setValue:[[IMERPostData alloc]initWithNewData:EMAIL AndValue:emailTxt.text] forKey:@"0"];
            // Call function postDataServer to 
            [IMERUtils postDataServer:dataPost url:API_LOSTPASSWORDS controller:self];
        }
    }
}

// Init layout to stoping request service
- (void)initStartPostData{
    [requestBtn setEnabled:false];
    [emailTxt setEnabled:false];
    [cancelbtn setEnabled:false];
    spinner.hidden = false;
    [spinner startAnimating];
    
}

// Init layout to processing request service
- (void)initStopPostData{
    [requestBtn setEnabled:true];
    [emailTxt setEnabled:true];
    [cancelbtn setEnabled:true];
    spinner.hidden = true;
    [spinner stopAnimating];
    
}


//-----ASIHTTPRequest Delegate-----------
- (void) requestFinished:(ASIHTTPRequest *)request {
    NSArray *arrayResponseNotice = [IMERUtils getResponseNoticeWithRequest:request];    
    if ([[arrayResponseNotice objectAtIndex:0] isEqualToString:@"200"]) {
        // Status code 200
        [[[UIAlertView alloc] initWithTitle:[arrayResponseNotice objectAtIndex:1]
                                    message:@"Check your email to get new password"
                                   delegate:self
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];

    } else {
        // Error
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[arrayResponseNotice objectAtIndex:1]
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        
    }
    
    
      [self initStopPostData];
}
- (void) requestStarted:(ASIHTTPRequest *) request {
    NSLog(@"request started...");
}

- (void) requestFailed:(ASIHTTPRequest *) request {
    NSError *error = [request error];
    NSLog(@"%@", error);
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Request Failed!" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil]show];
    
    [self initStopPostData];
}

// Delegate UIAlertView to back home screen when request API successfully
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self performSegueWithIdentifier:@"cancelLostPasswordToLogin" sender:self];
    }
}

@end

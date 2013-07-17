//
//  IMERViewController.m
//  iMerPhotos
//
//  Created by nguyenkhoi on 6/7/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import "IMERViewController.h"
#import "Constants.h"
#import "IMERUtils.h"
#import "IMERNSUserDefaults.h"
#import "IMERPostData.h"
@interface IMERViewController ()

@end

@implementation IMERViewController

- (BOOL)isAccessibilityElement
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //emailTxt.text = [IMERNSUserDefaults getEmail];
    
    UIFont *buttonFont = [UIFont fontWithName:FONT size:17.0];
    UIColor *buttonColorDefault = [UIColor colorWithRed:90.0f/255.0f green:90.0f/255.0f blue:90.0f/255.0f alpha:1.0];
    UIColor *buttonColorHighlight = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    
    UIImage *btn = [UIImage imageNamed:@"Button.png"];
    UIImage *btnh = [UIImage imageNamed:@"ButtonHighlighted.png"];
    
    //customize login button
    [loginbutton setBackgroundImage:btn forState:UIControlStateNormal];
    [loginbutton setBackgroundImage:btnh forState:UIControlStateHighlighted];
    [loginbutton.titleLabel setFont:buttonFont];
    [loginbutton setTitleColor:buttonColorDefault forState:UIControlStateNormal];
    [loginbutton setTitleColor:buttonColorHighlight forState:UIControlStateHighlighted];
    
    //customize signup button
    [signupbutton setBackgroundImage:btn forState:UIControlStateNormal];
    [signupbutton setBackgroundImage:btnh forState:UIControlStateHighlighted];
    [signupbutton.titleLabel setFont:buttonFont];
    [signupbutton setTitleColor:buttonColorDefault forState:UIControlStateNormal];
    [signupbutton setTitleColor:buttonColorHighlight forState:UIControlStateHighlighted];
    
    navItem.titleView = [IMERUtils myLabelWithText:@"Like App"];
    [lostPassBtn.titleLabel setFont:[UIFont fontWithName:FONT size:18]];
    
    [self.view setAccessibilityLabel:@"Login Page"];
    
}



- (IBAction)emailTxtAction:(id)sender {
    [emailTxt becomeFirstResponder];
    
}
- (IBAction)emailTxtDidAction:(id)sender {
    [emailTxt resignFirstResponder];
}
- (IBAction)pwdTxtAction:(id)sender {
    [pwdTxt becomeFirstResponder];
}
- (IBAction)pwdTxtDidAction:(id)sender {
    [pwdTxt resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginProcess{
    
    NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:EMAIL AndValue:emailTxt.text] forKey:@"0"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:PASSWORD AndValue:pwdTxt.text] forKey:@"1"];
    [IMERUtils postDataServer:dataPost url:API_LOGINS controller:self];
}

- (IBAction)loginBtn:(id)sender {

    if ([emailTxt.text isEqualToString:@""]||[pwdTxt.text isEqualToString:@""] ) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Email or password is empty!\n Please enter!"
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    } else {
        if (![IMERUtils validateEmail:emailTxt.text] || pwdTxt.text.length < 8) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Email or password is invalid!\n Please enter again!"
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];

        } else {
            [self loginProcess];
            
        }
    }
    
}



- (IBAction)signupBtn:(id)sender {
    [self performSegueWithIdentifier:@"loginToSignup" sender:self];
    
}
- (IBAction)lostPassBtn:(id)sender{
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//-----ASIHTTPRequest Delegate-----------
- (void) requestFinished:(ASIHTTPRequest *)request {
        
    NSArray *arrayResponseNotice = [IMERUtils getResponseNoticeWithRequest:request];
    
    if ([[arrayResponseNotice objectAtIndex:0] isEqualToString:@"200"]) {
        
        NSDictionary *data = [[[arrayResponseNotice objectAtIndex:2] objectForKey:RESPONSE]objectForKey:DATA];
        // Get Token
        NSString *token = [data objectForKey:TOKEN];
        // Get User Id
        NSString *user_id = [data objectForKey:USER_ID];
        // Get User Name
        NSString *user_name = [data objectForKey:USERNAME];
        // Get Email
        NSString *email = [data objectForKey:EMAIL];
        // Get Created Date
        NSString *created_date = [data objectForKey:CREATE_DATE];
        // Get Avatar
        NSString *avatar = [data objectForKey:AVATAR];
        
        // Save NSUserDefaults        
        [IMERNSUserDefaults saveInfoUser:user_id token:token email:email username:user_name avatar:avatar created_date:created_date];
        
        // Move to home screen
        [self performSegueWithIdentifier:@"loadHome" sender:self];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[arrayResponseNotice objectAtIndex:1]
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];

    }

    
    
}
- (void) requestStarted:(ASIHTTPRequest *) request {
    NSLog(@"request started...");
}

- (void) requestFailed:(ASIHTTPRequest *) request {
    NSError *error = [request error];
    NSLog(@"%@", error);
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Request Failed!" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil]show];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
}

@end

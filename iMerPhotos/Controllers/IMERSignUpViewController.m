//
//  IMERSignUpViewController.m
//  iMerPhotos
//
//  Created by nguyenkhoi on 6/10/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import "IMERSignUpViewController.h"
#import "IMERPostData.h"
#import "Constants.h"
#import "IMERUtils.h"

@interface IMERSignUpViewController ()

@end

@implementation IMERSignUpViewController


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
    // Do any additional setup after loading the view from its nib.
    UIFont *buttonFont = [UIFont fontWithName:FONT size:17.0];
    UIColor *buttonColorDefault = [UIColor colorWithRed:90.0f/255.0f green:90.0f/255.0f blue:90.0f/255.0f alpha:1.0];
    UIColor *buttonColorHighlight = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    
    UIImage *btn = [UIImage imageNamed:@"Button.png"];
    UIImage *btnh = [UIImage imageNamed:@"ButtonHighlighted.png"];
    
    //customize login button
    [signupButton setBackgroundImage:btn forState:UIControlStateNormal];
    [signupButton setBackgroundImage:btnh forState:UIControlStateHighlighted];
    [signupButton.titleLabel setFont:buttonFont];
    [signupButton setTitleColor:buttonColorDefault forState:UIControlStateNormal];
    [signupButton setTitleColor:buttonColorHighlight forState:UIControlStateHighlighted];
    
    //customize signun button
    [cancleButton setBackgroundImage:btn forState:UIControlStateNormal];
    [cancleButton setBackgroundImage:btnh forState:UIControlStateHighlighted];
    [cancleButton.titleLabel setFont:buttonFont];
    [cancleButton setTitleColor:buttonColorDefault forState:UIControlStateNormal];
    [cancleButton setTitleColor:buttonColorHighlight forState:UIControlStateHighlighted];

    
    navItem.titleView = [IMERUtils myLabelWithText:@"Sign Up"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

-(void)signupProcess {
    NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:EMAIL AndValue:emailTextField.text] forKey:@"0"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:PASSWORD AndValue:passwordTextField.text] forKey:@"1"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:USERNAME AndValue:usernameTextField.text] forKey:@"2"];
    [IMERUtils postDataServer:dataPost url:API_REGISTERS controller:self];
}

#pragma mark - Action

-(IBAction)signupPressed:(id)sender {
    if ([emailTextField.text isEqualToString:@""]||[passwordTextField.text isEqualToString:@""] || [rePasswordTextField.text isEqualToString:@""] || [usernameTextField.text isEqualToString:@""] ) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"You must enter all of fields!"
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    } else {
        if (![IMERUtils validateEmail:emailTextField.text] || passwordTextField.text.length < 8) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Email invalid or password length < 8 characters !\n Please enter again!"
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            
        } else {
            if (![rePasswordTextField.text isEqualToString:passwordTextField.text]) {
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:@"Password is not match!\n Please check again!"
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            } else {
                [self signupProcess];
            }
        }
    }

}
-(IBAction)canclePressed:(id)sender{
    [self performSegueWithIdentifier:@"signupToLogin" sender:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - ASIHTTPRequest Delegate
//--------ASIHTTPRequest Delegate----------
-(void)requestFinished:(ASIHTTPRequest *)request {
    NSArray *arrayResponseNotice = [IMERUtils getResponseNoticeWithRequest:request];
    
    if ([[arrayResponseNotice objectAtIndex:0] isEqualToString:@"200"]) {
        // Status code 200
        [[[UIAlertView alloc] initWithTitle:[arrayResponseNotice objectAtIndex:1]
                                    message:@"Register successfully!"
                                   delegate:self
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        
    } else {
        // Error
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[arrayResponseNotice objectAtIndex:1]
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Request Failed!"
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
}

#pragma mark - UIAlerView Delegate
//-----UIAlertView Delegate--------
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"signupToLogin" sender:self];
    }
}
@end

//
//  IMERSettingsViewController.m
//  iMerPhotos
//
//  Created by nguyenkhoi on 6/10/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import "IMERSettingsViewController.h"
#import "IMERPostData.h"
#import "Constants.h"

@interface IMERSettingsViewController ()

@end

@implementation IMERSettingsViewController
@synthesize imagePicker;

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
    usernameTxt.delegate = self;
    isLogoutClick = NO;
    isSaveClick = NO;
    isChangePassClick = NO;
    
    navItem.titleView = [IMERUtils myLabelWithText:@"Settings"];
    
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
    singleTap.numberOfTapsRequired = 1;
    avatarView.userInteractionEnabled = YES;
    [avatarView addGestureRecognizer:singleTap];
    
    NSString *urlAvatar = [IMERNSUserDefaults getAvatar];
    if([urlAvatar isEqualToString:@""]){
        // Set avatar null
        avatarView.image = [UIImage imageNamed:@"no_avatar.png"];
    }else{
        // Set avatar
        // Init URL
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",kServerURL,urlAvatar];
        // Show image
        avatarView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]]];
    }

	[changePassBtn.titleLabel setFont:[UIFont fontWithName:FONT size:20]];
    
    [saveBarBtn setAccessibilityLabel:@"Save"];
    [self.view setAccessibilityLabel:@"Settings Page"];
}

-(void)viewWillAppear:(BOOL)animated {
        
    usernameTxt.text = [IMERNSUserDefaults getUserName];
    NSDate *date = [IMERUtils convertStringToDate:[IMERNSUserDefaults getCreatedDate]];
    // Set text for label join date
    joinedDateLbl.text = [[NSString alloc]initWithFormat:@"Joined: %@",[IMERUtils differenceString:date]];
}
- (void)didReceiveMemoryWarning
{
    image = nil;
    imageData = nil;
    [super didReceiveMemoryWarning];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [UIView beginAnimations:@"MoveDown" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 20, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];

}



-(void)imageViewClicked:(UITapGestureRecognizer *) sender {
    //[self performSegueWithIdentifier:@"uploadToPost" sender:self];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
    
    // Get the data for the image as a JPEG
    imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],1);
    image = [[UIImage alloc]initWithData:imageData];
    UIImage *thumbnail = [self generatePhotoThumbnail:image];
    //image = [self generatePhotoThumbnail:image];
    imageData = UIImageJPEGRepresentation(thumbnail,1);
    avatarView.image = thumbnail;
    
    [picker dismissViewControllerAnimated:YES completion:nil];

}

-(void)saveProcess {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kServerURL,API_CHANGESETTINGS]];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:url];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    if(imageData != nil){
        [request addData:imageData withFileName:@"myphoto.jpg" andContentType:@"image/jpeg" forKey:@"data[avatar]"];
    }
    [request setPostValue:[IMERNSUserDefaults getToken] forKey:TOKEN];
    [request setPostValue:[IMERNSUserDefaults getUserId] forKey:ID];
    [request setPostValue:usernameTxt.text forKey:USERNAME];
    [request setPostValue:oldPassTxt.text forKey:@"old_pwd"];
    [request setPostValue:newPassTxt.text forKey:@"new_pwd"];    
    [request startAsynchronous];
}
- (IBAction)beginTouchToChangePass:(id)sender {
    [UIView beginAnimations:@"MoveUp" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, -100, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];

}

- (IBAction)endChangePass:(id)sender {
    [UIView beginAnimations:@"MoveDown" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 20, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];

}

- (IBAction)changePassAction:(id)sender {
    
    UITextPosition *beginning = [oldPassTxt beginningOfDocument];
    [oldPassTxt setSelectedTextRange:[oldPassTxt textRangeFromPosition:beginning toPosition:beginning]];
}

- (IBAction)saveBtnAction:(id)sender {
    isSaveClick = YES;
    if ([usernameTxt.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Username must be not empty!\n Please enter!"
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    } else {
        if (![oldPassTxt.text isEqualToString:@""]) {
            if (oldPassTxt.text.length < 8 || newPassTxt.text.length <8) {
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:@"Password must have at least 8 characters!\n Please enter!"
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            } else {
                if (![renewPassTxt.text isEqualToString:newPassTxt.text]) {
                    [[[UIAlertView alloc] initWithTitle:@"Error"
                                                message:@" New password not match!\n Please enter!"
                                               delegate:nil
                                cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                }else {
                    [self saveProcess];
                }
            }
        } else {
            [self saveProcess];
        }
    }
    
}

- (IBAction)logoutBtnAction:(id)sender {
    isLogoutClick = YES;
    [[[UIAlertView alloc] initWithTitle:@"Confirm!"
                                message:@"Are you sure want to log out?"
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:@"Cancel",nil] show];
}

-(IBAction)cancelBtnAction:(id)sender {
    
    oldPassTxt.text = @"";
    newPassTxt.text = @"";
    renewPassTxt.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
}

//------ASIHTTPRequest Delegate-------------
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSArray *arrayResponseNotice = [IMERUtils getResponseNoticeWithRequest:request];    
    if (isLogoutClick) {
        if ([[arrayResponseNotice objectAtIndex:0] isEqualToString:@"200"]) {
            // Status code 200
            [self performSegueWithIdentifier:@"settingToLogin" sender:self];
            
        } else {
            // Error
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[arrayResponseNotice objectAtIndex:1]
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            
        }

    } else if (isSaveClick){
        if ([[arrayResponseNotice objectAtIndex:0] isEqualToString:@"200"]) {
            // Save url avatar when update
            NSDictionary *responseDic = [arrayResponseNotice objectAtIndex:2];
            NSDictionary *data = [[responseDic objectForKey:RESPONSE]objectForKey:DATA];
            
            NSString *avar = [data objectForKey:@"avatar"];
            
            [IMERNSUserDefaults saveAvatar:avar];
            
            if([avar isEqualToString:@""]){
                // No avatar
                avatarView.image = [UIImage imageNamed:@"no_avatar.png"];
                // Reset data
                imageData = nil;
                image = nil;
            }else{
                // Avatar
                // Init URL
                NSString *strUrl = [NSString stringWithFormat:@"%@%@",kServerURL,[data objectForKey:@"avatar"]];
                // Show image
                avatarView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]]];
                // Reset data
                imageData = nil;
                image = nil;
            }
            
            // Status code 200
            [[[UIAlertView alloc] initWithTitle:[arrayResponseNotice objectAtIndex:1]
                                        message:@"Save successfully!"
                                       delegate:self
                              cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            
        } else {
            // Error
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[arrayResponseNotice objectAtIndex:1]
                                       delegate:self
                              cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            
        }

    }
    
}
-(void)requestFailed:(ASIHTTPRequest *)request {
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Request Failed!"
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
}

//-------UIAlertView Delegate--------------
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (isLogoutClick) {
        if (buttonIndex==0) {
            NSMutableDictionary *dataPost2 = [[NSMutableDictionary alloc]init];
            [dataPost2 setValue:[[IMERPostData alloc]initWithNewData:ID AndValue:[IMERNSUserDefaults getUserId]] forKey:@"0"];
            [dataPost2 setValue:[[IMERPostData alloc]initWithNewData:TOKEN AndValue:[IMERNSUserDefaults getToken]] forKey:@"1"];
            
            [IMERUtils postDataServer:dataPost2 url:API_LOGOUTS controller:self];
            //[self performSegueWithIdentifier:@"settingToLogin" sender:self];
        } else {
            isLogoutClick = NO;
        }
    }else if (isSaveClick){
        if (buttonIndex==0) {
            [IMERNSUserDefaults saveUsername:usernameTxt.text];
        }
    }
}

-(UIImage *)generatePhotoThumbnail:(UIImage *)_image {
    // Create a thumbnail version of the image for the event object.
    CGSize size = _image.size;
    CGSize croppedSize;
    CGFloat ratio = 200.0;
    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    // check the size of the image, we want to make it
    // a square with sides the size of the smallest dimension
    if (size.width > size.height) {
        offsetX = (size.height - size.width) / 2;
        croppedSize = CGSizeMake(size.height, size.height);
    } else {
        offsetY = (size.width - size.height) / 2;
        croppedSize = CGSizeMake(size.width, size.width);
    }
    // Crop the image before resize
    CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([_image CGImage], clippedRect);
    // Done cropping
    // Resize the image
    CGRect rect = CGRectMake(0.0, 0.0, ratio, ratio);
    UIGraphicsBeginImageContext(rect.size);
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    CFRelease(imageRef);
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Done Resizing
    return thumbnail;
}

@end

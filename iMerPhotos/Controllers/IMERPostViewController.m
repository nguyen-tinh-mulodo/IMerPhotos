//
//  IMERPostViewController.m
//  iMerPhotos
//
//  Created by nguyenkhoi on 6/13/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import "IMERPostViewController.h"
#import "ASIFormDataRequest.h"
#import "IMERNSUserDefaults.h"
#import "Constants.h"
#import "IMERUtils.h"


#if TARGET_IPHONE_SIMULATOR
NSString *device = @"simulator";
#else
NSString *device = @"device";
#endif

@implementation IMERPostViewController
@synthesize _image,_imageData,_isGetLibraries,_isTakePhoto;
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
    
    navItem.titleView = [IMERUtils myLabelWithText:@"Upload"];
    
    self.navigationItem.leftBarButtonItem = backBtn;
    self.navigationItem.hidesBackButton = YES;
    
    _picker = [[UIImagePickerController alloc]init];
    _picker.delegate = self;
    
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setImage:_image];
    [postBtn setAccessibilityLabel:@"Post"];
    [self.view setAccessibilityLabel:@"Tap View"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)backBtnAction:(id)sender {
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
     [_picker dismissViewControllerAnimated:YES completion:nil];
    NSData *temp_imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],0.5);
    UIImage *temp_image = [[UIImage alloc]initWithData:temp_imageData];
    UIImage *rotation_img = [IMERUtils rotateImage:temp_image];
    if (rotation_img.size.width > 900) {
        _image = [IMERUtils imageWithImage:rotation_img scaledToWidth:900.0];
    } else {
        _image = rotation_img;
    }
    _imageData = UIImageJPEGRepresentation(_image, 1.0);

    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setImage:_image];

}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UINavigationItem *top = navigationController.navigationBar.topItem;
    top.titleView = [IMERUtils myLabelWithText:@"Upload"];
    UIBarButtonItem *secondButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhoto)];
    top.leftBarButtonItem = secondButton;
    top.leftBarButtonItem = secondButton;
}

-(void)takePhoto{
    if ([device isEqualToString:@"simulator"]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Can't open camera on simulator!"
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    } else {
        [_picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
    }
    
}


- (IBAction)postBtnAction:(id)sender {
   
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kServerURL,API_UPLOADPHOTOS]];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:url];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request addData:_imageData withFileName:@"myphoto.jpg" andContentType:@"image/jpeg" forKey:@"data[image]"];
    [request setPostValue:descTxt.text forKey:@"comment"];
    [request setPostValue:[IMERNSUserDefaults getToken] forKey:TOKEN];
    [request setPostValue:[IMERNSUserDefaults getUserId] forKey:ID];
    [request startAsynchronous];
}
//------ASIHTTPRequest Delegate-------
-(void)requestFinished:(ASIHTTPRequest *)request{
   
    NSArray *arrayResponseNotice = [IMERUtils getResponseNoticeWithRequest:request];    if ([[arrayResponseNotice objectAtIndex:0] isEqualToString:@"200"]) {
        [[[UIAlertView alloc] initWithTitle:[arrayResponseNotice objectAtIndex:1]
                                    message:@"Your photo was uploaded!"
                                   delegate:self
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"ERROR!"
                                    message:[arrayResponseNotice objectAtIndex:1]
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }

    
}
-(void)requestFailed:(ASIHTTPRequest *)request {
    [[[UIAlertView alloc] initWithTitle:@"ERROR!"
                                message:@"Request Failed!"
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
}

//-----Text View Delegate----------

-(void)textViewDidBeginEditing:(UITextView *)textView {
    [UIView beginAnimations:@"MoveUp" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    descTxt.frame = CGRectMake(descTxt.frame.origin.x, 50, descTxt.frame.size.width, descTxt.frame.size.height);
    [UIView commitAnimations];
    descTxt.text = @"";
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [UIView beginAnimations:@"MoveDown" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    descTxt.frame = CGRectMake(descTxt.frame.origin.x, 320, descTxt.frame.size.width, descTxt.frame.size.height);
    [UIView commitAnimations];

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }

}


@end

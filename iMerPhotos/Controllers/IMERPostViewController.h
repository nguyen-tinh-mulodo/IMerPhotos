//
//  IMERPostViewController.h
//  iMerPhotos
//
//  Created by nguyenkhoi on 6/13/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
//#import "IMERUploadViewController.h"

@class IMERUploadViewController;
@interface IMERPostViewController : UIViewController<UITextViewDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
    __weak IBOutlet UIImageView *imageView;
    IBOutlet UIBarButtonItem *postBtn;
    __weak IBOutlet UITextView *descTxt;
    __weak IBOutlet UINavigationItem *navItem;
    __weak IBOutlet UIBarButtonItem *backBtn;
    
    UIImagePickerController *_picker;
    
    UIImage *_image;
    NSData *_imageData;
    BOOL _isTakePhoto;
    BOOL _isGetLibraries;
    
}
- (IBAction)postBtnAction:(id)sender;
-(IBAction)backBtnAction:(id)sender;
@property (nonatomic,retain) UIImage *_image;
@property (nonatomic,retain) NSData *_imageData;
@property (nonatomic,assign) BOOL _isTakePhoto;
@property (nonatomic,assign) BOOL _isGetLibraries;
@end

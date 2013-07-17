//
//  IMERHomeViewController.h
//  iMerPhotos
//
//  Created by nguyenkhoi on 6/10/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMERPostViewController.h"
#import "IMERSettingsViewController.h"

@interface IMERHomeViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
    IBOutlet UICollectionView *collectionViewPack;

    __weak IBOutlet UINavigationItem *titleNavBar;
    IBOutlet UIBarButtonItem *uploaderBtn;
    IBOutlet UIBarButtonItem *settingBtn;
    
    IMERSettingsViewController *settingView;
    
    UIActivityIndicatorView *spinner;
    UIImagePickerController *pickerController;
    
    
    
    NSMutableArray *listPhoto;
    UIRefreshControl *refreshControl;
    int pageNumber;
    
    UIImage *image;
    NSData* imageData;
    
    NSArray *arrayResponseNotice;
}

@property(nonatomic,retain)IBOutlet UICollectionView *collectionViewPack;
@property (nonatomic) BOOL isLoading;
@property (nonatomic) int elementsCount;

-(IBAction)uploadBtnAction:(id)sender;
-(IBAction)settingBtnAction:(id)sender;

@end


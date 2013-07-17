//
//  IMERMyPhotosViewController.h
//  iMerPhotos
//
//  Created by nguyenkhoi on 6/10/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface IMERMyPhotosViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>{
    
    __weak IBOutlet UIImageView *imageUser;
    __weak IBOutlet UILabel *emailUser;
    __weak IBOutlet UILabel *joinDate;
    __weak IBOutlet UILabel *numberPhoto;
    __weak IBOutlet UICollectionView *collectViewImage;
    NSMutableArray *listPhoto;
    UIActivityIndicatorView *spinner;
    __weak IBOutlet UINavigationItem *navItem;
    int pageNumber;
    UIRefreshControl *refreshControl;
    BOOL isLoading;
    int elementsCount;
}

@end

//
//  IMERPhotoDetailViewController.h
//  iMerPhotos
//
//  Created by Jack Dawson on 6/12/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMERPhoto.h"

@interface IMERPhotoDetailViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,UIScrollViewDelegate>{
    UITextView *commentLbl;
    UILabel *timeLbl;
    IBOutlet UIButton *likeButton;
    IBOutlet UIButton *totalLikeButton;
    IBOutlet UIBarButtonItem *titleNavBar;
    IBOutlet UINavigationItem *navItem;
    NSMutableArray *likedUser;
    IMERPhoto *photo;
    IMERPhoto *nextphoto;
    NSString *currentphotoID;


}

@property (strong, nonatomic) IMERPhoto *photo;

@property (strong, nonatomic) IMERPhoto *nextphoto;

@property (strong,nonatomic) UILabel *layerComment;

@property (strong,nonatomic) UILabel *layertotalLike;

@property (strong,nonatomic) UIView *topView;

@property (strong, nonatomic) UIActivityViewController *activityViewController;

@property(nonatomic,retain)IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic) BOOL isfullscreenMode;

@property (nonatomic) BOOL iscommentMode;


- (IBAction)handleTap:(UIGestureRecognizer *)recognizer;

- (IBAction)handledoubleTap:(UIGestureRecognizer *)recognizer;

- (IBAction)shareButton:(id)sender;
- (IBAction)likeButton:(id)sender;
- (IBAction)totalLikeButton:(id)sender;
@end

//
//  IMERPhotoDetailViewController.m
//  iMerPhotos
//
//  Created by Jack Dawson on 6/12/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import "IMERPhotoDetailViewController.h"
#import "SharingActivityProvider.h"
#import "IMERUtils.h"
#import "IMERNSUserDefaults.h"
#import "IMERPostData.h"
#import "IMERPhoto.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageCell.h"

@interface IMERPhotoDetailViewController ()
@end

@implementation UINavigationBar (CustomImage) -(void)drawRect:(CGRect)rect {
    
    CGRect currentRect = CGRectMake(0,0,100,45);
    UIImage *image = [UIImage imageNamed:@"camera.png"];
    [image drawInRect:currentRect];
}
@end

@implementation IMERPhotoDetailViewController
@synthesize layerComment,photo,layertotalLike,topView,nextphoto;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)show_liked_users
{
    //setup data liked user
    
    if(likedUser.count>0){
        NSString *textLikedUser = [NSString stringWithFormat:@"%@ people like this.\n",photo.totalLike];
        for (int i=0 ;i<likedUser.count ;i++) {
            textLikedUser = [NSString stringWithFormat:@"%@ %@\n",textLikedUser,[likedUser objectAtIndex:i]];
        }
        UITextView *textView = (UITextView *)[self.view viewWithTag:99];
        textView.text=textLikedUser;
    }
}

- (void)setup_data
{
    
    
    //setup data comment,upload date
    commentLbl.text = photo.comment;
    [commentLbl setScrollEnabled:YES];
    
    timeLbl.text = [IMERUtils dateDiff: photo.upload_date];
    
    //setup data total like
    NSString *total_like;
    if([photo.totalLike intValue] >= 2)
    {
        total_like = [NSString stringWithFormat:@"%@ likes",photo.totalLike];
        [totalLikeButton setEnabled:YES];
    }
    else if([photo.totalLike intValue] == 1)
    {
        total_like = [NSString stringWithFormat:@"%@ like",photo.totalLike];
        [totalLikeButton setEnabled:YES];
    }
    else
    {
        total_like = [NSString stringWithFormat:@"%@ like",photo.totalLike];
        [totalLikeButton setEnabled:NO];
    }
    
    [totalLikeButton setTitle:total_like forState:UIControlStateNormal];
    [totalLikeButton setTitle:total_like forState:UIControlStateSelected];
    [totalLikeButton setTitle:total_like forState:UIControlStateHighlighted];
    [totalLikeButton setTitle:total_like forState:UIControlStateReserved];
    [totalLikeButton setTitle:total_like forState:UIControlStateApplication];
    [totalLikeButton setTitle:total_like forState:UIControlStateDisabled];
    
    
    
    //setup title
    if(photo.username != NULL){
        self.navigationItem.titleView = [IMERUtils myLabelWithText:photo.username];
    }
    
    
    [self show_liked_users];
    
    if([photo.isLiked isEqual: @"1"]){
        likeButton.highlighted = YES;
    }
    else
        likeButton.highlighted = NO;
}

- (void)setup_layout
{
    
    [self setIsfullscreenMode:NO];
    [self setIscommentMode:NO];
    //setup background
    self.view.backgroundColor = [UIColor clearColor];
    
    //setup button
    UIFont *buttonFont = [UIFont fontWithName:@"Comic Sans MS" size:17.0];
    UIColor *buttonColorDefault = [UIColor colorWithRed:90.0f/255.0f green:90.0f/255.0f blue:90.0f/255.0f alpha:1.0];
    UIColor *buttonColorHighlight = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    
    UIImage *btn = [UIImage imageNamed:@"Button.png"];
    UIImage *btnh = [UIImage imageNamed:@"ButtonHighlighted.png"];
    [likeButton setBackgroundImage:btn forState:UIControlStateNormal];
    [likeButton setBackgroundImage:btnh forState:UIControlStateHighlighted];
    [likeButton.titleLabel setFont:buttonFont];
    [likeButton setTitleColor:buttonColorDefault forState:UIControlStateNormal];
    [likeButton setTitleColor:buttonColorHighlight forState:UIControlStateHighlighted];
    [likeButton setTitle:@"Liked" forState:UIControlStateHighlighted];
    [totalLikeButton.titleLabel setFont:buttonFont];
    
    //setup text
    //setup layer background for description and time label
    layerComment = [[UILabel alloc] initWithFrame:CGRectMake(0, -42, self.view.frame.size.width, 70)];
    [layerComment.layer setOpacity:0.5];
    [layerComment setBackgroundColor:[UIColor grayColor]];
    
    
    
    //setup layout for description label
    commentLbl = [[UITextView alloc]initWithFrame:CGRectMake(layerComment.frame.origin.x, layerComment.frame.origin.y,layerComment.frame.size.width-50, layerComment.frame.size.height)];
    [commentLbl setBackgroundColor:[UIColor clearColor]];
    [commentLbl setEditable:NO];
    
    //setup layout for time label
    timeLbl = [[UILabel alloc]initWithFrame:CGRectMake(layerComment.frame.origin.x, layerComment.frame.origin.y + 15,layerComment.frame.size.width-10, layerComment.frame.size.height)];
    [timeLbl setBackgroundColor:[UIColor clearColor]];
    [timeLbl setTextAlignment:NSTextAlignmentRight];
    
    //setup font for all text
    UIFont *descriptionFont = [UIFont fontWithName:@"Comic Sans MS" size:18.0];
    UIFont *timeFont = [UIFont fontWithName:@"Comic Sans MS" size:12.0];
    commentLbl.font = descriptionFont;
    timeLbl.font = timeFont;
    commentLbl.textColor = [UIColor whiteColor];
    timeLbl.textColor = [UIColor whiteColor];
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    [topView addSubview:layerComment];
    [topView addSubview:commentLbl];
    [topView addSubview:timeLbl];
    [topView setHidden:YES];
    
    [self.view addSubview:topView];
    //show navigationbar
    self.navigationController.navigationBarHidden=NO;
    
}
- (void)viewDidAppear:(BOOL)animated{
    //setup background for total like label
    if([self.view viewWithTag:15]==Nil && self.isfullscreenMode == NO){
        CGRect layertotal = CGRectMake(self.view.frame.size.width, totalLikeButton.frame.origin.y, totalLikeButton.frame.size.width +50, totalLikeButton.frame.size.height);
        layertotalLike = [[UILabel alloc]initWithFrame:layertotal];
        [layertotalLike.layer setOpacity:0.5];
        [layertotalLike setBackgroundColor:[UIColor grayColor]];
        [layertotalLike setTag:15];
        [self.view addSubview:layertotalLike];
        [UIView beginAnimations:@"Show out" context:nil];
        [UIView setAnimationDuration:0.3f];
        topView.frame = CGRectMake(topView.frame.origin.x, 90, topView.frame.size.width, topView.frame.size.height);
        layertotalLike.frame = CGRectMake(self.view.frame.size.width -100, totalLikeButton.frame.origin.y, totalLikeButton.frame.size.width +50, totalLikeButton.frame.size.height);
        [topView setHidden:NO];
        
        [self.view bringSubviewToFront:totalLikeButton];
        
        [UIView commitAnimations];
    } 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    currentphotoID =self.photo.photoId;
    [self setup_layout];
    //[self setup_data];
    likedUser = [[NSMutableArray alloc]init];
    [self getPhoto:self.photo.photoId];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self setupCollectionView];
    
    [self.view setAccessibilityLabel:@"Photo Detail"];
    
}
- (void)viewDidLayoutSubviews
{
    [self.collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [likedUser removeAllObjects];
    likedUser = nil;
    photo = nil;
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareButton:(id)sender {
    
    IMERPhoto *photoCell = [self.dataArray objectAtIndex:self.indexPath.row];
    
    SharingActivityProvider *sharingActivityProvider = [[SharingActivityProvider alloc] init];
    sharingActivityProvider.stringFaceBook=@"Hello Facebook";
    sharingActivityProvider.stringTwitter=@"Hello Twitter";
    NSMutableArray *items = [[NSMutableArray alloc]init];
    [items addObject:sharingActivityProvider];
    [items addObject:[UIImage imageWithData:photoCell.imageData]];
    
    NSArray *activityItems = [NSArray arrayWithArray:items];
    self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    self.activityViewController.excludedActivityTypes=@[UIActivityTypePostToWeibo,UIActivityTypePrint];
    [self presentViewController:self.activityViewController animated:YES completion:nil];
    
    
}

- (IBAction)likeButton:(id)sender {
    if([photo.isLiked isEqual: @"1"]){
        NSLog(@"ban vua unlike");
        
    }
    else{
        NSLog(@"ban vua like");
    }
    
    [self likePhoto:currentphotoID];
}

- (IBAction)totalLikeButton:(id)sender {
    
    
    if([self.view viewWithTag:99]==Nil){
        UITextView *textview=[[UITextView alloc]initWithFrame:CGRectMake(20, 50, 280, 300)];
        textview.backgroundColor=[[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.6];
        textview.textColor=[UIColor whiteColor];
        textview.font=[UIFont fontWithName:@"Comic Sans MS" size:17.0];
        textview.tag=99;
        textview.editable=NO;
        [self.view addSubview:textview];
        [self getLikedUser:currentphotoID];
        [self setIscommentMode:YES];
    }
    
}

- (void)getPhoto:(NSString *)photoID{
    
    dispatch_queue_t queue = dispatch_queue_create("com.jack.queue", 0);
    dispatch_async(queue, ^{
        NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
        [dataPost setValue:[[IMERPostData alloc]initWithNewData:ID AndValue:[IMERNSUserDefaults getUserId]] forKey:@"0"];
        [dataPost setValue:[[IMERPostData alloc]initWithNewData:TOKEN AndValue:[IMERNSUserDefaults getToken]] forKey:@"1"];
        [dataPost setValue:[[IMERPostData alloc]initWithNewData:PHOTO_ID AndValue:photoID] forKey:@"2"];
        
        // Call function postDataServer to
        //[IMERUtils postDataServer:dataPost url:API_GETPHOTOINFOS controller:self];
        [IMERUtils postDataServer:dataPost url:API_GETPHOTOINFOS controller:self];
    });
}

- (void)getLikedUser:(NSString *)photoID{
    dispatch_queue_t queue = dispatch_queue_create("com.jack.queue", 0);
    dispatch_async(queue, ^{
        NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
        [dataPost setValue:[[IMERPostData alloc]initWithNewData:ID AndValue:[IMERNSUserDefaults getUserId]] forKey:@"0"];
        [dataPost setValue:[[IMERPostData alloc]initWithNewData:TOKEN AndValue:[IMERNSUserDefaults getToken]] forKey:@"1"];
        [dataPost setValue:[[IMERPostData alloc]initWithNewData:PHOTO_ID AndValue:photoID] forKey:@"2"];
        
        // Call function postDataServer to
        [IMERUtils postDataServer:dataPost url:API_GETLIKEDUSERS controller:self];
    });
    
}

- (void)likePhoto:(NSString *)photoID{
    
    dispatch_queue_t queue = dispatch_queue_create("com.jack.queue", 0);
    dispatch_async(queue, ^{
        NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
        [dataPost setValue:[[IMERPostData alloc]initWithNewData:@"id" AndValue:[IMERNSUserDefaults getUserId]] forKey:@"0"];
        [dataPost setValue:[[IMERPostData alloc]initWithNewData:@"token" AndValue:[IMERNSUserDefaults getToken]] forKey:@"1"];
        [dataPost setValue:[[IMERPostData alloc]initWithNewData:@"photo_id" AndValue:photoID] forKey:@"2"];
        
        // Call function postDataServer to
        [IMERUtils postDataServer:dataPost url:API_LIKES controller:self];
        
    });
}

//-----ASIHTTPRequest Delegate-----------
- (void) requestFinished:(ASIHTTPRequest *)request {
    NSError *error;
    NSData *responseData = [request responseData];
    // Get dictionary response from request
    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSDictionary *errorDic = [[responseDic objectForKey:RESPONSE]objectForKey:ERROR];
    // Get status code
    NSString *status_code = [errorDic objectForKey:STATUS_CODE];
    // Get status message
    NSString *message = [errorDic objectForKey:MESSAGE];
    if ([status_code isEqualToString:@"200"]) {
        // Good List
        NSArray *data = [[responseDic objectForKey:RESPONSE]objectForKey:DATA];
        
        //Handle Multiple Request
        if([[request.userInfo objectForKey:TYPE]isEqualToString:API_GETPHOTOINFOS]){
            for (NSDictionary* dic in data) {
                NSDictionary *photoinfo = [dic objectForKey:PHOTO];
                photo.comment = [photoinfo objectForKey:COMMENT];
                photo.upload_date = [photoinfo objectForKey:UPLOAD_DATE];
                photo.totalLike = [photoinfo objectForKey:TOTAL_LIKE];
                dispatch_queue_t backgroundQueue = dispatch_queue_create("com.jack.queue", 0);
                dispatch_async(backgroundQueue, ^{
                    
                    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kServerURL,[photoinfo objectForKey:PHOTO_PATH]];
                    photo.imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:strUrl]];
                    
                });
                
                NSDictionary *user = [dic objectForKey:USER];
                photo.username = [user objectForKey:USERNAME];
                
                NSDictionary *liked = [dic objectForKey:@"0"];
                photo.isLiked = [liked objectForKey:IS_LIKED];
                [self setup_data];
            }
        }
        
        else if ([[request.userInfo objectForKey:TYPE]isEqualToString:API_LIKES]){
            int i = [photo.totalLike intValue];
            if([photo.isLiked isEqual: @"1"]){
                photo.isLiked = @"0";
                photo.totalLike = [NSString stringWithFormat:@"%i",i-1];
            }else{
                photo.isLiked = @"1";
                photo.totalLike = [NSString stringWithFormat:@"%i",i+1];
            }
            [self setup_data];
        }
        
        else if ([[request.userInfo objectForKey:TYPE]isEqualToString:API_GETLIKEDUSERS]){
            [likedUser removeAllObjects];
            if(data != (id)[NSNull null]){
                for (NSDictionary* dic in data) {
                    NSDictionary *user = [dic objectForKey:USER];
                    [likedUser addObject:[user objectForKey:USERNAME]];
                    [self show_liked_users];
                }
            }
            else photo.totalLike = @"0";
        }
        
        
    } else {
        // Error
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:message
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        
    }
    
    
    
}
- (void) requestStarted:(ASIHTTPRequest *) request {
    //NSLog(@"request started...");
}

- (void) requestFailed:(ASIHTTPRequest *) request {
    NSError *error = [request error];
    NSLog(@"%@", error);
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Request Failed!" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil]show];
}


/*Section load next image when swipe */
-(void)setupCollectionView {
    [self.collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCell *cell = (ImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    IMERPhoto *photoCell = [self.dataArray objectAtIndex:indexPath.row];
    [cell setImagePath:photoCell.photoPath];
    [cell updateCell];
    
    [cell setAccessibilityLabel:@"ImageCell"];
 
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.frame.size;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *indexPaths = [collectionView indexPathsForVisibleItems];
    NSIndexPath *index = [indexPaths objectAtIndex:0];
    if(self.indexPath != index){
        IMERPhoto *photoCell = [self.dataArray objectAtIndex:[index indexAtPosition:1]];
        currentphotoID = photoCell.photoId;
        [self getPhoto:photoCell.photoId];
        [self setup_data];
        self.indexPath = index;
    }
    [cell setAccessibilityLabel:@"ImageCell"];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGPoint currentOffset = self.collectionView.contentOffset;
    
    float newOffsetX;
    
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
        // currently in portrait
        float offsetIndex = (int)currentOffset.x / [[UIScreen mainScreen] bounds].size.width ;
        newOffsetX = offsetIndex * [[UIScreen mainScreen] bounds].size.height;
    } else {
        // currently in landscape
        float offsetIndex = (int)currentOffset.x / [[UIScreen mainScreen] bounds].size.height;
        newOffsetX = offsetIndex * [[UIScreen mainScreen] bounds].size.width;
    }
    
    CGPoint newOffset = CGPointMake(newOffsetX, 0);
    [self.collectionView setContentOffset:newOffset];
    
    [self.collectionView reloadData];
}


//Setup Component when tap
- (IBAction)handleTap:(UIGestureRecognizer *)recognizer{
    
    if(self.iscommentMode == YES){
        UITextView *textview=(UITextView *)[self.view viewWithTag:99];
        [textview removeFromSuperview];
        [self setIscommentMode:NO];
        return;
    }
    
    if(self.isfullscreenMode == YES)
        [self showComponent];
    else if(self.isfullscreenMode == NO)
        [self hideComponent];
    
}

- (IBAction)handledoubleTap:(UIGestureRecognizer *)recognizer{
    
    
}

-(void) hideComponent
{
    [self.navigationController.navigationBar setHidden:YES];
    [topView setHidden:YES];
    [layertotalLike setHidden:YES];
    [totalLikeButton setHidden:YES];
    [likeButton setHidden:YES];
    [self setIsfullscreenMode:YES];
}

-(void) showComponent
{
    [self.navigationController.navigationBar setHidden:NO];
    [topView setHidden:NO];
    [layertotalLike setHidden:NO];
    [totalLikeButton setHidden:NO];
    [likeButton setHidden:NO];
    [self setIsfullscreenMode:NO];
}

@end

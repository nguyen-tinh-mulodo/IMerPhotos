//
//  IMERMyPhotosViewController.m
//  iMerPhotos
//
//  Created by nguyenkhoi on 6/10/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import "IMERMyPhotosViewController.h"
#import "IMERUtils.h"
#import "IMERNSUserDefaults.h"
#import "IMERPostData.h"
#import "IMERPhoto.h"
#import "IMERPhotoDetailViewController.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
#import "MyImageView.h"

#define kCollectionFooterHeigt 40.0
#define kDefaultItemsCount 12

@interface IMERMyPhotosViewController ()


@end

@implementation IMERMyPhotosViewController

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
    // customize layout
    UIFont *titleFont = [UIFont fontWithName:FONT size:28.0];
    emailUser.textColor = [UIColor colorWithRed:32.0f/255.0f green:178.0f/255.0f blue:170.0f/255.0f alpha:1.0];
    emailUser.font = titleFont;
    self.navigationController.navigationBarHidden=TRUE;
    
    // Init new spinner
    spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 150, 20, 30)];
    [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.hidden = FALSE;
    [spinner startAnimating];
    [self.view addSubview:spinner];
    
    // Init UIrefreshControl
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [collectViewImage addSubview:refreshControl];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Updating images..."];
    collectViewImage.alwaysBounceVertical = TRUE;
    
    listPhoto = [[NSMutableArray alloc]init];
    
    [self refreshData];
    collectViewImage.delegate = self;
    collectViewImage.dataSource  = self;
    
    [self.view setAccessibilityLabel:@"My Photos Page"];
    [collectViewImage setAccessibilityLabel:@"Collection View"];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
    [self setupAvatar];
}

- (void)initStopPostData{
    spinner.hidden = true;
    [spinner stopAnimating];
}

-(void)setupAvatar {
    // Convert String To Date
    NSDate *date = [IMERUtils convertStringToDate:[IMERNSUserDefaults getCreatedDate]];
    // Set text for label join date
    joinDate.text = [[NSString alloc]initWithFormat:@"Joined: %@",[IMERUtils differenceString:date]];
    
    // Set text for label username
    emailUser.text = [[NSString alloc]initWithFormat:@"%@",[IMERNSUserDefaults getUserName]];
    
    NSString *urlAvatar = [IMERNSUserDefaults getAvatar];
    if([urlAvatar isEqualToString:@""]){
        // Set avatar null
        imageUser.image = [UIImage imageNamed:@"no_avatar.png"];
    }else{
        // Set avatar
        // Init URL
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",kServerURL,urlAvatar];
        // Show image
        [imageUser setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"no_avatar.png"]];
        
    }
    
}

- (void)refreshData
{
    if ([refreshControl isRefreshing]) {
        
        [UIView beginAnimations:@"MoveDown" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.5f];
        [collectViewImage setContentOffset:CGPointMake(0, -40)];
        [UIView commitAnimations];
        
        
    }
    pageNumber = 0;
    
    [self setupAvatar];
    
    // Init new list
    [listPhoto removeAllObjects];
    
    // Get photo of user
    [self initPostDataService:pageNumber];
    
    
}


// Fucntion to init value param to post server
-(void)initPostDataService:(int) num{
    NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:ID AndValue:[IMERNSUserDefaults getUserId]] forKey:@"0"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:TOKEN AndValue:[IMERNSUserDefaults getToken]] forKey:@"1"];
    
    
    int offset =  num * kDefaultItemsCount;
    int limit = kDefaultItemsCount;
    
    
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:COUNT AndValue:[NSString stringWithFormat:@"%i", limit]] forKey:@"2"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:OFFSET AndValue:[NSString stringWithFormat:@"%i", offset]] forKey:@"3"];
    
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:ID_NEED AndValue:[IMERNSUserDefaults getUserId]] forKey:@"4"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:TYPE AndValue:USER] forKey:@"5"];
    
    pageNumber += 1;
    
    // Call function postDataServer to
    [IMERUtils postDataServer:dataPost url:API_GETPHOTOS controller:self];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [listPhoto removeAllObjects];
    listPhoto = nil;
    collectViewImage = nil;
    
}

#pragma mark - CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(listPhoto.count == 0){
        refreshControl.hidden = TRUE;
    }else{
        refreshControl.hidden = FALSE;
    }
    return listPhoto.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    // Get object Photo
    
    if ([listPhoto count]>0) {
        IMERPhoto *photo = [listPhoto objectAtIndex: indexPath.row];
        // Show image
        UIImageView *test = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        [cell addSubview:test];
        [cell bringSubviewToFront:test];
        [test setContentMode:UIViewContentModeScaleAspectFill];
        dispatch_async(dispatch_get_main_queue(), ^{
            [test setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kServerURL,photo.thumnailPath]] placeholderImage:[UIImage imageNamed:@""]];
        });
        cell.tag = [photo.photoId integerValue];
    }
    
    
    return cell;
}

#pragma mark - ASIHTTPRequest Delegate

//-----ASIHTTPRequest Delegate-----------
- (void) requestFinished:(ASIHTTPRequest *)request {
    NSArray *arrayResponseNotice = [IMERUtils getResponseNoticeWithRequest:request];
    NSString *sumStr = @"0";
    if ([[arrayResponseNotice objectAtIndex:0] isEqualToString:@"200"]) {
        
        // Get data object
        NSDictionary *dataCommon = [[[arrayResponseNotice objectAtIndex:2] objectForKey:RESPONSE]objectForKey:DATA];
        NSArray *data = [dataCommon objectForKey:@"photo_list"];
        sumStr = [dataCommon objectForKey:@"sum"];
        
        // Get photos list
        for (NSDictionary *photo in data)
        {
            // Get Photo Object from json string
            NSDictionary *objPhoto = [photo objectForKey:PHOTO_UPCASE];
            // Init new photo from value that get from service
            IMERPhoto *newPhoto = [IMERPhoto alloc];
            newPhoto.photoId = [objPhoto objectForKey:ID];
            newPhoto.comment = [objPhoto objectForKey:COMMENT];
            newPhoto.photoPath = [objPhoto objectForKey:PHOTO_PATH];
            newPhoto.userUploadId = [objPhoto objectForKey:USER_ID];
            newPhoto.upload_date = [objPhoto objectForKey:UPLOAD_DATE];
            newPhoto.totalLike = [objPhoto objectForKey:TOTAL_LIKE];
            newPhoto.thumnailPath = [objPhoto objectForKey:THUMNAIL_PATH];
            
            // Save Image with format data
//            dispatch_queue_t backgroundQueue = dispatch_queue_create("com.jack.queue", 0);
//            dispatch_async(backgroundQueue, ^{
//                
//                NSString *strUrl = [NSString stringWithFormat:@"%@%@",kServerURL,newPhoto.photoPath];
//                newPhoto.imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:strUrl]];
//                
//            });
            
            // Add photo to List Photo
            [listPhoto addObject:newPhoto];
        }
        
    } else {
        // Error
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[arrayResponseNotice objectAtIndex:1]
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        
    }
    
    // Good List - Set number of photo
    int sumRecord = [sumStr intValue];
    if(sumRecord == 0){
        numberPhoto.text = @"No photo";
    }else if(sumRecord == 1){
        numberPhoto.text = @"1 photo";
    }else{
        numberPhoto.text = [[NSString alloc]initWithFormat:@"%i photos",sumRecord];
    }
    
    [refreshControl endRefreshing];
    [collectViewImage reloadData];
    [self initStopPostData];
    [self stopLoadingMore];
    
}

- (void) requestFailed:(ASIHTTPRequest *) request {
    NSError *error = [request error];
    NSLog(@"%@", error);
    listPhoto = [[NSMutableArray alloc]init];
    numberPhoto.text = @"0 photo";
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Request Failed!" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil]show];
    [refreshControl endRefreshing];
    [collectViewImage reloadData];
    [self initStopPostData];
}

#pragma mark - Pass data before modal view controller

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPhoto"]) {
        NSArray *indexPaths = [collectViewImage indexPathsForSelectedItems];
        IMERPhotoDetailViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        destViewController.photo = [listPhoto objectAtIndex: indexPath.row];
        destViewController.dataArray = [listPhoto copy];
        destViewController.indexPath = indexPath;
        [collectViewImage deselectItemAtIndexPath:indexPath animated:NO];
    }
}



#pragma mark - CollectionView Footer Spinner Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(isLoading)
        return;
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (isLoading)
        return;
    if(collectViewImage.contentSize.height >= collectViewImage.frame.size.height){
        if (collectViewImage.contentOffset.y + collectViewImage.frame.size.height >= collectViewImage.contentSize.height - kCollectionFooterHeigt)
            [self startLoadingMore];
    }
    
}


- (void) startLoadingMore
{
    isLoading = YES;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectViewImage.collectionViewLayout;
    [UIView animateWithDuration: 0.3 animations: ^{
        [layout invalidateLayout];
    } completion: ^(BOOL finish){
        elementsCount = [listPhoto count];
        [self initPostDataService: pageNumber];     // first load will be kDefaultItemsCount
    }];
}


- (void)stopLoadingMore
{
    isLoading = NO;
    [UIView animateWithDuration: 0.3 animations: ^{
        if(elementsCount == [listPhoto count])
            [collectViewImage setContentOffset: CGPointMake(0, collectViewImage.contentOffset.y - kCollectionFooterHeigt)];
    } completion: ^(BOOL finish){
        [collectViewImage reloadData];
    }];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if(isLoading)
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, kCollectionFooterHeigt);
    else
        return CGSizeZero;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString: UICollectionElementKindSectionFooter] == YES)
        return [self createAndConfigureCollectionHeaderSectionViewAtIndexPath: indexPath];
    return nil;
}

- (UICollectionReusableView *) createAndConfigureCollectionHeaderSectionViewAtIndexPath: (NSIndexPath *) indexPath
{
    UICollectionReusableView *footerView = [[UICollectionReusableView alloc] initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kCollectionFooterHeigt)];
    footerView.backgroundColor = [UIColor clearColor];
    UIActivityIndicatorView *spinnerFooter = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    spinnerFooter.center = footerView.center;
    [footerView addSubview:spinnerFooter];
    [spinnerFooter startAnimating];
    return footerView;
}

@end

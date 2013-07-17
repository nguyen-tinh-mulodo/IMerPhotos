//
//  IMERHomeViewController.m
//  iMerPhotos
//
//  Created by nguyenkhoi on 6/10/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import "IMERHomeViewController.h"
#import "IMERPhotoDetailViewController.h"
#import "IMERUtils.h"
#import "IMERNSUserDefaults.h"
#import "IMERPostData.h"
#import "IMERPhoto.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
#import "MyImageView.h"
#import "IMERPostViewController.h"
#import "IMERUtils.h"

#define kCollectionFooterHeigt 60.0
#define kDefaultItemsCount 21

@interface IMERHomeViewController ()
@end

#if TARGET_IPHONE_SIMULATOR
NSString *test_device = @"simulator";
#else
NSString *test_device = @"device";
#endif


@implementation IMERHomeViewController
@synthesize collectionViewPack;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setup_layout
{
    
    titleNavBar.titleView = [IMERUtils myLabelWithText:@"New Photos"];
    
    spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 150, 20, 30)];
    [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.hidden = FALSE;
    [spinner startAnimating];
    [self.view addSubview:spinner];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // Init item image for tab bar
    UIImage *selectedImage0 = [UIImage imageNamed:@"rss_copy.png"];
    UIImage *unselectedImage0 = [UIImage imageNamed:@"rss.png"];
    
    UIImage *selectedImage1 = [UIImage imageNamed:@"house_copy.png"];
    UIImage *unselectedImage1 = [UIImage imageNamed:@"house.png"];
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    [item1 setAccessibilityLabel:@"Mine"];
    
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor redColor]];
    
    // ====================================
    
    
    [self setup_layout];
    pickerController = [[UIImagePickerController alloc]init];
    pickerController.delegate = self;
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    settingView = [storyboard instantiateViewControllerWithIdentifier:@"setting"];
    
    listPhoto = [[NSMutableArray alloc]init];
    pageNumber = 0;
    self.collectionViewPack.delegate=self;
    self.collectionViewPack.dataSource=self;
    [self loadData:pageNumber];
    
    arrayResponseNotice = [[NSArray alloc]init];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(changeSorting) forControlEvents:UIControlEventValueChanged];
    [collectionViewPack addSubview:refreshControl];
    
    [settingBtn setAccessibilityLabel:@"Settings"];
    [uploaderBtn setAccessibilityLabel:@"Upload"];
    
    [self.view setAccessibilityLabel:@"New Photos Page"];
}

-(void)viewWillAppear:(BOOL)animated {
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController.navigationBar setHidden:NO];
}

-(void)takePhoto{
    image = nil;
    imageData = nil;
    
    if ([test_device isEqualToString:@"simulator"]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Can't open camera on simulator!"
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    } else {
        [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        
    }
    
}


- (void)changeSorting
{
    //[listPhoto removeAllObjects];
    pageNumber =0;
    [UIView beginAnimations:@"MoveDown" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    [collectionViewPack setContentOffset:CGPointMake(0, -40)];
    [UIView commitAnimations];
    [self loadData:0];
}

-(void)loadData:(int)num{
    int offset =  num * kDefaultItemsCount;
    int limit = kDefaultItemsCount;
    dispatch_queue_t queue = dispatch_queue_create("com.mycompany.myqueue", 0);
    dispatch_async(queue, ^ {
        NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
        [dataPost setValue:[[IMERPostData alloc]initWithNewData:ID AndValue:[IMERNSUserDefaults getUserId]] forKey:@"0"];
        [dataPost setValue:[[IMERPostData alloc]initWithNewData:TOKEN AndValue:[IMERNSUserDefaults getToken]] forKey:@"1"];
        [dataPost setValue:[[IMERPostData alloc]initWithNewData:ID_NEED AndValue:[IMERNSUserDefaults getUserId]] forKey:@"2"];
        [dataPost setValue:[[IMERPostData alloc]initWithNewData:COUNT AndValue:[NSString stringWithFormat:@"%i", limit]] forKey:@"3"];
        [dataPost setValue:[[IMERPostData alloc]initWithNewData:TYPE AndValue:EXCLUDED] forKey:@"4"];
        [dataPost setValue:[[IMERPostData alloc]initWithNewData:OFFSET AndValue:[NSString stringWithFormat:@"%i", offset]] forKey:@"5"];
        pageNumber += 1;
        
        // Call function postDataServer to
        [IMERUtils postDataServer:dataPost url:API_GETPHOTOS controller:self];
        
    });
}

- (void)initStopPostData{
    spinner.hidden = true;
    [spinner stopAnimating];
}


- (void)didReceiveMemoryWarning
{
    [listPhoto removeAllObjects];
    listPhoto = nil;
    arrayResponseNotice = nil;
    collectionViewPack = nil;
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

-(IBAction)uploadBtnAction:(id)sender {
    [self presentViewController:pickerController animated:YES completion:nil];
}

-(IBAction)settingBtnAction:(id)sender{
    //[self performSegueWithIdentifier:@"homeToSetting" sender:self];
    [self presentViewController:settingView animated:YES completion:nil];
}

#pragma mark - UIImagePickerView Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [pickerController dismissViewControllerAnimated:YES completion:nil];
    NSData *temp_imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],0.5);
    UIImage *temp_image = [[UIImage alloc]initWithData:temp_imageData];
    UIImage *rotation_img = [IMERUtils rotateImage:temp_image];
    //image = rotation_img;
    if (rotation_img.size.width > 900) {
        image = [IMERUtils imageWithImage:rotation_img scaledToWidth:900.0];
    } else {
        image = rotation_img;
    }
    imageData = UIImageJPEGRepresentation(image, 1.0);
    
    [self performSegueWithIdentifier:@"homeToPost" sender:self];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [pickerController dismissViewControllerAnimated:YES completion:nil];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UINavigationItem *top = navigationController.navigationBar.topItem;
    top.titleView = [IMERUtils myLabelWithText:@"Upload"];
    UIBarButtonItem *secondButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhoto)];
    top.leftBarButtonItem = secondButton;
    top.leftBarButtonItem = secondButton;
    
}

#pragma mark - CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return listPhoto.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if ([listPhoto count] > 0) {
        IMERPhoto *photo = [listPhoto objectAtIndex: indexPath.row];
        // Show image
        UIImageView *test = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        [cell addSubview:test];
        [cell bringSubviewToFront:test];
        [test setContentMode:UIViewContentModeScaleAspectFill];
        
        //dispatch_queue_t backgroundQueue = dispatch_queue_create("com.mycompany.queue", 0);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [test setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kServerURL,photo.thumnailPath]] placeholderImage:[UIImage imageNamed:@""]];
            
        });
        
        cell.tag = [photo.photoId integerValue];
        cell.accessibilityLabel = @"Cell";
        
    }
    
    return cell;
}

#pragma mark - ASIHTTPRequest Delegate

//-----ASIHTTPRequest Delegate-----------
- (void) requestFinished:(ASIHTTPRequest *)request {
    arrayResponseNotice = [IMERUtils getResponseNoticeWithRequest:request];
    if ([[arrayResponseNotice objectAtIndex:0] isEqualToString:@"200"]) {
        // Get data object
        NSArray *data = [[[arrayResponseNotice objectAtIndex:2] objectForKey:RESPONSE]objectForKey:DATA];
        if(data.count < 1){
            // Empty list
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Don't have new photo"
                                       delegate:self
                              cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        }else{
            // Get photos list
            //[listPhoto removeAllObjects];
            if([refreshControl isRefreshing])
                [listPhoto removeAllObjects];
            for (NSDictionary *photo in data)
            {
                // Get Photo Object from json string
                NSDictionary *objPhoto = [photo objectForKey:PHOTO_UPCASE];
                // Init new photo from value that get from service
                IMERPhoto *newPhoto = [[IMERPhoto alloc]init];
                newPhoto.photoId = [objPhoto objectForKey:ID];
                newPhoto.comment = [objPhoto objectForKey:COMMENT];
                newPhoto.photoPath = [objPhoto objectForKey:PHOTO_PATH];
                newPhoto.userUploadId = [objPhoto objectForKey:USER_ID];
                newPhoto.upload_date = [objPhoto objectForKey:UPLOAD_DATE];
                newPhoto.totalLike = [objPhoto objectForKey:TOTAL_LIKE];
                newPhoto.username = [objPhoto objectForKey:USERNAME];
                newPhoto.isLiked = [objPhoto objectForKey:IS_LIKED];
                newPhoto.thumnailPath = [objPhoto objectForKey:THUMNAIL_PATH];
                // Save Image with format data
//                dispatch_queue_t backgroundQueue = dispatch_queue_create("com.jack.queue", 0);
//                dispatch_async(backgroundQueue, ^{
//                    
//                    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kServerURL,newPhoto.photoPath];
//                    newPhoto.imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:strUrl]];
//                    
//                });
                // Add photo to List Photo
                [listPhoto addObject:newPhoto];   
            }
        }
        
    } else {
        // Error
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[arrayResponseNotice objectAtIndex:1]
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    
    [self initStopPostData];
    [collectionViewPack reloadData];
    [refreshControl endRefreshing];
    [self stopLoadingMore];
    
    
    
}
- (void) requestStarted:(ASIHTTPRequest *) request {
    NSLog(@"request started...");
}

- (void) requestFailed:(ASIHTTPRequest *) request {
    NSError *error = [request error];
    NSLog(@"%@", error);
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Request Failed!" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil]show];
    
    [self initStopPostData];
}

#pragma mark - Pass data before modal another view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPhoto"]) {
        NSArray *indexPaths = [self.collectionViewPack indexPathsForSelectedItems];
        IMERPhotoDetailViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        destViewController.photo = [listPhoto objectAtIndex:[indexPath indexAtPosition:1]];
        destViewController.dataArray = [listPhoto copy];
        destViewController.indexPath = indexPath;
        [self.collectionViewPack deselectItemAtIndexPath:indexPath animated:NO];
    }
    
    if ([segue.identifier isEqualToString:@"homeToPost"]) {
        IMERPostViewController *destinationController = segue.destinationViewController;
        destinationController._image = image;
        destinationController._imageData = imageData;
    }
}


#pragma mark - CollectionView Footer Spinner Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(self.isLoading)
        return;
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isLoading)
        return;
    if(collectionViewPack.contentSize.height >= collectionViewPack.frame.size.height){
        if (collectionViewPack.contentOffset.y + collectionViewPack.frame.size.height >= (collectionViewPack.contentSize.height - kCollectionFooterHeigt+50))
            [self startLoadingMore];
    }
    
}


- (void) startLoadingMore
{
    self.isLoading = YES;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewPack.collectionViewLayout;
    [UIView animateWithDuration: 0.3 animations: ^{
        [layout invalidateLayout];
    } completion: ^(BOOL finish){
        self.elementsCount = [listPhoto count];
        [self loadData: pageNumber];     // first load will be kDefaultItemsCount
    }];
}


- (void)stopLoadingMore
{
    self.isLoading = NO;
    [UIView animateWithDuration: 0.3 animations: ^{
        if(self.elementsCount == [listPhoto count])
            [collectionViewPack setContentOffset: CGPointMake(0, collectionViewPack.contentOffset.y - kCollectionFooterHeigt)];
    } completion: ^(BOOL finish){
        [collectionViewPack reloadData];
    }];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if(self.isLoading)
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

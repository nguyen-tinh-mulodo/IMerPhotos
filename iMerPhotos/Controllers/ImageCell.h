//
//  ImageCell.h
//  Test
//
//  Created by Jack Dawson on 6/19/13.
//  Copyright (c) 2013 Jack Dawson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMERPhoto.h"

@interface ImageCell : UICollectionViewCell<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) NSString *imagePath;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


- (IBAction)handledoubleTap:(UIGestureRecognizer *)recognizer;
-(void)updateCell;
@end

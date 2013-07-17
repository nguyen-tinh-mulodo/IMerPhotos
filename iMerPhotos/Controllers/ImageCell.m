//
//  ImageCell.m
//  Test
//
//  Created by Jack Dawson on 6/19/13.
//  Copyright (c) 2013 Jack Dawson. All rights reserved.
//

#import "ImageCell.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
#import "IMERPhotoDetailViewController.h"
#import "UIImageView+WebCache.h"


@implementation ImageCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ImageCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    self.scrollView.contentSize = CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height);
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 1.5;
    //self.scrollView.clipsToBounds = YES ;
    self.scrollView.delegate = self ;
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)updateCell {
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    //self.imageView.image = [UIImage imageWithData:self.imageData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kServerURL,self.imagePath]] placeholderImage:[UIImage imageNamed:@""]];
        
    });

}


- (IBAction)handledoubleTap:(UIGestureRecognizer *)recognizer{
    if(self.imageView.contentMode == UIViewContentModeScaleAspectFit){
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    else
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end

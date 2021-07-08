//
//  PostGridCell.m
//  Instagram
//
//  Created by Emily Jiang on 7/8/21.
//

#import "PostGridCell.h"
#import <Parse/Parse.h>

@implementation PostGridCell

- (void)setPost:(Post *)post {
    _post = post;
    
    PFFileObject *img = post.image;
    [img getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error getting image: %@", error.localizedDescription);
        } else {
            UIImage *postImg = [UIImage imageWithData:data];
            postImg = [self resizeImage:postImg withSize:self.postSize];
            [self.pictureView setImage:postImg];
        }
    }];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

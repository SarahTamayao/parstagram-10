//
//  PostCell.m
//  Instagram
//
//  Created by Emily Jiang on 7/6/21.
//

#import "PostCell.h"
#import "Post.h"
#import "DateTools.h"
#import <QuartzCore/QuartzCore.h>

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configButtons];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configButtons {
    UIImageSymbolConfiguration *defaultConfig = [UIImageSymbolConfiguration configurationWithScale:UIImageSymbolScaleLarge];
    [self.likeButton setImage:[UIImage systemImageNamed:@"heart" withConfiguration:defaultConfig] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill" withConfiguration:defaultConfig] forState:UIControlStateSelected];
}

/* from Post.h
 @property (nonatomic, strong) NSString *postID;
 @property (nonatomic, strong) NSString *userID;
 @property (nonatomic, strong) PFUser *author;

 @property (nonatomic, strong) NSString *caption;
 @property (nonatomic, strong) PFFileObject *image;
 @property (nonatomic, strong) NSNumber *likeCount;
 @property (nonatomic, strong) NSNumber *commentCount;
 */

- (void)setPost:(Post *)post { // custom setter so PostCell can be reused
    _post = post;
    
    NSLog(@"Setting post! Post = %@", post);
    self.usernameLabel.text = post.author.username;
    self.likesLabel.text = [[NSString stringWithFormat:@"%@", post.likeCount] stringByAppendingString:@" likes"];
    self.captionLabel.text = post.caption; // how to have bold within??
    self.pfpView.layer.cornerRadius = 17;
    
    PFFileObject *img = post.image;
    [img getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error getting image: %@", error.localizedDescription);
        } else {
            UIImage *postImg = [UIImage imageWithData:data];
            [self.pictureView setImage:postImg];
        }
    }];
}

@end

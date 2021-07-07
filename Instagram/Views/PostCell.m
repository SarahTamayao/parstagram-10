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

- (void)setPost:(Post *)post { // custom setter so PostCell can be reused
    _post = post;
    
//    NSLog(@"Setting post! Post = %@", post);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.usernameLabel.text = post.author.username;
    self.likesLabel.text = [[NSString stringWithFormat:@"%@", post.likeCount] stringByAppendingString:@" likes"];
    self.captionLabel.text = post.caption; // how to have bold within??
    self.pfpView.layer.cornerRadius = 17;
    self.likeButton.selected = post.liked;
    self.timestampLabel.text = [post.createdAt timeAgoSinceNow];
    
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

- (void)refreshData {
    self.likesLabel.text = [[NSString stringWithFormat:@"%@", self.post.likeCount] stringByAppendingString:@" likes"];
}

- (IBAction)tapLike:(id)sender {
    if (self.post.liked) { // unlike it
        self.post.liked = false;
        self.likeButton.selected = false;
        self.post.likeCount = [NSNumber numberWithInt:[self.post.likeCount intValue]-1];
        [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"Unliked post");
            } else {
                NSLog(@"Error unliking post: %@", error.localizedDescription);
            }
        }];
    } else { // like it
        self.post.liked = true;
        self.likeButton.selected = true;
        self.post.likeCount = [NSNumber numberWithInt:[self.post.likeCount intValue]+1];
        [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"Liked post");
            } else {
                NSLog(@"Error liking post: %@", error.localizedDescription);
            }
        }];
    }
    [self refreshData]; // updates cell UI
}

@end

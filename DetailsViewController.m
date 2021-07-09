//
//  DetailsViewController.m
//  Instagram
//
//  Created by Emily Jiang on 7/7/21.
//

#import "DetailsViewController.h"
#import "DateTools.h"
#import <Parse/Parse.h>

@interface DetailsViewController ()
// public: @property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    self.navBar.title = [@"Post by @" stringByAppendingString:self.post.author.username];
    
    // config buttons
    UIImageSymbolConfiguration *defaultConfig = [UIImageSymbolConfiguration configurationWithScale:UIImageSymbolScaleLarge];
    [self.likeButton setImage:[UIImage systemImageNamed:@"heart" withConfiguration:defaultConfig] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill" withConfiguration:defaultConfig] forState:UIControlStateSelected];
    
    self.likeButton.selected = [self.post.likedBy containsObject:[PFUser currentUser].username];
    self.likeCountLabel.text = [[NSString stringWithFormat:@"%@", self.post.likeCount] stringByAppendingString:@" likes"];
    self.captionLabel.text = self.post.caption;
    
    // setup timestamp
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    self.timestampLabel.text = [[formatter stringFromDate:self.post.createdAt] stringByReplacingOccurrencesOfString:@", " withString:@" \u2022 "];
    
    // setup image
    PFFileObject *img = self.post.image;
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
    self.likeCountLabel.text = [[NSString stringWithFormat:@"%@", self.post.likeCount] stringByAppendingString:@" likes"];
}

- (IBAction)tapLike:(id)sender {
    if ([self.post.likedBy containsObject:[PFUser currentUser].username]) { // unlike it
        [self.post.likedBy removeObject:[PFUser currentUser].username];
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
        NSLog(@"Current user: %@", [PFUser currentUser].username);
        [self.post.likedBy addObject:[PFUser currentUser].username];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

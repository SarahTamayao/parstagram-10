//
//  User.m
//  Instagram
//
//  Created by Emily Jiang on 7/8/21.
//

#import "User.h"

@implementation User
@dynamic pfp;

/*
+ (void)changeUserPfp:(UIImage *)pfp withCompletion:(PFBooleanResultBlock)completion {
//    Post *newPost = [Post new];
//    newPost.image = [self getPFFileFromImage:image];
//    newPost.author = [PFUser currentUser];
//    newPost.caption = caption;
//    newPost.liked = false;
//    newPost.likeCount = @(0);
//    newPost.commentCount = @(0);
//    [newPost saveInBackgroundWithBlock:completion];
    User
}
 */

+ (void)changeUserPfp:(User *)user withPfp:(UIImage *)pfp completion:(PFBooleanResultBlock)completion {
    user.pfp = [self getPFFileFromImage:pfp];
    [user saveInBackgroundWithBlock:completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end

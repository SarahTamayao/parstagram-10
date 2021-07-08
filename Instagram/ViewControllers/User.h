//
//  User.h
//  Instagram
//
//  Created by Emily Jiang on 7/8/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser <PFSubclassing>
@property (nonatomic, strong) PFFileObject *pfp;

+ (void)changeUserPfp: (User *)user withPfp:(UIImage * _Nullable)pfp completion: (PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END

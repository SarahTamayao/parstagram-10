//
//  ProfileViewController.h
//  Instagram
//
//  Created by Emily Jiang on 7/8/21.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) User *user;

@end

NS_ASSUME_NONNULL_END

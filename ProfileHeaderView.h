//
//  ProfileHeaderView.h
//  Instagram
//
//  Created by Emily Jiang on 7/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *pfpView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postCountLabel;


@end

NS_ASSUME_NONNULL_END

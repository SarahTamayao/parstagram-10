//
//  PostGridCell.h
//  Instagram
//
//  Created by Emily Jiang on 7/8/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostGridCell : UICollectionViewCell
@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (nonatomic) CGSize postSize;

@end

NS_ASSUME_NONNULL_END

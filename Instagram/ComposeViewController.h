//
//  ComposeViewController.h
//  Instagram
//
//  Created by Emily Jiang on 7/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComposeViewController : UIViewController
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END

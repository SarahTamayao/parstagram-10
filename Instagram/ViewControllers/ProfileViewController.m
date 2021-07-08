//
//  ProfileViewController.m
//  Instagram
//
//  Created by Emily Jiang on 7/8/21.
//

#import "ProfileViewController.h"
#import "ComposeViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *pfpView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postCountLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    self.user = [PFUser currentUser];
    
    self.usernameLabel.text = self.user.username;
    
    PFFileObject *pfp = self.user.pfp;
    [pfp getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error fetching profile pic: %@", error.localizedDescription);
        } else {
            UIImage *pfpImg = [UIImage imageWithData:data];
            [self.pfpView setImage:pfpImg];
            self.pfpView.layer.cornerRadius = self.pfpView.frame.size.height/2;
        }
    }];
    
    [self.pfpView setUserInteractionEnabled:YES];
    [self.pfpView addGestureRecognizer:self.tapGesture];
}

- (IBAction)onTapPfp:(id)sender {
    NSLog(@"pfp tapped!");
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = true;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // camera is available
        UIAlertController *sourcePicker = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *pickCamera = [UIAlertAction actionWithTitle:@"Take picture" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }];
        UIAlertAction *pickLibrary = [UIAlertAction actionWithTitle:@"Select from photo library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [sourcePicker addAction:pickCamera];
        [sourcePicker addAction:pickLibrary];
        [sourcePicker addAction:cancelAction];
        [self presentViewController:sourcePicker animated:YES completion:^{}];
    } else {
        NSLog(@"Camera unavailable so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // need to actually change user pfp in parse database
    CGSize size = CGSizeMake(250, 250);
    UIImage *pfpImg = [self resizeImage:editedImage withSize:size];
    [self.pfpView setImage:pfpImg];
    [User changeUserPfp:self.user withPfp:pfpImg completion:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  ComposeViewController.m
//  Instagram
//
//  Created by Emily Jiang on 7/6/21.
//

#import "ComposeViewController.h"
#import "FeedViewController.h"
#import "SceneDelegate.h"
#import <Parse/Parse.h>
#import "Post.h"

@interface ComposeViewController () <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UITextView *captionText;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) UIImage *image;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.pictureView setUserInteractionEnabled:YES];
    [self.pictureView addGestureRecognizer:self.tapGesture];
    self.captionText.delegate = self;
    self.image = nil;
    // set up placeholder text
    self.captionText.text = @"Write a caption...";
    self.captionText.textColor = [UIColor lightGrayColor];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Write a caption..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write a caption...";
        textView.textColor = [UIColor lightGrayColor];
    }
}

- (IBAction)onTapImage:(id)sender {
    NSLog(@"image tapped!");
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
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
    // Get the image captured by the UIImagePickerController
//        UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
        UIImage *editedImage = info[UIImagePickerControllerEditedImage];

        // Do something with the images (based on your use case)
        self.image = editedImage;
        [self.pictureView setImage:self.image];
        
        // Dismiss UIImagePickerController to go back to your original view controller
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

- (IBAction)sendPost:(id)sender {
    if ([self.captionText.text length] > 2200) { // limit for insta captions is 2200 chars
        NSLog(@"Caption too long!");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot create post" message:@"Caption is above the 2200-character limit." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:dismissAction];
        [self presentViewController:alert animated:YES completion:^{}];
    } else if (self.image == nil) {
        NSLog(@"Image not set!");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot create post" message:@"An image has not been selected." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:dismissAction];
        [self presentViewController:alert animated:YES completion:^{}];
    } else { // valid post
        NSString *caption = self.captionText.text;
        CGSize size = CGSizeMake(400, 400);
        UIImage *image = [self resizeImage:self.image withSize:size];
        [Post postUserImage:image withCaption:caption withCompletion:nil];
        [self exitCreate];
    }
}

- (void)exitCreate {
    // clear out current assets, segue back to feed tab
    self.image = nil;
    [self.pictureView setImage:[UIImage imageNamed:@"image_placeholder"]];
    self.captionText.text = @"Write a caption...";
    self.captionText.textColor = [UIColor lightGrayColor];
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    sceneDelegate.window.rootViewController = tabBarController;
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)onExitCreate:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"If you exit, your edits will be discarded." message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Discard" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self exitCreate];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:deleteAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:^{}];
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

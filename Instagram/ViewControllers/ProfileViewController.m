//
//  ProfileViewController.m
//  Instagram
//
//  Created by Emily Jiang on 7/8/21.
//

#import "ProfileViewController.h"
#import "ComposeViewController.h"
#import "ProfileHeaderView.h"
#import "Post.h"
#import "PostGridCell.h"
#import <Parse/Parse.h>

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
//@property (weak, nonatomic) IBOutlet UIImageView *pfpView;
//@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *postCountLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//@property (weak, nonatomic) IBOutlet ProfileHeaderView *profileHeader;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic) CGSize postSize;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self fetchUserPosts];
}

- (void)setupView {
    self.user = [PFUser currentUser];
    self.posts = @[];
    
    // setup collection view
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowLayout.minimumLineSpacing = 1;
    self.flowLayout.minimumInteritemSpacing = 1;
    CGFloat postsPerLine = 3;
//    CGFloat width = (self.collectionView.frame.size.width - self.flowLayout.minimumInteritemSpacing*(postsPerLine - 1))/postsPerLine;
    CGFloat width = floorf((self.collectionView.frame.size.width - self.flowLayout.minimumInteritemSpacing*(postsPerLine - 1))/postsPerLine);
    NSLog(@"item width should be %f", width);
    CGFloat height = width;
    CGSize picSize = CGSizeMake(width, height);
    self.flowLayout.itemSize = picSize;
    self.postSize = picSize;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)fetchUserPosts {
    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery whereKey:@"author" equalTo:self.user];
    [postQuery orderByDescending:@"createdAt"];
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = posts;
            [self.collectionView reloadData];
//            self.profileHeader.postCountLabel.text = [NSString stringWithFormat:@"%i", self.posts.count];
        } else {
            NSLog(@"Error fetching this user's posts: %@", error.localizedDescription);
        }
    }];
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
//    [self.profileHeader.pfpView setImage:pfpImg];
    [User changeUserPfp:self.user withPfp:pfpImg completion:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.collectionView reloadData];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PostGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostGridCell" forIndexPath:indexPath];
    cell.post = self.posts[indexPath.item];
    cell.postSize = self.postSize;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ProfileHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProfileHeaderView" forIndexPath:indexPath];
    header.usernameLabel.text = self.user.username;
    header.postCountLabel.text = [NSString stringWithFormat:@"%lu", self.posts.count];
    [header.pfpView setUserInteractionEnabled:YES];
    [header.pfpView addGestureRecognizer:self.tapGesture];
    
    PFFileObject *pfp = self.user.pfp;
    [pfp getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error");
        } else {
            UIImage *pfpImg = [UIImage imageWithData:data];
            [header.pfpView setImage:pfpImg];
            header.pfpView.layer.cornerRadius = header.pfpView.frame.size.height/2;
        }
    }];
    return header;
}

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

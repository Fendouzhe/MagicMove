//
//  CollectionViewController.m
//  MagicMove
//
//  Created by 雷路荣 on 2018/7/28.
//  Copyright © 2018年 leilurong. All rights reserved.
//

#import "CollectionViewController.h"
#import "MagicMoveTransition.h"
#import "DetailViewController.h"

@interface CollectionViewController ()<UINavigationControllerDelegate>



@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"LRCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.backgroundColor = [UIColor blackColor];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LRCollectionViewCell class]) bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
//    [self.collectionView registerClass:[LRCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
//    
//    id cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LRCollectionViewCell class]) owner:self.collectionView options:nil].firstObject;
//    NSLog(@"cell = %@ UINib = %@",cell,nib);
    NSLog(@"class = %@",[self.view class]);//UICollectionViewControllerWrapperView
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    ///不能放在viewDidLoad 里面否则方法只会执行一次
    self.navigationController.delegate = self;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LRCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    //NSLog(@"cell = %@",cell);
    cell.iconView.image = [UIImage imageNamed:@"苹果设备分辨率"];
    cell.nameLab.text = @"MMBB";
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    self.selectCell = (LRCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"detail" sender:nil];
}
///在发送 segue 的时候，把点击的 image 发送给 DetailViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"detail"]) {
        DetailViewController *vc = (DetailViewController *)segue.destinationViewController;
        //vc.imageView.image = self.selectCell.iconView.image;//直接这样给imageView赋值没有效果
        vc.image = self.selectCell.iconView.image;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        return [MagicMoveTransition transitionType:LRTransitionAnimationTypePush];
    }
    return nil;
}

@end

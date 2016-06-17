//
//  PYPhotoCell.m
//  youzhu
//
//  Created by 谢培艺 on 16/2/19.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYPhotoCell.h"
#import "PYPhoto.h"
#import "PYPhotoView.h"
#import "PYPhotosView.h"
#import "PYConst.h"
#import "UIImageView+WebCache.h"
#import "PYDALabeledCircularProgressView.h"

@interface PYPhotoCell ()


@end

@implementation PYPhotoCell

// 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 创建contentScrollView
        UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, PYScreenW, PYScreenH)];
        // 取消滑动指示器
        contentScrollView.showsVerticalScrollIndicator = NO;
        contentScrollView.showsHorizontalScrollIndicator = NO;
        self.contentScrollView = contentScrollView;
        [self.contentView addSubview:contentScrollView];
        // 创建图片
        PYPhotoView *imageView = [[PYPhotoView alloc] init];
        imageView.isBig = YES;
        [self.contentScrollView addSubview:imageView];
        self.photoView = imageView;
    }
    return self;
}

- (void)setPhotoView:(PYPhotoView *)photoView
{
    _photoView = photoView;
    
    // 绑定photoCell
    photoView.photoCell = self;
}

// 设置图片（图片来源自网络）
- (void)setPhoto:(PYPhoto *)photo
{
    _photo = photo;
    // 设置图片状态
    self.photoView.photosView.photosState = PYPhotosViewStateDidCompose;

    [self.photoView setPhoto:photo];
    
    // 取出图片大小
    CGSize imageSize = self.photoView.image.size;
    CGFloat width;
    CGFloat height;
    if (self.photo.originalSize.width > self.photo.originalSize.height * 2) { // （原始图片）宽大于高的两倍
        height = PYScreenH;
        width = height * self.photo.originalSize.height / self.photo.originalSize.width;
    } else { // （原始图片）高大于宽
        height = PYScreenW * self.photo.originalSize.width / self.photo.originalSize.height > PYScreenH ? PYScreenH : PYScreenW * self.photo.originalSize.width / self.photo.originalSize.height;
        width = PYScreenW;
    }
    self.photoView.size = CGSizeMake(self.width, self.width * imageSize.height / imageSize.width);
    if (self.width > self.height) { // 横屏
        self.photoView.size = CGSizeMake(height, width);
    }
    
    self.photo.originalSize = self.photoView.size;
    self.photo.verticalWidth = self.photo.originalSize.width;
    
    // 放大图片
    // 设置scrollView的大小
    self.contentScrollView.size = self.photoView.size;
    self.contentScrollView.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    self.photoView.center = CGPointMake(self.contentScrollView.width * 0.5, self.contentScrollView.height * 0.5);
//    self.contentScrollView.backgroundColor = [UIColor greenColor];
//    self.backgroundColor = [UIColor yellowColor];
}

// 设置图片（图片来源自本地相册）
- (void)setImage:(UIImage *)image
{
    _image = image;
    self.photoView.image = image;
    // 设置图片状态
    self.photoView.photosView.photosState = PYPhotosViewStateWillCompose;
    // 取出图片大小
    CGSize imageSize = self.photoView.image.size;
    // 放大图片
    self.photoView.width = self.width;
    self.photoView.height = self.width * imageSize.height / imageSize.width;
    self.photoView.center = CGPointMake(self.photoView.width * 0.5, self.photoView.height * 0.5);
    // 设置scrollView的大小
    self.contentScrollView.size = self.photoView.size;
    self.contentScrollView.center = CGPointMake(self.width * 0.5, self.height * 0.5);
}

static NSString * const reuseIdentifier = @"Cell";

// 快速创建collectionCell
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    PYPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.size = CGSizeMake(collectionView.width - ((UICollectionViewFlowLayout *)collectionView.collectionViewLayout).minimumLineSpacing, collectionView.height);
    
    cell.collectionView = collectionView;
    return cell;
}

@end

//
//  PPPhotoCell.h
//  Photo Browser
//
//  Created by App Dev Wizard on 7/27/14.
//  Copyright (c) 2014 Pavel Palancica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPPhotoCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSDictionary *photo;

@end

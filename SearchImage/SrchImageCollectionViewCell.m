//
//  SrchImageCollectionViewCell.m
//  SearchImage
//
//  Created by 방문 사용자 on 2017. 11. 11..
//  Copyright © 2017년 방문 사용자. All rights reserved.
//

#import "SrchImageCollectionViewCell.h"

@implementation SrchImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgView.image = nil;
}

@end

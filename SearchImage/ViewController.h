//
//  ViewController.h
//  SearchImage
//
//  Created by 방문 사용자 on 2017. 11. 11..
//  Copyright © 2017년 방문 사용자. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSUInteger, NSCellType) {
    NSNullCellType = 0,
    NSNaverCellType = 1,
    NSKakaoCellType = 2
};

@interface ViewController : UIViewController<UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource>{
    NSDictionary* srchResultDic;
    NSArray* enginesArr;
    NSUInteger curEngineType;
    NSArray* itemsArr;
}
@property (weak, nonatomic) IBOutlet UITextField *tfSearchEngine;
@property (weak, nonatomic) IBOutlet UITableView *dropDownView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (nonatomic, weak) IBOutlet UITextField* tfSearch;
@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView* loadingView;
@end


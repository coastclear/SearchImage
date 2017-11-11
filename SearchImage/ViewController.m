//
//  ViewController.m
//  SearchImage
//
//  Created by 방문 사용자 on 2017. 11. 11..
//  Copyright © 2017년 방문 사용자. All rights reserved.
//

#import "ViewController.h"
#import "SrchImageCollectionViewCell.h"

// 네이버 이미지 검색 API, CLIENT ID, CLIENT KEY
NSString* const kUrlSearchImageNaver = @"https://openapi.naver.com/v1/search/image";
NSString* const kClientIdNaver = @"tMJidjRtbJ97GpuFStu3";
NSString* const kClientKeyNaver = @"tUg1FQ7yAy";

// 카카오 이미지 검색 API
NSString* const kUrlSearchImageKakao = @"https://dapi.kakao.com/v2/search/image";
NSString* const kAppKeyKakao = @"6e15a595ee0623dde772c0e66527e5a1";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    curEngineType = NSNullCellType;
    srchResultDic = [NSDictionary dictionary];
    itemsArr = [NSArray array];
    enginesArr = @[@"네이버 이미지 검색 API", @"카카오 이미지 검색 API"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"SrchImageCollectionViewCell" bundle:nil]   forCellWithReuseIdentifier: @"searchImage"];
    
    [_tfSearch addTarget:self action:@selector(didChangeSearchKeyword:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)didChangeSearchKeyword:(UITextField* )textField{
    if(textField != nil){
        NSLog(@"Keyword %@", textField.text);
        [self callSrchApi];
    }
}

// 네이버 검색 API 호출
- (void)reqSrchNaver{
    NSString* keyword = @"";
    if([_tfSearch.text length] > 0)
        keyword = _tfSearch.text;
    
    // 검색어가 없을 경우에 불필요한 api 호출하지 않도록 처리
    if(keyword.length > 0){
        [_loadingView startAnimating];
        NSDictionary* param = @{@"query":keyword, @"display":@80};
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setValue:kClientIdNaver forHTTPHeaderField:@"X-Naver-Client-Id"];
        [manager.requestSerializer setValue:kClientKeyNaver forHTTPHeaderField:@"X-Naver-Client-Secret"];
        [manager GET:kUrlSearchImageNaver parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [_loadingView stopAnimating];
            NSLog(@"JSON: %@", responseObject);
            if(responseObject){
                srchResultDic = (NSDictionary*)responseObject;
                if(srchResultDic){
                    itemsArr = srchResultDic[@"items"];
                    if([itemsArr count] > 0){
                        _collectionView.hidden = NO;
                        _emptyView.hidden = YES;
                        [_collectionView reloadData];
                    }else{
                        _collectionView.hidden = YES;
                        _emptyView.hidden = NO;
                    }
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [_loadingView stopAnimating];
            NSLog(@"Error: %@", error);
        }];
    }else{
        itemsArr = [NSArray array];
        _collectionView.hidden = YES;
        _emptyView.hidden = NO;
    }
}

// 카카오 검색 API 호출
- (void)reqSrchKakao{
    NSString* keyword = @"";
    if([_tfSearch.text length] > 0)
        keyword = _tfSearch.text;
    
    // 검색어가 없을 경우에 불필요한 api 호출하지 않도록 처리
    if(keyword.length > 0){
        [_loadingView startAnimating];
        NSDictionary* param = @{@"query":keyword};
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"KakaoAK %@", kAppKeyKakao] forHTTPHeaderField:@"Authorization"];
        
        [manager GET:kUrlSearchImageKakao parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [_loadingView stopAnimating];
            NSLog(@"JSON: %@", responseObject);
            if(responseObject){
                srchResultDic = (NSDictionary*)responseObject;
                if(srchResultDic){
                    itemsArr = srchResultDic[@"documents"];
                    if([itemsArr count] > 0){
                        _collectionView.hidden = NO;
                        _emptyView.hidden = YES;
                        [_collectionView reloadData];
                    }else{
                        _collectionView.hidden = YES;
                        _emptyView.hidden = NO;
                    }
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [_loadingView stopAnimating];
            NSLog(@"Error: %@", error);
        }];
    }else{
        itemsArr = [NSArray array];
        _collectionView.hidden = YES;
        _emptyView.hidden = NO;
    }
}

- (void)callSrchApi{
    if(curEngineType == NSNaverCellType)
        [self reqSrchNaver];
    else if(curEngineType == NSKakaoCellType)
        [self reqSrchKakao];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if(![touch.view isMemberOfClass:[UITextField class]]) {
        [touch.view endEditing:YES];
    }
}

#pragma mark - TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == _tfSearchEngine){
        _dropDownView.hidden = NO;
        [textField endEditing:YES];
    }
}

// Done 버튼 선택시 키보드 내리게 처리
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [itemsArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SrchImageCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchImage" forIndexPath:indexPath];

    NSString* imageUrl = @"";
    if(curEngineType == NSNaverCellType)
        imageUrl = [[itemsArr objectAtIndex:indexPath.row] objectForKey:@"thumbnail"];
    else
        imageUrl = [[itemsArr objectAtIndex:indexPath.row] objectForKey:@"thumbnail_url"];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
    [cell.imgView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"placeholder"] success:nil failure:nil];
    
    return cell;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [enginesArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"engineCell"];
    cell.textLabel.text = [enginesArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _tfSearchEngine.text = [enginesArr objectAtIndex:indexPath.row];
    _dropDownView.hidden = YES;
    curEngineType = indexPath.row + 1;
    [self callSrchApi];
}

@end

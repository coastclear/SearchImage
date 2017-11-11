//
//  AppDelegate.h
//  SearchImage
//
//  Created by 방문 사용자 on 2017. 11. 11..
//  Copyright © 2017년 방문 사용자. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


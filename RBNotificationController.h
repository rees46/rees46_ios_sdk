//
//  RBNotificationController.h
//  kupikupon
//
//  Created by Василий Думанов on 31.01.15.
//  Copyright (c) 2015 kupikupon.ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBNotificationController : UIViewController

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *rbTitle;
@property (nonatomic, strong) NSString *rbDescription;

@property (nonatomic, strong) UIBarButtonItem *rbControllerBackButton;
@property (nonatomic, strong) NSString *rbControllerBarTitle;

@end

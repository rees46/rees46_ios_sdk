//
//  RBNotificationController.m
//  kupikupon
//
//  Created by Василий Думанов on 31.01.15.
//  Copyright (c) 2015 kupikupon.ru. All rights reserved.
//

#import "RBNotificationController.h"

@interface RBNotificationController() <UINavigationBarDelegate>

@property (nonatomic, strong) UIImageView *rbImageView;
@property (nonatomic, strong) UILabel *rbTitleLabel;
@property (nonatomic, strong) UILabel *rbDescriptionLabel;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation RBNotificationController

-(instancetype)init {
    
    if (self = [super init]) {
        
        
        
        
    }
    
    return self;
    
}

-(void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Добавляем navigationBar
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    navBar.delegate = self;
    navBar.barStyle = UIBarStyleDefault;
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle: self.rbControllerBarTitle ? self.rbControllerBarTitle : @"Акция"];
    
    if (!self.rbControllerBackButton) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
        navItem.leftBarButtonItem = backButton;
    } else {
        self.rbControllerBackButton.target = self;
        self.rbControllerBackButton.action = @selector(dismiss);
        navItem.leftBarButtonItem = self.rbControllerBackButton;
    }
    
    navBar.items = @[navItem];
    [self.view addSubview:navBar];
    
    //Создаем UIScrollView
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:scrollView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:64]];
    
    //Добавляем contentView к scrollView
    
    UIView *contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [scrollView addSubview:contentView];
    
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:scrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:contentView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:scrollView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:contentView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:scrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:contentView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:contentView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[contentView(320)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(contentView)]];
    
    //Добавляем постер
    
    UIImageView *rbImageView = [[UIImageView alloc] init];
    rbImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [contentView addSubview:rbImageView];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:rbImageView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute 
                                                    multiplier:1.0 
                                                      constant:70]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:rbImageView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0
                                                             constant:70]];
    
    /*[contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[rbImageView(70)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(rbImageView)]];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[rbImageView(70)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(rbImageView)]];*/
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:rbImageView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:242.0]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:rbImageView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:contentView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:18.0]];
    
    /*[contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:rbImageView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0
                                                             constant:18.0]];*/

    
    //NSString *testString = [NSString stringWithFormat:@"%f %f", self.rbImageView.frame.size.width, self.rbImageView.frame.size.height];
    
    dispatch_queue_t myQueue = dispatch_queue_create("imageQueue",NULL);
    dispatch_async(myQueue, ^{
        
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test"
                                                            message:@"here we are"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];*/
            
            /*CGFloat imageWidth = img.size.width;
            CGFloat imageHeight = img.size.height;
            
            CGFloat ratio = rbImageView.frame.size.width / imageWidth;
            CGFloat newImageViewHeight = (int)(imageHeight * ratio);
            
            CGRect newImageRect = rbImageView.frame;
            newImageRect.size.height = newImageViewHeight;
            rbImageView.frame = newImageRect;*/
            
            [rbImageView setImage:img];
            
        });
        
    });
    
    
    //Добавляем заголовок
    
    UILabel *rbTitleLabel = [[UILabel alloc] init];
    rbTitleLabel.text = self.rbTitle;
    rbTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    rbTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    rbTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    rbTitleLabel.numberOfLines = 0;
    
     [contentView addSubview:rbTitleLabel];
     
     [contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:rbTitleLabel
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0
                                                            constant:17.0]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:rbTitleLabel
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0
                                                             constant:21]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:rbTitleLabel
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0
                                                             constant:206]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:rbTitleLabel
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:rbImageView
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.0
                                                            constant:0]];
    
    //Добавляем описание
    
    UILabel *rbDescriptionLabel = [[UILabel alloc] init];
    rbDescriptionLabel.text = self.rbDescription;
    rbDescriptionLabel.font = [UIFont systemFontOfSize:15];
    rbDescriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    rbDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    rbDescriptionLabel.numberOfLines = 0;
    
    [contentView addSubview:rbDescriptionLabel];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:rbDescriptionLabel
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0
                                                             constant:13.0]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:rbDescriptionLabel
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0
                                                             constant:299]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:rbDescriptionLabel
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0
                                                             constant:21]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:rbDescriptionLabel
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0
                                                             constant:10.0]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:rbTitleLabel
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                               toItem:rbDescriptionLabel
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0
                                                             constant:33.0]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:rbDescriptionLabel
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:rbImageView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0
                                                             constant:23.0]];
    
    
    
}

-(void)dismiss {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UINavigationBarDelegate

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    
    return UIBarPositionTopAttached;
    
}

@end

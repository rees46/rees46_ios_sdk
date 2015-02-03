//
//  RBManager.h
//  kupikupon
//
//  Created by Василий Думанов on 31.01.15.
//  Copyright (c) 2015 kupikupon.ru. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    RBUserInformationId,
    RBUserInformationEmail
} RBUserInformation;

typedef enum : NSUInteger {
    RBEventTypeView,
    RBEventTypeCart,
    RBEventTypePurchase,
} RBEventType;

@interface RBManager : NSObject

@property (nonatomic, strong) NSString *shopIdentifier;
@property (nonatomic, assign) int major;
@property (nonatomic, assign) int leadMinor;
@property (nonatomic, assign) int conversionMinor;
@property (nonatomic, strong) NSString *ssid;
@property (nonatomic, strong) NSDictionary *userInformation;

@property (nonatomic, strong) UIBarButtonItem *rbControllerBackButton;
@property (nonatomic, strong) NSString *rbControllerBarTitle;

+(id)sharedManager;
-(id)setupWithShopIdentifer:(NSString*)shopIdentifier major:(int)major leadMinor:(int)leadMinor conversionMinor:(int)conversionMinor;
-(void)startBunchManager;
-(void)stopBunchManager;
-(void)processIncomingNotification:(UILocalNotification*)notification;

-(void)willSendInformationAboutBeacon:(BNCHBunch*)bunch;
-(void)triggerEventWithType:(RBEventType)eventType informationDictionary:(NSDictionary*)infDict;
-(void)getUserInformationWithURL:(NSString*)url;

@end

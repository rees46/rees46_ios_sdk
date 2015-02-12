//
//  RBManager.m
//  kupikupon
//
//  Created by Василий Думанов on 31.01.15.
//  Copyright (c) 2015 kupikupon.ru. All rights reserved.
//

#import "RBManager.h"
#import <CoreLocation/CoreLocation.h>
#import "UIDevice+ModelDetailed.h"
#import "AppDelegate.h"
#import "RBNotificationController.h"
#import "NSDictionary+UrlEncoding.h"

//Импортируем хедеры BunchSDK

#import "BNCHBunch.h"
#import "BNCHBunchDefinitions.h"
#import "BNCHBunchManager.h"
#import "BNCHBunchRegion.h"
#import "BNCHMutableBunch.h"

@interface RBManager() <CLLocationManagerDelegate, BNCHBunchManagerDelegate>

@property (nonatomic, strong) BNCHBunchManager *bunchManager;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) BNCHBunchRegion *bunchRegionLead;
@property (nonatomic, strong) BNCHBunchRegion *bunchRegionConversion;


@end

@implementation RBManager {
    
    BOOL _checkBeaconsWhenInRegionLead;
    BOOL _checkBeaconsWhenInRegionConversion;
    
    NSUserDefaults *_userDefaults;
    
}

+(RBManager*)sharedManager {
    
    static dispatch_once_t p = 0;
    
    __strong static RBManager *_sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
    
}

-(instancetype)init {
    
    if (self = [super init]) {
        
        _userDefaults = [NSUserDefaults standardUserDefaults];
        
        //Если система страше 8.0, запрашиваем разрешение на использование геолокации
        
        if ([[UIDevice currentDevice].systemVersion doubleValue] > 8.0 && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
            _locationManager =[[CLLocationManager alloc] init];
            [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
            _locationManager.delegate = self;
            
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [_locationManager requestAlwaysAuthorization];
            }
        }
        
    }
    
    return self;
}

-(id)setupWithShopIdentifer:(NSString*)shopIdentifier major:(int)major leadMinor:(int)leadMinor conversionMinor:(int)conversionMinor {
    
    self.shopIdentifier = shopIdentifier;
    self.major = major;
    self.leadMinor = leadMinor;
    self.conversionMinor = conversionMinor;
    
    //Инициализируем банч менеджер
    
    self.bunchManager = [[BNCHBunchManager alloc]init];
    
    // Set delegate
    [self.bunchManager setDelegate:self];
    
    self.bunchRegionLead = [[BNCHBunchRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"16E913B6-6EB9-4869-A1FC-3AC5CEB58AEE"] major:_major minor:_leadMinor identifier:@"RBManager_region_lead"];
    self.bunchRegionLead.notifyEntryStateOnDisplay = YES;
    self.bunchRegionLead.notifyOnEntry = YES;
    self.bunchRegionLead.notifyOnExit = YES;
    
    self.bunchRegionConversion = [[BNCHBunchRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"16E913B6-6EB9-4869-A1FC-3AC5CEB58AEE"] major:_major minor:_conversionMinor identifier:@"RBManager_region_conversion"];
    self.bunchRegionConversion.notifyEntryStateOnDisplay = YES;
    self.bunchRegionConversion.notifyOnEntry = YES;
    self.bunchRegionConversion.notifyOnExit = YES;
    
    _checkBeaconsWhenInRegionLead = NO;
    _checkBeaconsWhenInRegionConversion = NO;
    
    //Получаем ssid
    
    [self getSsid];
    
    return self;
    
}

-(void)getSsid {
    
    NSString *ssid = [_userDefaults objectForKey:@"rbssid"];
    
    if (!ssid) {
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        NSString *urlText = [NSString stringWithFormat:@"http://api.rees46.com/generate_ssid?shop_id=%@", _shopIdentifier];
        NSURL *url = [NSURL URLWithString:urlText];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (!connectionError) {
                self.ssid = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [_userDefaults setObject:self.ssid forKey:@"rbssid"];
                [_userDefaults synchronize];
            }
            
        }];
        
    } else {
        self.ssid = ssid;
    }
    
}

-(void)startBunchManager {
    
    [self.bunchManager startMonitoringForRegion:_bunchRegionLead];
    [self.bunchManager requestStateForRegion:_bunchRegionLead];
    [self.bunchManager startRangingBunchesInRegion:_bunchRegionLead];
    
    
    [self.bunchManager startMonitoringForRegion:_bunchRegionConversion];
    [self.bunchManager requestStateForRegion:_bunchRegionConversion];
    [self.bunchManager startRangingBunchesInRegion:_bunchRegionConversion];
    
}

-(void)stopBunchManager {
    
    [self.bunchManager stopRangingBunchesInRegion:_bunchRegionLead];
    [self.bunchManager stopMonitoringForRegion:_bunchRegionLead];
    
    [self.bunchManager stopRangingBunchesInRegion:_bunchRegionConversion];
    [self.bunchManager stopMonitoringForRegion:_bunchRegionConversion];
    
}

-(void)dealloc {
    
    [self stopBunchManager];
    self.bunchManager.delegate = nil;
    self.bunchManager = nil;
    
    if (self.locationManager) {
        self.locationManager.delegate = nil;
        self.locationManager = nil;
    }
    
}

-(void)willSendInformationAboutBeacon:(BNCHBunch*)bunch {
    
    NSString *type;
    
    if ([bunch.major intValue] == _major && [bunch.minor intValue] == _leadMinor) {
        
        type = @"lead";
        
    } else if ([bunch.major intValue] == _major && [bunch.minor intValue] == _conversionMinor) {
        
        type = @"conversion";
        
    }
    
    if (self.ssid != nil) {
        
        NSString *deviceType = [[UIDevice currentDevice].model isEqualToString:@"iPad"] ? @"tablet" : @"phone";
        NSString *deviceVersion = [[UIDevice modelDetailed] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *beaconRequestString = [NSString stringWithFormat:@"http://api.rees46.com/geo/notify?shop_id=%@&ssid=%@&type=%@&uuid=%@&major=%@&minor=%@&platform=ios&device_type=%@&device_version=%@", _shopIdentifier, self.ssid, type, bunch.proximityUUID, bunch.major, bunch.minor, deviceType, deviceVersion];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        NSURL *url = [NSURL URLWithString:beaconRequestString];
        NSURLRequest *beaconRequest = [NSURLRequest requestWithURL:url];
        
        [NSURLConnection sendAsynchronousRequest:beaconRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (!connectionError) {
                
                if (response != nil) {
                    
                    NSError *jsonError;
                    NSMutableDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                    if (responseDictionary[@"image"] == nil || responseDictionary[@"title"] == nil || responseDictionary[@"description"] == nil) {
                        return;
                    }
                    
                    if ([type isEqualToString:@"lead"]) {
                        [self sendNotificationWithDictionary:responseDictionary];
                    }
                    
                }
                
            } else {
                
            }
            
        }];
    }
}

-(void)sendNotificationWithDictionary:(NSMutableDictionary*)responseDictionary {
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.alertBody = [NSString stringWithFormat:@"%@!\nАкция от БургерКинг и КупиКупон! Предъявите купон на кассе ресторана БургерКинг и получите скидку!",responseDictionary[@"title"]];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:@[@"RBNotification", responseDictionary] forKeys:@[@"name", @"responseDictionary"]];
    notification.userInfo = userInfo;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
}

-(void)processIncomingNotification:(UILocalNotification*)notification {
    
    if (notification.userInfo && [notification.userInfo[@"name"] isEqualToString:@"RBNotification"]) {
        
        NSDictionary *responseDictionary = notification.userInfo[@"responseDictionary"];
        
        RBNotificationController *rbNotificationController = [[RBNotificationController alloc] init];
        rbNotificationController.rbTitle = responseDictionary[@"title"];
        rbNotificationController.imageUrl = responseDictionary[@"image"];
        rbNotificationController.rbDescription = responseDictionary[@"description"];
        rbNotificationController.rbControllerBackButton = self.rbControllerBackButton;
        
        if (self.rbControllerBarTitle) {
            rbNotificationController.rbControllerBarTitle = self.rbControllerBarTitle;
        }
        
        if (self.rbControllerBackButton) {
            rbNotificationController.rbControllerBackButton = self.rbControllerBackButton;
        }
        
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]).window.rootViewController presentViewController:rbNotificationController animated:YES completion:nil];
        
        
    }
    
}

-(void)triggerEventWithType:(RBEventType)eventType informationDictionary:(NSDictionary*)infDict {
    
    if (!self.ssid) {
        return;
    }
    
    NSString *eventToString;
    
    switch (eventType) {
        case RBEventTypeView:
            eventToString = @"view";
            break;
        case RBEventTypeCart:
            eventToString = @"cart";
            break;
        case RBEventTypePurchase:
            eventToString = @"purchase";
            break;
        default:
            break;
    }
    
    NSMutableString *categoryString = [NSMutableString string];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"event": eventToString,
                                                                                  @"shop_id": self.shopIdentifier,
                                                                                  @"ssid": self.ssid}];
    
    if (eventType != RBEventTypePurchase) {
        
        NSArray *categories = (NSArray*)infDict[@"categories"];
        
        if (categories != nil) {
            for (NSNumber* category in categories) {
                [categoryString appendString:[category stringValue]];
                if (![[categories lastObject] isEqual:category]) {
                    [categoryString appendString:@","];
                }
            }
        } else {
            categoryString = [NSMutableString stringWithFormat:@"0"];
        }
        
        [params setObject:infDict[@"itemId"] forKey:@"item_id[0]"];
        [params setObject:infDict[@"itemCost"] forKey:@"price[0]"];
        [params setObject:categoryString forKey:@"categories[0]"];
        
    } else if (eventType == RBEventTypePurchase) {
        
        for (int i = 0; i < ((NSArray*)infDict[@"itemIds"]).count; i ++) {
            
            NSArray *categories = (NSArray*)(infDict[@"categories"][i]);
            
            if (categories != nil) {
                for (NSNumber* category in categories) {
                    [categoryString appendString:[category stringValue]];
                    if (![[categories lastObject] isEqual:category]) {
                        [categoryString appendString:@","];
                    }
                }
            } else {
                categoryString = [NSMutableString stringWithFormat:@"0"];
            }
            
            if (!infDict[@"itemQuantities"][i] || !infDict[@"orderId"]) {
                return;
            }
            
            [params setObject:infDict[@"itemIds"][i] forKey:[NSString stringWithFormat:@"item_id[%d]", i]];
            [params setObject:infDict[@"itemCosts"][i] forKey: [NSString stringWithFormat:@"price[%d]", i]];
            [params setObject:categoryString forKey: [NSString stringWithFormat: @"categories[%d]", i]];
            [params setObject:infDict[@"itemQuantities"][i] forKey:[NSString stringWithFormat:@"amount[%d]", i]];
            
        }
        
        [params setObject:infDict[@"orderId"] forKey:@"order_id"];
        
    }
    
    if (self.userInformation) {
        
        if (self.userInformation[@"id"]) {
            [params setObject:self.userInformation[@"id"] forKey:@"user_id"];
        }
        
        if (self.userInformation[@"email"]) {
            [params setObject:self.userInformation[@"email"] forKey:@"user_email"];
        }
        
    }
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSString *queryString = [@"http://api.rees46.com/push?" stringByAppendingString:[params urlEncodedString]];
    NSURL *url = [NSURL URLWithString:queryString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (!connectionError) {
            
        }
        
    }];
    
}


-(void)getUserInformationWithURL:(NSString *)urlString {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSDictionary *userDict = [_userDefaults objectForKey:@"RBUserInformation"];
    
    if (!userDict) {
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (!connectionError) {
                NSError *jsonError;
                NSMutableDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError][@"response"];
                
                if (responseDictionary != nil && responseDictionary[@"id"] && responseDictionary[@"email"]) {
                    
                    self.userInformation = @{@"id" : responseDictionary[@"id"],
                                             @"email" : responseDictionary[@"email"]};
                    [_userDefaults setObject:self.userInformation forKey:@"RBUserInformation"];
                    [_userDefaults synchronize];
                    
                    
                } else {
                    
                    
                    
                }
                
            }
            
        }];
    } else {
        self.userInformation = [NSDictionary dictionaryWithDictionary:userDict];
    }
    
    
}

#pragma mark - BNCHBunchManagerDelegate

-(void)bunchManager:(BNCHBunchManager *)manager didEnterRegion:(BNCHBunchRegion *)region {
    
    if ([region.minor intValue] == _leadMinor) {
        _checkBeaconsWhenInRegionLead = YES;
    } else if ([region.minor intValue] == _conversionMinor) {
        _checkBeaconsWhenInRegionConversion = YES;
    }
    
}

-(void)bunchManager:(BNCHBunchManager *)manager didRangeBunches:(NSArray *)bunches inRegion:(BNCHBunchRegion *)region {
    
    if ([region.minor intValue] == _leadMinor && _checkBeaconsWhenInRegionLead) {
        
        for (BNCHBunch *bunch in bunches) {
            
            [self willSendInformationAboutBeacon:bunch];
            _checkBeaconsWhenInRegionLead = NO;
            
        }
    }
    
    if ([region.minor intValue] == _conversionMinor && _checkBeaconsWhenInRegionConversion) {
        
        for (BNCHBunch *bunch in bunches) {
            
            [self willSendInformationAboutBeacon:bunch];
            _checkBeaconsWhenInRegionConversion = NO;
            
        }
    }
    
}



@end

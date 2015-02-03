//
//  UIDevice+ModelDetailed.m
//  kupikupon
//
//  Created by Василий Думанов on 30.12.14.
//  Copyright (c) 2014 kupikupon.ru. All rights reserved.
//

#import "UIDevice+ModelDetailed.h"
#import <sys/sysctl.h>

@implementation UIDevice (ModelDetailed)

+(NSString*)modelDetailed {
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    NSString *deviceVersion = [self platformType:platform];
    free(machine);
    
    return deviceVersion;
    
}

+(NSString *)platformType:(NSString *)platform
{
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    else if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    else if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    else if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    else if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    else if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    else if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    else if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    else if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    else if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    else if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    else if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    else if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    else if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    else if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    else if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    else if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    else if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    else if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    else if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    else if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    else if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    else if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    else if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    else if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    else if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    else if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    else if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    else if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    else if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    else if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    else if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    else if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    else if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    else if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    else if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    else if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    else if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    else if ([platform isEqualToString:@"i386"])         return @"Simulator";
    else if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    else return @"Unknown iOS device";
    return platform;
}


@end

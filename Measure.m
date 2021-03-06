//
//  Measure.m
//  MobileSignal
//
//  Created by Nicolas Seriot on 11/16/10.
//  Copyright 2010 seriot.ch. All rights reserved.
//

#import "Measure.h"
#import <CoreLocation/CoreLocation.h>

@implementation Measure

@synthesize networkType;
@synthesize signalStrength;
@synthesize networkName;
@synthesize date;
@synthesize location;

+ (NSString *)stringForNetworkType:(NSUInteger)aNetworkType {
	if(aNetworkType == 0) return @"GSM";
	if(aNetworkType == 1) return @"Edge";
	if(aNetworkType == 2) return @"3G";
	if(aNetworkType == 5) return @"Wifi";
	
	return nil;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ - %@ - %d - %d - %f %f", date, networkName, networkType, signalStrength, location.coordinate.latitude, location.coordinate.longitude];
}

- (void)dealloc {
	[networkName release];
	[date release];
	[location release];
	
	[super dealloc];
}

+ (Measure *)measureWithStatusBarData:(StatusBarData *)statusBarData location:(CLLocation *)aLocation {
	
	NSInteger gsmSignalStrengthRaw = statusBarData->gsmSignalStrengthRaw;
    
    //NSInteger dataNetworkType = statusBarData->dataNetworkType;
    
    // Since iOS 5, statusBarData->dataNetworkType returns always 0.
    // Therefore, we read in the status bar view to get this value.
    
    NSUInteger dataNetworkType = [[UIApplication dataNetworkTypeFromStatusBar] integerValue];
	
    char* serviceString = (char *)statusBarData->serviceString;
	    
	NSString *aNetworkName = [NSString stringWithCString:serviceString encoding:NSUTF8StringEncoding];

	Measure *m = [[Measure alloc] init];
	
	m.date = [NSDate date];
	m.networkName = aNetworkName;
	m.networkType = dataNetworkType;
	m.signalStrength = gsmSignalStrengthRaw;
	m.location = aLocation;
	
	return [m autorelease];
}

@end

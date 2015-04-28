//
//  OfficeAnnotation.m
//  PromexicoTest
//
//  Created by iOS developer on 4/27/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//


#import "OfficeAnnotation.h"
#import "DatabaseConstants.m"

@implementation OfficeAnnotation

@synthesize officeData;
@synthesize coordinate;

- (id)initWithOfficeData:(NSDictionary *)data andCoordinate:(CLLocationCoordinate2D)coord
{
    if ((self = [super init])) {
        officeData = data;
        coordinate = coord;
    }
    return self;
}

- (NSString *)title {
    return [officeData objectForKey:DB_FIELD_OFFICE_KEY];
}

- (NSString *)subtitle {
    return [officeData objectForKey:DB_FIELD_OFFICE_LOCATION];
}


@end


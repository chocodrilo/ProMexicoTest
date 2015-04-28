//
//  OfficeAnnotation.h
//  PromexicoTest
//
//  Created by iOS developer on 4/27/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface OfficeAnnotation : NSObject <MKAnnotation>


@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSDictionary *officeData;

- (id)initWithOfficeData:(NSDictionary *)officeData andCoordinate:(CLLocationCoordinate2D)coordinate;

@end


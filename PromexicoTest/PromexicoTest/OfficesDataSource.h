//
//  OfficesDataSource.h
//  PromexicoTest
//
//  Created by iOS developer on 4/27/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import "SQLiteDataSource.h"

@interface OfficesDataSource : SQLiteDataSource

-(void)insertOfficesData:(NSArray *)officeData;
-(NSArray *)getOffices;
-(void)insertSurveyForOffice:(NSString *)officeKey andPerson:(NSString *)person andTreatment:(NSNumber *)treatment andInformation:(NSNumber *)information andPlaceClean:(NSNumber *)placeClean andImageData:(NSData *)imageData;

@end

//
//  OfficesDataSource.m
//  PromexicoTest
//
//  Created by iOS developer on 4/27/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import "OfficesDataSource.h"
#import "WSConstants.m"

@implementation OfficesDataSource

#pragma mark
#pragma mark  Public Methods

-(void)insertOfficesData:(NSArray *)officeData
{
    for (NSDictionary *dicc in officeData) {
        NSMutableDictionary *mutDicc = [dicc mutableCopy];
        NSString *coordinates = [mutDicc objectForKey:WS_KEY_COORDINATES];
        NSArray *coordArray = [coordinates componentsSeparatedByString:@","];
        if(coordArray.count == 2)
        {
            NSString *latitude = [coordArray objectAtIndex:0];
            NSString *longitude = [coordArray objectAtIndex:1];
            [mutDicc setObject:[NSNumber numberWithDouble:latitude.doubleValue] forKey:DB_FIELD_OFFICE_LATITUDE];
            [mutDicc setObject:[NSNumber numberWithDouble:longitude.doubleValue] forKey:DB_FIELD_OFFICE_LONGITUDE];
            [mutDicc removeObjectForKey:WS_KEY_COORDINATES];
            [self inserOrUpdateOfficeData:mutDicc];
        }
    }
}

-(NSArray *)getOffices
{
    return [self executeQuery:@"select * from OficinasExterior"];
}

-(void)insertSurveyForOffice:(NSString *)officeKey andPerson:(NSString *)person andTreatment:(NSNumber *)treatment andInformation:(NSNumber *)information andPlaceClean:(NSNumber *)placeClean andImageData:(NSData *)imageData
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];

    [db executeUpdate:@"insert into RespuestaEncuesta (COffice,PersonaAtendio,TratoBueno,InformacionAdecuada,LugarLimpio,ImagenEncuesta) values (?,?,?,?,?,?)",officeKey,person,treatment,information,placeClean,imageData];
    [db close];
}

#pragma mark
#pragma mark  Private Methods

-(void)inserOrUpdateOfficeData:(NSMutableDictionary *)officeData
{
    NSString *officeId = [officeData objectForKey:DB_FIELD_OFFICE_KEY];
    NSArray *arr = [self executeQuery:[NSString stringWithFormat:@"select * from OficinasExterior where %@ = '%@'",DB_FIELD_OFFICE_KEY,officeId]];
    if(arr && arr.count > 0)
    {
        [officeData removeObjectForKey:DB_FIELD_OFFICE_KEY];
        [self executeUpdateOperation:@"OficinasExterior" andData:officeData andFilter:[NSDictionary dictionaryWithObject:officeId forKey:DB_FIELD_OFFICE_KEY]];
    }
    else
    {
        [self executeInsertOperation:@"OficinasExterior" andData:officeData];
    }
}


@end

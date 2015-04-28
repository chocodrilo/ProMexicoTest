
#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "DatabaseConstants.m"

@interface SQLiteDataSource : NSObject
{
    NSString *dbPath;
    NSDateFormatter *insertDateTimeFormatter;
}

-(id)executeQuery:(NSString *)query;
-(id)executeSingleSelect:(NSString *)tableName andColumnNames:(NSArray *)columnNames andFilter:(NSDictionary *)filterData andLimit:(int)limit;
-(BOOL)executeInsertOperation:(NSString *)tableName andData:(NSDictionary *)insertData;
-(NSString *)executeUpdateOperation:(NSString *)tableName andData:(NSDictionary *)updateData andFilter:(NSDictionary *)filterData;
-(BOOL)executeDeleteOperation:(NSString *)tableName andFilter:(NSDictionary *)filter;
-(NSArray *)parseResultSetForQuery:(NSString *)sql;


@end

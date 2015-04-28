

#import "SQLiteDataSource.h"

@implementation SQLiteDataSource

#pragma mark
#pragma mark  Initialization Methods

-(id)init
{
    self = [super init];
    if(self)
    {
        [self createAndCheckDatabase];
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDir = [documentPaths objectAtIndex:0];
        dbPath = [documentDir stringByAppendingPathComponent:@"Promexico.db"];
        insertDateTimeFormatter = [[NSDateFormatter alloc] init];
        [insertDateTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [insertDateTimeFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"es_ES"]];
        [insertDateTimeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    }
    return self;
}

#pragma mark
#pragma mark  Public Methods

-(id)executeQuery:(NSString *)query
{
    return  [self parseResultSetForQuery:query];
}

-(id)executeSingleSelect:(NSString *)tableName andColumnNames:(NSArray *)columnNames andFilter:(NSDictionary *)filterData andLimit:(int)limit
{
    
    NSString *sql = @"select ";
    if(columnNames && columnNames.count > 0)
    {
        for(int i = 0; i < columnNames.count; i++)
        {
            if(i == columnNames.count-1)
            {
                sql = [sql stringByAppendingFormat:@" %@", [columnNames objectAtIndex:i]];
            }
            else
            {
                sql = [sql stringByAppendingFormat:@" %@,", [columnNames objectAtIndex:i]];
            }
        }
    }
    else
    {
        sql = [sql stringByAppendingString:@" *"];
    }
    
    sql = [sql stringByAppendingFormat:@" from %@",tableName];
    
    if(filterData && filterData.count > 0)
    {
        sql = [sql stringByAppendingString:@" where "];
        NSArray *keys = filterData.allKeys;
        for(int i = 0; i < keys.count; i++)
        {
            NSString *key = [keys objectAtIndex:i];
            NSString *sqlVar;
            if([[filterData objectForKey:key] isKindOfClass:[NSString class]])
            {
                sqlVar = [NSString stringWithFormat:@"%@ ='%@'",key,[filterData objectForKey:key]];
            }
            else
            {
                sqlVar = [NSString stringWithFormat:@"%@ = %@",key,[filterData objectForKey:key]];
            }
            if(i != keys.count-1)
            {
                sqlVar = [sqlVar stringByAppendingString:@" AND"];
            }
            sql = [sql stringByAppendingFormat:@" %@",sqlVar];
        }
    }
    
    if(limit > 0)
    {
        sql = [sql stringByAppendingFormat:@" limit %i",limit];
    }
    
    return  [self parseResultSetForQuery:sql];
}


-(BOOL)executeInsertOperation:(NSString *)tableName andData:(NSDictionary *)insertData
{
    if(insertData && insertData.allKeys.count > 0)
    {
        NSArray *keys = insertData.allKeys;
        NSString *sql = [NSString stringWithFormat: @"insert into %@ ",tableName];
        sql = [sql stringByAppendingString:@" ("];
        for(int i = 0; i < keys.count; i++)
        {
            if(i == keys.count-1)
            {
                sql = [sql stringByAppendingFormat:@" %@", [keys objectAtIndex:i]];
            }
            else
            {
                sql = [sql stringByAppendingFormat:@" %@,", [keys objectAtIndex:i]];
            }
        }
        sql = [sql stringByAppendingString:@" ) "];
        sql = [sql stringByAppendingString:@" values "];
        sql = [sql stringByAppendingString:@" ( "];
        for(int i = 0; i < keys.count; i++)
        {
            NSString *key = [keys objectAtIndex:i];
            NSString *sqlVar;
            if([[insertData objectForKey:key] isKindOfClass:[NSString class]])
            {
                sqlVar = [NSString stringWithFormat:@"'%@'",[insertData objectForKey:key]];
            }
            else if([[insertData objectForKey:key] isKindOfClass:[NSDate class]])
            {
                sqlVar = [NSString stringWithFormat:@"'%@'",[insertDateTimeFormatter stringFromDate:[insertData objectForKey:key]]];
            }
            else
            {
                sqlVar = [NSString stringWithFormat:@"%@",[insertData objectForKey:key]];
            }
            if(i != keys.count-1)
            {
                sqlVar = [sqlVar stringByAppendingString:@","];
            }
            sql = [sql stringByAppendingFormat:@" %@",sqlVar];
        }
        sql = [sql stringByAppendingString:@" ) "];
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        [queue inDatabase:^(FMDatabase *database) {
            [database executeUpdate:sql];
            
        }];
        return YES;
    }
    else
    {
        return NO;
    }
    
}


-(NSString *)executeUpdateOperation:(NSString *)tableName andData:(NSDictionary *)updateData andFilter:(NSDictionary *)filterData
{
    if(updateData && updateData.allKeys.count > 0)
    {
        NSString *sql = [NSString stringWithFormat: @"update %@ set ",tableName];
        NSArray *updateKeys = updateData.allKeys;
        for(int i = 0; i < updateKeys.count; i++)
        {
            NSString *key = [updateKeys objectAtIndex:i];
            NSString *sqlVar;
            if([[updateData objectForKey:key] isKindOfClass:[NSString class]])
            {
                sqlVar = [NSString stringWithFormat:@ "%@ ='%@'",key,[updateData objectForKey:key]];
            }
            else
            {
                sqlVar = [NSString stringWithFormat:@" %@ = %@",key,[updateData objectForKey:key]];
            }
            if(i != updateKeys.count-1)
            {
                sqlVar = [sqlVar stringByAppendingString:@","];
            }
            sql = [sql stringByAppendingFormat:@" %@",sqlVar];
        }
        if(filterData && filterData.allKeys.count > 0 )
        {
            sql = [sql stringByAppendingString:@" where "];
            NSArray *filterKeys = filterData.allKeys;
            for(int i = 0; i < filterKeys.count; i++)
            {
                NSString *key = [filterKeys objectAtIndex:i];
                NSString *sqlVar;
                if([[filterData objectForKey:key] isKindOfClass:[NSString class]])
                {
                    sqlVar = [NSString stringWithFormat:@" %@ ='%@'",key,[filterData objectForKey:key]];
                }
                else
                {
                    sqlVar = [NSString stringWithFormat:@" %@ = %@",key,[filterData objectForKey:key]];
                }
                if(i != filterKeys.count-1)
                {
                    sqlVar = [sqlVar stringByAppendingString:@" AND"];
                }
                sql = [sql stringByAppendingFormat:@" %@",sqlVar];
            }
        }
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        [queue inDatabase:^(FMDatabase *database) {
            [database executeUpdate:sql];
            
        }];
        return sql;
    }
    else
    {
        return @"";
    }
}

-(BOOL)executeDeleteOperation:(NSString *)tableName andFilter:(NSDictionary *)filterData
{
    NSString *sql = [NSString stringWithFormat: @"delete from %@ ",tableName];
    if(filterData && filterData.count > 0)
    {
        sql = [sql stringByAppendingString:@" where "];
        NSArray *filterKeys = filterData.allKeys;
        for(int i = 0; i < filterKeys.count; i++)
        {
            NSString *key = [filterKeys objectAtIndex:i];
            NSString *sqlVar;
            if([[filterData objectForKey:key] isKindOfClass:[NSString class]])
            {
                sqlVar = [NSString stringWithFormat:@" %@ ='%@'",key,[filterData objectForKey:key]];
            }
            else
            {
                sqlVar = [NSString stringWithFormat:@" %@ = %@",key,[filterData objectForKey:key]];
            }
            if(i != filterKeys.count-1)
            {
                sqlVar = [sqlVar stringByAppendingString:@","];
            }
            sql = [sql stringByAppendingFormat:@" %@",sqlVar];
        }
    }
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    [queue inDatabase:^(FMDatabase *database) {
        [database executeUpdate:sql];
        
    }];
    return YES;
}


#pragma mark
#pragma mark  Private Methods

-(NSArray *)parseResultSetForQuery:(NSString *)sql
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    FMResultSet *s = [db executeQuery:sql];
    while ([s next]) {
        int num = s.columnCount;
        NSMutableDictionary *dicc = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < num; i++) {
            NSString *columName = [s columnNameForIndex:i];
            [dicc setObject:[s objectForColumnName:columName] forKey:columName];
        }
        [arr addObject:dicc];
    }
    [db close];
    return arr;
}

-(void) createAndCheckDatabase
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath]
                                     stringByAppendingPathComponent:@"Promexico.db"];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSString* destinationPath = [documentDir stringByAppendingPathComponent:@"Promexico.db"];
    success = [fileManager fileExistsAtPath:destinationPath];
    if(!success)
    {
        NSError *error;
        [fileManager copyItemAtPath:databasePathFromApp toPath:destinationPath error:&error];
    }
    
}

@end

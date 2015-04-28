//
//  PromexicoSynchronizationManager.m
//  PromexicoTest
//
//  Created by iOS developer on 4/27/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import "PromexicoSynchronizationManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ZipArchive.h"

@implementation PromexicoSynchronizationManager

@synthesize delegate;

#pragma mark
#pragma mark Initialization methods

-(id)initWithDelegate:(id<PromexicoSynchronizationDelegate>)del
{
    self = [super init];
    if(self)
    {
        self.delegate = del;
        sqlDataSource = [[OfficesDataSource alloc] init];
    }
    return self;
}

#pragma mark
#pragma mark Public methods

-(void)loadOffices
{
    NSString *url = [NSString stringWithFormat:@"%@?UID=44201dbb-34c4-487a-92ea-2ce6f36e4644&formato=JSON",WEB_API_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* escapedUrlString = [url stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    [manager GET:escapedUrlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *officesArray = (NSArray *) [responseObject objectForKey:WS_KEY_OFFICES_ARRAY];
        [sqlDataSource insertOfficesData:officesArray];
        [delegate finishedLoadingOffices];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate failedLoadingOfficesWithError:error];
    }];
}

-(void)backupDatabase
{
    BOOL isDir=NO;
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *subpaths;
    
    NSString *toCompress = @"Promexico.db";
    NSString *pathToCompress = [documentsDirectory stringByAppendingPathComponent:toCompress];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:pathToCompress isDirectory:&isDir] && isDir){
        subpaths = [fileManager subpathsAtPath:pathToCompress];
    } else if ([fileManager fileExistsAtPath:pathToCompress]) {
        subpaths = [NSArray arrayWithObject:pathToCompress];
    }
    NSString *zipFilePath = [documentsDirectory stringByAppendingPathComponent:@"ZippedDatabase.zip"];
    ZipArchive *za = [[ZipArchive alloc] init];
    [za CreateZipFile2:zipFilePath Password:ZIP_PASSWORD];
    if (isDir) {
        for(NSString *path in subpaths){
            NSString *fullPath = [pathToCompress stringByAppendingPathComponent:path];
            if([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir){
                [za addFileToZip:fullPath newname:path];
            }
        }
    } else {
        [za addFileToZip:pathToCompress newname:toCompress];
    }
    [za CloseZipFile2];
}

@end

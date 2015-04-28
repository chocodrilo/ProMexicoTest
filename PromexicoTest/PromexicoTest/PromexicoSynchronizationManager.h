//
//  PromexicoSynchronizationManager.h
//  PromexicoTest
//
//  Created by iOS developer on 4/27/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSConstants.m"
#import "OfficesDataSource.h"

#define WEB_API_URL @"http://plataforma.promexico.gob.mx/sys/gateway.aspx"

#define ZIP_PASSWORD @"Camelt0sis"

@protocol PromexicoSynchronizationDelegate

-(void)finishedLoadingOffices;
-(void)failedLoadingOfficesWithError:(NSError *)error;

@end

@interface PromexicoSynchronizationManager : NSObject
{
    OfficesDataSource *sqlDataSource;
}

@property (nonatomic,assign) id<PromexicoSynchronizationDelegate> delegate;

-(id)initWithDelegate:(id<PromexicoSynchronizationDelegate>)del;

-(void)loadOffices;
-(void)backupDatabase;

@end
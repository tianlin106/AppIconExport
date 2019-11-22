//
//  AGUtil.h
//  AppGenerator
//
//  Created by  William Sterling on 14-11-28.
//  Copyright (c) 2014年  William Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoggerClient.h"
#import "mypopen.h"

void write_log_file(NSString *path, NSString *format, ...);

@interface AGUtil : NSObject

+ (NSDateFormatter*)dateFormatter;
+ (BOOL)runCMD:(NSString*)cmd output:(NSString **)output errorDescription:(NSString **)errorDescription;

+ (BOOL)runProcessAsAdministrator:(NSString*)scriptPath withArguments:(NSArray *)arguments output:(NSString **)output errorDescription:(NSString **)errorDescription;

@end

//
//  AGUtil.m
//  AppGenerator
//
//  Created by  William Sterling on 14-11-28.
//  Copyright (c) 2014年  William Sterling. All rights reserved.
//

#import "AGUtil.h"
#import "AGLogSetting.h"

void write_log_file(NSString *path, NSString *format, ...)
{
    if (format == nil) {
        printf("nil\n");
        return;
    }
    
    va_list argList;
    va_start(argList, format);
    
    NSMutableString *s = [[NSMutableString alloc] initWithFormat:format
                                                       arguments:argList];
    [s replaceOccurrencesOfString: @"%%"
                       withString: @"%%%%"
                          options: 0
                            range: NSMakeRange(0, [s length])];
    NSString *date = [NSString stringWithFormat:@"【%@】 ", [[AGUtil dateFormatter] stringFromDate:NSDate.date]];
    [s insertString:date atIndex:0];
    
    if ( [AGLogSetting sharedInstance].level > 0 )
    {
        if ( path.length > 0 )
        {
            [s insertString:@"\n" atIndex:0];
            NSData *dataToWrite = [s dataUsingEncoding: NSUTF8StringEncoding];
            NSFileHandle* outputFile = [NSFileHandle fileHandleForWritingAtPath:path];
            [outputFile seekToEndOfFile];
            [outputFile writeData:dataToWrite];
        }
        
        printf("%s\n", [s UTF8String]);
    }
    
    va_end(argList);
}

@implementation AGUtil

+ (NSDateFormatter*)dateFormatter
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        formatter.locale = [NSLocale currentLocale];
    });
    
    return formatter;
}

+ (BOOL)runProcessAsAdministrator:(NSString*)scriptPath
                     withArguments:(NSArray *)arguments
                            output:(NSString **)output
                  errorDescription:(NSString **)errorDescription
{
    
    NSString * allArgs = [arguments componentsJoinedByString:@" "];
    NSString * fullScript = [NSString stringWithFormat:@"%@ %@", scriptPath, allArgs];
    
    NSDictionary *errorInfo = [NSDictionary new];
    NSString *script =  [NSString stringWithFormat:@"do shell script \"%@\" with administrator privileges", fullScript];
    
    NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
    NSAppleEventDescriptor * eventResult = [appleScript executeAndReturnError:&errorInfo];
    
    // Check errorInfo
    if (! eventResult)
    {
        // Describe common errors
        *errorDescription = nil;
        if ([errorInfo valueForKey:NSAppleScriptErrorNumber])
        {
            NSNumber * errorNumber = (NSNumber *)[errorInfo valueForKey:NSAppleScriptErrorNumber];
            if ([errorNumber intValue] == -128)
                *errorDescription = @"The administrator password is required to do this.";
        }
        
        // Set error message from provided message
        if (*errorDescription == nil)
        {
            if ([errorInfo valueForKey:NSAppleScriptErrorMessage])
                *errorDescription =  (NSString *)[errorInfo valueForKey:NSAppleScriptErrorMessage];
        }
        
        return NO;
    }
    else
    {
        // Set output to the AppleScript's output
        *output = [eventResult stringValue];
        
        return YES;
    }
}

+ (BOOL)runCMD:(NSString*)cmd output:(NSString **)output errorDescription:(NSString **)errorDescription;
{
    FILE *fp;
    NSString *result = nil;
    char buf[1024] = {0};
    
    if((fp=popen([cmd cStringUsingEncoding:NSUTF8StringEncoding],"r"))==NULL)
    {
        perror("popen");
        exit(1);
    }
    
    while (fgets(buf, 1024,fp))
    {
        result = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
        
        if ( [AGLogSetting sharedInstance].level >= 2 )
        {
            //FLOG([AGLogSetting sharedInstance].logfile, result);
        }
        
        result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        memset(buf, 0, 1024);
    }
    
    if ( output && result ) *output = result;
    
    int ret = pclose(fp);
    return ret == 0;
}
@end

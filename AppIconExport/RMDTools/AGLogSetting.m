//
//  AGLogSetting.m
//  AppGenerator
//
//  Created by  William Sterling on 14-12-5.
//  Copyright (c) 2014年  William Sterling. All rights reserved.
//

#import "AGLogSetting.h"
#import "AGUtil.h"


@implementation AGLogSetting

+ (instancetype)sharedInstance
{
    static AGLogSetting *__log_setting__ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __log_setting__ = [[AGLogSetting alloc] init];
    });
    
    return __log_setting__;
}

- (void)appendLog:(NSString*)path format:(NSString*) format, ...
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
    [s appendString:@"\n"];
    
    va_end(argList);

    [_content appendString:s];
    if ( _logChanged )
    {
        _logChanged();
    }
}
@end

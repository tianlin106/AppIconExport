//
//  AGLogSetting.h
//  AppGenerator
//
//  Created by  William Sterling on 14-12-5.
//  Copyright (c) 2014年  William Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGLogSetting : NSObject

@property (assign)  NSInteger         level;
@property (copy,atomic)    NSString        * logfile;
@property (strong, atomic)  NSMutableString * content;
@property (copy)    void (^logChanged)();

+ (instancetype)sharedInstance;
- (void)appendLog:(NSString*)path format:(NSString*) format, ...;
@end

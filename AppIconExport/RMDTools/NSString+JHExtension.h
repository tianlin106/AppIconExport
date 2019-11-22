//
//  NSString+JHExtension.h
//  JHFoundation
//
//  Created by William Sterling on 14-9-1.
//  Copyright (c) 2014年 William Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JHExtension)

@property (nonatomic, readonly) BOOL                    empty;

+ (NSString*)base64Encode:(NSData*)data;
- (BOOL)contain:(NSString*)subString;
- (BOOL)match:(NSString *)expression;
- (NSString *)trim;

@end

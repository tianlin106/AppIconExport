//
//  PKImageManager.h
//  AppGenerator
//
//  Created by pk on 2019/11/6.
//  Copyright © 2019  William Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKImageManager : NSObject

+ (instancetype)shareImageManager;

- (void)replaceAppiconWithImageUrl:(NSString *)imageUrl andSaveGourpPath:(NSString *)groupPath;


@end

NS_ASSUME_NONNULL_END

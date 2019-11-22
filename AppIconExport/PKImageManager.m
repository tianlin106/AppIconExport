//
//  PKImageManager.m
//  AppGenerator
//
//  Created by pk on 2019/11/6.
//  Copyright © 2019  William Sterling. All rights reserved.
//

#import "PKImageManager.h"
#import "NSString+NormalMethod.h"
#import <Cocoa/Cocoa.h>
#import "AGUtil.h"




@implementation PKImageManager

+ (instancetype)shareImageManager{
    static dispatch_once_t onceToken;
    static PKImageManager *imageManager = nil;
    dispatch_once(&onceToken, ^{
        imageManager = [[PKImageManager alloc] init];
    });
    return imageManager;
}

#pragma mark - 导出图片太大
//+ (void)replaceAppiconWithImageUrl:(NSString *)imageUrl andSaveGourpPath:(NSString *)groupPath{
//
//    NSArray * name_array=@[@"Icon-Notify@2x.png",@"Icon-Notify@3x.png",@"Icon-Small@2x.png",@"Icon-Small@3x.png", @"Icon-Small-40@2x.png",@"Icon-Small-40@3x.png",@"Icon-60@2x.png",@"Icon-60@3x.png",@"Icon-1024.png"];
//    NSArray *  size_array=@[@40,@60,@58,@87,@80,@120,@120,@180,@1024];
////    NSString * imagePath = [[NSBundle mainBundle] pathForResource:@"appgirl.jpg" ofType:nil];
//    NSData * imageData = nil;
////    NSData * imageData = [NSData dataWithContentsOfFile:imagePath];
//    if ([imageUrl containsString:@"http"]) {
//        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
//    }else{
//        imageData = [NSData dataWithContentsOfFile:imageUrl];
//    }
//    NSImage * image = [[NSImage alloc] initWithData:imageData];
//
//    for (int i = 0; i<name_array.count; i++) {
//        NSString * imageName = [name_array objectAtIndex:i];
//        NSNumber * sizeN = [size_array objectAtIndex:i];
//        NSImage * resizeImage = [image resizeImageToNewSize:CGSizeMake(sizeN.intValue*0.5, sizeN.intValue*0.5)];
//        NSFileManager * fileManager = [NSFileManager defaultManager];
////        NSString *desktop = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)[0];
//        NSString * resultPath = [groupPath stringByAppendingString:imageName];
//        [fileManager createFileAtPath:resultPath contents:resizeImage.TIFFRepresentation attributes:nil];
//    }
//}


//+ (void)replaceAppiconWithImageUrl:(NSString *)imageUrl andSaveGourpPath:(NSString *)groupPath{
//
//    NSArray * name_array=@[@"Icon-Notify@2x.png",@"Icon-Notify@3x.png",@"Icon-Small@2x.png",@"Icon-Small@3x.png", @"Icon-Small-40@2x.png",@"Icon-Small-40@3x.png",@"Icon-60@2x.png",@"Icon-60@3x.png",@"Icon-1024.png"];
//    NSArray *  size_array=@[@40,@60,@58,@87,@80,@120,@120,@180,@1024];
//    NSData * imageData = nil;
//    if ([imageUrl containsString:@"http"]) {
//        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
//    }else{
//        imageData = [NSData dataWithContentsOfFile:imageUrl];
//    }
//    NSImage * image = [[NSImage alloc] initWithData:imageData];
//    NSFileManager * fileManager = [NSFileManager defaultManager];
//    //直接保存1024的图片
//    NSString * resultPath = @"";
////    NSString * resultPath = [groupPath stringByAppendingString:@"Icon-1024.png"];
////    [fileManager createFileAtPath:resultPath contents:imageData attributes:nil];
//
//    for (int i = 0; i<name_array.count; i++) {
//        NSString * imageName = [name_array objectAtIndex:i];
//        NSNumber * sizeN = [size_array objectAtIndex:i];
//        NSImage * resizeImage = [image resizeImageToNewSize:CGSizeMake(sizeN.intValue*0.5, sizeN.intValue*0.5)];
//        resultPath = [groupPath stringByAppendingString:imageName];
//        [resizeImage lockFocus];
//        //先设置 下面一个实例
//        NSBitmapImageRep *bits = [[NSBitmapImageRep alloc]initWithFocusedViewRect:NSMakeRect(0, 0, sizeN.intValue*0.5, sizeN.intValue*0.5)];
//        [resizeImage unlockFocus];
//
//        //再设置后面要用到得 props属性
//        NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:0] forKey:NSImageCompressionFactor];
//
//        //之后 转化为NSData 以便存到文件中
//        NSData *imageData = [bits representationUsingType:NSPNGFileType properties:imageProps];
//        [imageData writeToFile:resultPath atomically:YES];
//    }
//}




- (void)replaceAppiconWithImageUrl:(NSString *)imageUrl andSaveGourpPath:(NSString *)groupPath{
    
    NSArray * name_array=@[@"Icon-Notify@2x.png",@"Icon-Notify@3x.png",@"Icon-Small@2x.png",@"Icon-Small@3x.png", @"Icon-Small-40@2x.png",@"Icon-Small-40@3x.png",@"Icon-60@2x.png",@"Icon-60@3x.png",@"Icon-1024.png"];
    NSArray *  size_array=@[@40,@60,@58,@87,@80,@120,@120,@180,@1024];
    NSData * imageData = nil;
    if ([imageUrl containsString:@"http"]) {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    }else{
        imageData = [NSData dataWithContentsOfFile:imageUrl];
    }

    NSString * resultPath = @"";
    NSString * originFilePath = imageUrl;
    
    BOOL isFailure = NO;
    for (int i = 0; i<name_array.count; i++) {
        NSString * imageName = [name_array objectAtIndex:i];
        NSNumber * sizeN = [size_array objectAtIndex:i];
        
        resultPath = [groupPath stringByAppendingPathComponent:imageName];
        NSString *subImageFile = resultPath;
        NSString *cmd = [NSString stringWithFormat:@"sips -z %@ %@ %@ --out %@", sizeN.stringValue, sizeN.stringValue,originFilePath,subImageFile];
        if ( ![AGUtil runCMD:cmd output:nil errorDescription:nil] )
        {
            isFailure = YES;
        }
    }
    
    if (isFailure == YES) {
       NSAlert *anAlert = [[NSAlert alloc] init];
       anAlert.messageText = @"Error";
       anAlert.informativeText = @"Export Failure";
       [anAlert runModal];
    }else{
        NSAlert *anAlert = [[NSAlert alloc] init];
        anAlert.messageText = @"Good news!";
        anAlert.informativeText = @"Export succrss!";
        [anAlert runModal];
        
    }
}


@end

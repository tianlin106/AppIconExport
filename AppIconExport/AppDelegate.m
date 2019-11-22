//
//  AppDelegate.m
//  AppIconExport
//
//  Created by pk on 2019/11/8.
//  Copyright © 2019 pk. All rights reserved.
//

#import "AppDelegate.h"
#import "PKImageManager.h"

@interface AppDelegate ()<NSTextFieldDelegate>

@property (weak) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSImageView *imageView;

@property (weak) IBOutlet NSTextField *originImagePath;

@property (weak) IBOutlet NSButton *chooseInputBtn;

@property (weak) IBOutlet NSTextField *outImagePath;

@property (weak) IBOutlet NSButton *chooseOutBtn;

@property (weak) IBOutlet NSButton *startOutBtn;

@property (nonatomic,strong)NSImage * placeHolderImage;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSString * dataPath = [[NSBundle mainBundle] pathForResource:@"imageHolder.jpeg" ofType:nil];
    NSData * imageData = [NSData dataWithContentsOfFile:dataPath];
    NSImage * image = [[NSImage alloc] initWithData:imageData];
    self.placeHolderImage = image;
    self.imageView.image = image;
    
    self.originImagePath.delegate = self;
    
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)chooseInputAction:(id)sender {
    NSLog(@"chooseInputAction");
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    __weak typeof(self) _wks = self;
    //是否可以创建文件夹
    panel.canCreateDirectories = YES;
    //是否可以选择文件夹
    panel.canChooseDirectories = YES;
    //是否可以选择文件
    panel.canChooseFiles = YES;

    //是否可以多选
    [panel setAllowsMultipleSelection:NO];

    //显示
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {

         //是否点击open 按钮
        if (result == NSModalResponseOK) {
            //NSURL *pathUrl = [panel URL];
            NSString *pathString = [panel.URLs.firstObject path];
            _wks.originImagePath.stringValue = pathString;
            
            NSData * data = [NSData dataWithContentsOfFile:pathString];
            NSImage * image = [[NSImage alloc] initWithData:data];
            if (image == nil) {
                NSAlert *anAlert = [[NSAlert alloc] init];
                anAlert.messageText = @"Error";
                anAlert.informativeText = @"Unrecognizable Image Or Image Path is Wrong!";
                [anAlert runModal];
            }else{
                _wks.imageView.image = image;
            }
        }
    }];
}

- (IBAction)chooseOutAction:(id)sender {
    NSLog(@"chooseOutAction");
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    __weak typeof(self) _wks = self;
    //是否可以创建文件夹
    panel.canCreateDirectories = YES;
    //是否可以选择文件夹
    panel.canChooseDirectories = YES;
    //是否可以选择文件
    panel.canChooseFiles = YES;

    //是否可以多选
    [panel setAllowsMultipleSelection:NO];

    //显示
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {

         //是否点击open 按钮
        if (result == NSModalResponseOK) {
            //NSURL *pathUrl = [panel URL];
            NSString *pathString = [panel.URLs.firstObject path];
            _wks.outImagePath.stringValue = pathString;
        }
    }];
}

- (IBAction)startExportAction:(id)sender {
    if (self.outImagePath.stringValue.length == 0) {
        NSAlert *anAlert = [[NSAlert alloc] init];
        anAlert.messageText = @"Error";
        anAlert.informativeText = @"OutImage Path is Null";
        [anAlert runModal];
        return;
    }
    [[PKImageManager shareImageManager] replaceAppiconWithImageUrl:self.originImagePath.stringValue andSaveGourpPath:self.outImagePath.stringValue];
}


- (void)controlTextDidChange:(NSNotification *)obj{
    NSLog(@"controlTextDidChange");
    NSTextField * TF = obj.object;
    NSData * data = [NSData dataWithContentsOfFile:TF.stringValue];
    NSImage * image = [[NSImage alloc] initWithData:data];
    if (image == nil) {
        self.imageView.image = self.placeHolderImage;
    }else{
        self.imageView.image = image;
    }
    
}

@end

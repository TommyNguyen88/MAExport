//
//  AppDelegate.h
//  MAExportFile
//
//  Created by Nguyen Minh on 5/18/15.
//  Copyright (c) 2015 Nguyen Minh. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CustomImageView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSOpenSavePanelDelegate>
{
    NSSavePanel *_savePanel;
    NSMutableArray *_arrayContainImage;
    float originX;
    float originY;
    BOOL isStop;
}

@property (weak) IBOutlet NSView *dialogFileType;
@property (weak) IBOutlet NSPopUpButton *popUpFileType;
@property (weak) IBOutlet NSView *viewToAddImage;

@end


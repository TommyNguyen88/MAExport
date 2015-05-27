//
//  AppDelegate.m
//  MAExportFile
//
//  Created by Nguyen Minh on 5/18/15.
//  Copyright (c) 2015 Nguyen Minh. All rights reserved.
//

#import "AppDelegate.h"

#define imgHeight  160
#define imgWidth   115

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    _arrayContainImage = [[NSMutableArray alloc] init];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - public methods

- (IBAction)actionImportImage:(id)sender {
    if (isStop) {
        return;
    }
    else {
        NSOpenPanel *openPanel = [[NSOpenPanel alloc]init];
        NSArray *imageType = [NSImage imageTypes];
        
        openPanel.title = @"Choose a images file";
        openPanel.showsResizeIndicator = YES;
        openPanel.showsHiddenFiles = NO;
        openPanel.canChooseDirectories = NO;
        openPanel.canCreateDirectories = YES;
        openPanel.allowsMultipleSelection = YES;
        openPanel.allowedFileTypes = imageType;
        
        if ([openPanel runModal] == NSFileHandlingPanelOKButton) {
            NSArray *arraySel = openPanel.URLs;
            
            float i = 0;
            float j = 0;
            
            for (NSURL *selection in arraySel) {
                if (_arrayContainImage.count == 0) {
                    originX = 140.0;
                    originY = 395.0 + 395.0 * j;
                }
                else {
                    CustomImageView *lastObj = [_arrayContainImage firstObject];
                    i = _arrayContainImage.count;
                    originX = lastObj.frame.origin.x;
                    originY = lastObj.frame.origin.y;
                    if (i > 4) {
                        i = 0;
                    }
                    else {
                        j = _arrayContainImage.count / 4;
                        NSLog(@"j -- %f -- %f", j, i);
                    }
                    
                    if (i == 4) {
                        [_arrayContainImage removeAllObjects];
                        i = 0;
                    }
                }
                
                
                NSString *pathImage = [selection.path stringByResolvingSymlinksInPath];
                NSImage *img = [[NSImage alloc]initWithContentsOfFile:pathImage];
                
                //            NSImageRep *rep = [[img representations]objectAtIndex:0];
                //            NSSize imgSize = NSMakeSize(rep.pixelsWide, rep.pixelsHigh);
                
                originX = originX + (imgWidth + 10.0) * i;
                originY = originY - (imgHeight + 10.0) * j;
                
                i += 1;
                
                if (j == 3 && i == 4) {
                    [_arrayContainImage removeAllObjects];
                    isStop = YES;
                }
                
                if (i == 4) {
                    i = 0;
                    j += 1;
                }
                
                CustomImageView *customImageView = [[CustomImageView alloc] initWithFrame:NSMakeRect(originX, originY, imgWidth, imgHeight)];
                customImageView.imageView.image = img;
                
                [self.viewToAddImage addSubview:customImageView];
                [_arrayContainImage addObject:customImageView];
            }
        }
    }
}

- (IBAction)actionExportImage:(id)sender {
    _savePanel = [NSSavePanel savePanel];
    _savePanel.delegate = self;
    
    [_savePanel setAccessoryView:self.dialogFileType];
    [_savePanel setNameFieldLabel:@"FILE NAME:"];
    [_savePanel setAllowedFileTypes:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@", self.popUpFileType.selectedItem.title], nil]];
    
    [_savePanel beginSheetModalForWindow:self.window completionHandler: ^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {

            NSString *fileSaveType;
            if ([self.popUpFileType.selectedItem.title isEqualToString:@"pdf"]) {
                fileSaveType = @"pdf";
            }
            else {
                fileSaveType = @"png";
            }
            
            NSString *path = [[_savePanel URL]path];
            
            NSRect rectSubView;
            rectSubView.origin.x = 0;
            rectSubView.origin.y = 0;
            rectSubView.size.height = self.viewToAddImage.frame.size.height;
            rectSubView.size.width = self.viewToAddImage.frame.size.width;
            
            NSImage *subImage = [self bitmapImageInRect:rectSubView inView:self.viewToAddImage];
            [self captureImage:subImage andFileType:fileSaveType andPathSaveFile:path];
        }
    }];
}

- (void)captureImage:(NSImage *)image andFileType:(NSString *)type andPathSaveFile:(NSString *)path {
    NSData *data;
    
    if ([type isEqualToString:@"png"]) {
        NSData *imageData = [image TIFFRepresentation];
        NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
        NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
        imageData = [imageRep representationUsingType:NSPNGFileType properties:imageProps];
        
        [imageData writeToFile:path atomically:NO];
    }
    else {
        NSImageView *imgView = [[NSImageView alloc]initWithFrame:NSMakeRect(0, 0, 115, 160)];
        imgView.image = image;
        data = [imgView dataWithPDFInsideRect:NSMakeRect(0, 0, 115, 160)];
        [data writeToFile:path atomically:YES];
    }
    [[NSWorkspace sharedWorkspace] selectFile:path inFileViewerRootedAtPath:nil];
}

- (NSImage *)bitmapImageInRect:(NSRect)rect inView:(NSView *)inView {
    NSBitmapImageRep *imageRep = [inView bitmapImageRepForCachingDisplayInRect:rect];
    
    [inView cacheDisplayInRect:rect toBitmapImageRep:imageRep];
    
    NSImage *bitmapImage = [[NSImage alloc] initWithSize:rect.size];
    
    [bitmapImage addRepresentation:imageRep];
    
    return bitmapImage;
}

#pragma mark - select file type which have exported
- (IBAction)changeFileType:(id)sender {
    NSPopUpButton *btn = (NSPopUpButton *)sender;
    [_savePanel setAllowedFileTypes:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@", btn.title], nil]];
}

@end

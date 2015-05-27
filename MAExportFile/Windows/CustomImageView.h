//
//  CustomImageView.h
//  MAExportFile
//
//  Created by Nguyen Minh on 5/19/15.
//  Copyright (c) 2015 Nguyen Minh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CustomImageView : NSView

@property (nonatomic, strong) NSImageView *imageView;
@property (nonatomic, assign) BOOL isSelected;

@end

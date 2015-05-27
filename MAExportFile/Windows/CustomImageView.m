//
//  CustomImageView.m
//  MAExportFile
//
//  Created by Nguyen Minh on 5/19/15.
//  Copyright (c) 2015 Nguyen Minh. All rights reserved.
//

#import "CustomImageView.h"

@implementation CustomImageView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        self.imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, frameRect.size.width, frameRect.size.height)];
        self.imageView.imageScaling = NSImageScaleAxesIndependently;
        [self.imageView setImageFrameStyle: NSImageFramePhoto];

        [self addSubview:self.imageView];
    }

    return self;
}

- (BOOL)isFlipped {
    return YES;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    self.isSelected = isSelected;
}

- (void)mouseDown:(NSEvent *)theEvent{
    //
}

@end

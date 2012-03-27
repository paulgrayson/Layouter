//
//  Layouter.m
//  Analytical
//
//  Created by Paul Grayson on 10/02/2012.
//  Copyright (c) 2012 Grayson Technology Ltd. All rights reserved.
//

#import "Layouter.h"

@interface AddCommand : NSObject
@property (nonatomic, strong) UIView *view;
@property (nonatomic, assign) BOOL horz;
@end

@implementation AddCommand
@synthesize view = __view;
@synthesize horz = __horz;
-(id)initWithView:(UIView *)view horz:(BOOL)horz
{
    self = [super init];
    if( self ) {
        self.view = view;
        self.horz = horz;
    }
    return self;
}
@end

@interface Layouter ()
@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, assign) CGSize padding;
@property (nonatomic, assign) CGSize separation;
@property (nonatomic, assign) BOOL horz;
@end

@implementation Layouter

@synthesize views = __views;
@synthesize padding = __padding;
@synthesize separation = __separation;
@synthesize horz = __horz;

- (id) initWithPadding:(CGSize)padding horz:(BOOL)horz
{
    self = [self initWithPadding:padding separation:padding horz:horz];
    return self;
}

- (id) initWithPadding:(CGSize)padding separation:(CGSize)separation horz:(BOOL)horz
{
    self = [super init];
    if( self ) {
        self.horz = horz;
        self.padding = padding;
        self.separation = separation;
        self.views = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (void) addView:(UIView *)view horz:(BOOL)horz
{
    AddCommand *lastCmd = [self.views lastObject];
    UIView *lastView = lastCmd.view;
    CGFloat max;
    CGFloat sep;
    if( lastView ) {
        max = horz ? CGRectGetMaxX( lastView.frame ) : CGRectGetMaxY( lastView.frame );
        sep = horz ? self.separation.width : self.separation.height;
    }
    else {
        max = 0.0;
        sep = horz ? self.padding.width : self.padding.height;
    }
    if( horz ) {
        view.frame = CGRectMake( max + sep, self.padding.height, view.frame.size.width, view.frame.size.height );
    }
    else {
        view.frame = CGRectMake( self.padding.width, max + sep, view.frame.size.width, view.frame.size.height );
    }
    [self.views addObject:[[AddCommand alloc] initWithView:view horz:horz]];
}

- (void) addView:(UIView *)view
{
    [self addView:view horz:self.horz];
}

- (CGRect) frame
{
    CGRect rect = CGRectMake(0.0, 0.0, self.padding.width, self.padding.height);
    for( AddCommand *cmd in self.views ) rect = CGRectUnion(rect, cmd.view.frame);
    rect = CGRectMake(0.0, 0.0, rect.size.width + self.padding.width, rect.size.height + self.padding.height);
    return rect;
}

- (UIView *) createView
{
    UIView *view = [[UIView alloc] initWithFrame:[self frame]];
    for( AddCommand *cmd in self.views ) [view addSubview:cmd.view];
    return view;
}

- (void) populateView:(UIView *)view
{
    view.frame = [self frame];
    for( AddCommand *cmd in self.views ) [view addSubview:cmd.view];
}

// call this after you change the size of one or more managed views
- (void) relayout
{
    NSArray *views = [self.views copy];
    [self.views removeAllObjects];
    for( AddCommand *cmd in views ) {
        [self addView:cmd.view horz:cmd.horz];
    }
}

@end


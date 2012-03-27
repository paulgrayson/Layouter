//
//  Layouter.h
//  Analytical
//
//  Created by Paul Grayson on 10/02/2012.
//  Copyright (c) 2012 Grayson Technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Layouter : NSObject

- (id) initWithPadding:(CGSize)padding horz:(BOOL)horz;
- (id) initWithPadding:(CGSize)padding separation:(CGSize)separation horz:(BOOL)horz;
- (void) addView:(UIView *)view;
- (void) addView:(UIView *)view horz:(BOOL)horz;
- (CGRect) frame;
- (UIView *) createView;
- (void) populateView:(UIView *)view;

// call this after you change the size of one or more managed views
- (void) relayout;

@end

#import "Kiwi.h"
#import "Layouter.h"

SPEC_BEGIN(LayouterSpec)

describe(@"empty", ^{
    __block CGSize padding = CGSizeMake(5.0, 6.0);
    __block Layouter *layouter = [[Layouter alloc] initWithPadding:padding horz:NO];
    
    it(@"should have position 0 0", ^{
        CGRect frame = [layouter frame];
        [[theValue(frame.origin.x) should] equal:theValue(0.0)];
        [[theValue(frame.origin.y) should] equal:theValue(0.0)];        
    });
    
    it(@"should have padding", ^{
        CGRect frame = [layouter frame];
        [[theValue(frame.size.width) should] equal:theValue(padding.width *2)];
        [[theValue(frame.size.height) should] equal:theValue(padding.height *2)];
    });
});

describe(@"single view", ^{
    __block CGSize padding = CGSizeMake(5.0, 6.0);
    __block Layouter *layouter = [[Layouter alloc] initWithPadding:padding horz:NO];
    __block UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 200.0)];
    
    beforeAll(^{
        [layouter addView:view];
    });
    
    it(@"should have position 0 0", ^{
        CGRect frame = [layouter frame];
        [[theValue(frame.origin.x) should] equal:theValue(0.0)];
        [[theValue(frame.origin.y) should] equal:theValue(0.0)];
    });
    
    it(@"should have padding", ^{
        CGRect frame = [layouter frame];
        [[theValue(frame.size.width) should] equal:theValue(view.frame.size.width + padding.width *2)];
        [[theValue(frame.size.height) should] equal:theValue(view.frame.size.height + padding.height *2)];
    });
    
    it(@"should position view inside padding", ^{
        [[theValue(view.frame.origin.x) should] equal:theValue(padding.width)];
        [[theValue(view.frame.origin.y) should] equal:theValue(padding.height)];        
    });
    
    describe(@"resize", ^{
        beforeAll(^{
            view.frame = CGRectMake( 0.0, 0.0, 50.0, 250.0 );
            [layouter relayout];
        });
        
        it(@"should contain just the same view", ^{
            UIView *view = [layouter createView];
            [[theValue([view.subviews count]) should] equal:theValue(1)];
        });
        
        it(@"should keep same origin for view", ^{
            CGRect frame = view.frame;
            [[theValue(frame.origin.x) should] equal:theValue(padding.width)];
            [[theValue(frame.origin.y) should] equal:theValue(padding.height)];
        });
        
        it(@"should have the new view size plus padding", ^{
            CGRect frame = [layouter frame];
            [[theValue(frame.size.width) should] equal:theValue(view.frame.size.width + padding.width *2)];
            [[theValue(frame.size.height) should] equal:theValue(view.frame.size.height + padding.height *2)];
        });
    });
    
});

describe(@"2 views", ^{    
    describe(@"vertical", ^{
        __block CGSize padding = CGSizeMake(5.0, 6.0);
        __block Layouter *layouter = [[Layouter alloc] initWithPadding:padding horz:NO];
        __block UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 200.0)];
        __block UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 100.0)];

        beforeAll(^{
            [layouter addView:view1 horz:NO];
            [layouter addView:view2 horz:NO];
        });
        
        it(@"should have position 0 0", ^{
            CGRect frame = [layouter frame];
            [[theValue(frame.origin.x) should] equal:theValue(0.0)];
            [[theValue(frame.origin.y) should] equal:theValue(0.0)];
        });
        
        it(@"should have padding", ^{
            CGRect frame = [layouter frame];
            [[theValue(frame.size.width) should] equal:theValue(view1.frame.size.width + padding.width *2)];
            [[theValue(frame.size.height) should] equal:theValue(view1.frame.size.height + view2.frame.size.height + padding.height *3)];
        });
        
        it(@"should place view1 at the top with padding", ^{
            [[theValue(view1.frame.origin.x) should] equal:theValue(padding.width)];
            [[theValue(view1.frame.origin.y) should] equal:theValue(padding.height)];
        });
        
        it(@"should place view2 below view1 with padding separation", ^{
            [[theValue(view2.frame.origin.x) should] equal:theValue(padding.width)];
            [[theValue(view2.frame.origin.y) should] equal:theValue(2* padding.height + view1.frame.size.height)];
        });

        describe(@"resize view 1", ^{
            beforeAll(^{
                view1.frame = CGRectMake( 0.0, 0.0, 50.0, 250.0 );
                [layouter relayout];
            });
            
            it(@"should contain the same 2 views", ^{
                UIView *view = [layouter createView];
                [[theValue([view.subviews count]) should] equal:theValue(2)];
            });
            
            it(@"should keep same origin for view 1", ^{
                CGRect frame = view1.frame;
                [[theValue(frame.origin.x) should] equal:theValue(padding.width)];
                [[theValue(frame.origin.y) should] equal:theValue(padding.height)];
            });
            
            it(@"should move view 2 down to accomodate view 1 new size", ^{
                CGRect frame = view2.frame;
                [[theValue(frame.origin.x) should] equal:theValue(padding.width)];
                [[theValue(frame.origin.y) should] equal:theValue(view1.frame.size.height + padding.height *2)];
            });
            
            it(@"should have the new combined view size plus padding", ^{
                CGRect frame = [layouter frame];
                [[theValue(frame.size.width) should] equal:theValue(view1.frame.size.width + padding.width *2)];
                [[theValue(frame.size.height) should] equal:theValue(view1.frame.size.height + view2.frame.size.height + padding.height *3)];
            });
        });
        
        describe(@"padding and separation differ", ^{
            __block CGSize separation = CGSizeMake(15.0, 16.0);
            __block Layouter *layouterSep = [[Layouter alloc] initWithPadding:padding separation:separation horz:NO];
            
            beforeAll(^{
                [layouterSep addView:view1 horz:NO];
                [layouterSep addView:view2 horz:NO];
            });
            
            it(@"should position view1 at padding", ^{
                CGRect frame = view1.frame;
                [[theValue(frame.origin.x) should] equal:theValue(padding.width)];
                [[theValue(frame.origin.y) should] equal:theValue(padding.height)];
            });
            
            it(@"should position view2 below view1 separated by separation", ^{
                [[theValue(view2.frame.origin.x) should] equal:theValue(padding.width)];
                [[theValue(view2.frame.origin.y - view1.frame.origin.y - view1.frame.size.height) should] equal:theValue(separation.height)];
            });
        });
        
    });

    describe(@"horizontal", ^{
        __block CGSize padding = CGSizeMake(5.0, 6.0);
        __block Layouter *layouter = [[Layouter alloc] initWithPadding:padding horz:NO];
        __block UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 200.0)];
        __block UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 100.0)];

        beforeAll(^{
            [layouter addView:view1 horz:YES];
            [layouter addView:view2 horz:YES];
        });
        
        it(@"should have position 0 0", ^{
            CGRect frame = [layouter frame];
            [[theValue(frame.origin.x) should] equal:theValue(0.0)];
            [[theValue(frame.origin.y) should] equal:theValue(0.0)];
        });
        
        it(@"should have padding", ^{
            CGRect frame = [layouter frame];
            [[theValue(frame.size.width) should] equal:theValue(view1.frame.size.width + view2.frame.size.width + padding.width *3)];
            [[theValue(frame.size.height) should] equal:theValue(view1.frame.size.height + padding.height *2)];
        });
        
        it(@"should place view1 at the top with padding", ^{
            [[theValue(view1.frame.origin.x) should] equal:theValue(padding.width)];
            [[theValue(view1.frame.origin.y) should] equal:theValue(padding.height)];
        });
        
        it(@"should place view2 to the right of view1 with padding separation", ^{
            [[theValue(view2.frame.origin.x) should] equal:theValue(2*padding.width + view1.frame.size.width)];
            [[theValue(view2.frame.origin.y) should] equal:theValue(padding.height)];
        });
        
        describe(@"resize view 1", ^{
            beforeAll(^{
                view1.frame = CGRectMake( 0.0, 0.0, 50.0, 250.0 );
                [layouter relayout];
            });
            
            it(@"should contain the same 2 views", ^{
                UIView *view = [layouter createView];
                [[theValue([view.subviews count]) should] equal:theValue(2)];
            });
            
            it(@"should keep same origin for view 1", ^{
                CGRect frame = view1.frame;
                [[theValue(frame.origin.x) should] equal:theValue(padding.width)];
                [[theValue(frame.origin.y) should] equal:theValue(padding.height)];
            });
            
            it(@"should move view 2 across to accomodate view 1 new size", ^{
                CGRect frame = view2.frame;
                [[theValue(frame.origin.x) should] equal:theValue(padding.width*2 + view1.frame.size.width)];
                [[theValue(frame.origin.y) should] equal:theValue(padding.height)];
            });
            
            it(@"should have the new combined view size plus padding", ^{
                CGRect frame = [layouter frame];
                [[theValue(frame.size.width) should] equal:theValue(view1.frame.size.width + view2.frame.size.width + padding.width *3)];
                [[theValue(frame.size.height) should] equal:theValue(view1.frame.size.height + padding.height *2)];
            });
        });
        
        describe(@"padding and separation differ", ^{
            __block CGSize separation = CGSizeMake(15.0, 16.0);
            __block Layouter *layouterSep = [[Layouter alloc] initWithPadding:padding separation:separation horz:YES];
            
            beforeAll(^{
                [layouterSep addView:view1 horz:YES];
                [layouterSep addView:view2 horz:YES];
            });
            
            it(@"should position view1 at padding", ^{
                CGRect frame = view1.frame;
                [[theValue(frame.origin.x) should] equal:theValue(padding.width)];
                [[theValue(frame.origin.y) should] equal:theValue(padding.height)];
            });
            
            it(@"should position view2 below view1 separated by separation", ^{
                [[theValue(view2.frame.origin.x - view1.frame.origin.x - view1.frame.size.width) should] equal:theValue(separation.width)];
                [[theValue(view2.frame.origin.y) should] equal:theValue(padding.height)];
            });
        });
    });    
});


SPEC_END

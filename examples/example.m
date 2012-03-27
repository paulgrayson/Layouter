#import "lib/Layouter.h"

// create some labels: labelA with size (100, 20) and labelB with size (60, 25)

// create a layouter with outside padding of 5 either side and 10 above and below, component views are vertically separated by 2.0
Layouter *layouter = [[Layouter alloc] initWithPadding:CGSizeMake( 5.0, 10.0 )
                                            separation:CGSizeMake( 0.0, 2.0 )
                                                  horz:NO];
[layouter addView:labelA];
[layouter addView:labelB];

UIView *view = [layouter createView];
// view's width = 5.0 + labelA.width + 5.0
// view's height = 10.0 + labelA.height + 2.0 + labelB.height + 10.0

// alternatively, use the layouter to add the views to another view
[layouter populateView:anotherView];

// got a table cell who's contentView you need to size and then populate...
UITableViewCell *cell = ...
[cell.contentView setFrame:[layouter frame]];
[layouter populateView:cell.contentView];


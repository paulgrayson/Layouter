# Layouter - a simple view layout helper for iOS

Layouter provides a simple means to layout views in iOS.

Say you have three views you want to appear one after the other in a vertical column (a common task in iOS apps). Layouter makes this really easy, for example:

<pre>
<code>
  Layouter *l = [[Layouter alloc] initWithPadding:CGSizeMake(0,0) separation:CGSizeMake(0,0) horz:NO];
  [l addView:topView];
  [l addView:middleView];
  [l addView:bottomView];
  UIView *v = [l createView];
</code>
</pre>

## Separation

Want the components vertically separated by 5 pixels?

<pre>
<code>
  // separate component views by 5 pixels by setting height of separation parameter to 5.0
  Layouter *l = [[Layouter alloc] initWithPadding:CGSizeMake(0,0) separation:CGSizeMake(0, 5.0) horz:NO];
  [l addView:topView];
  [l addView:middleView];
  [l addView:bottomView];

  UIView *v = [l createView];

// OR:

  [l populateView:anotherView];
</code>
</pre>

## Padding

Padding works like CSS padding

<pre>
<code>
  // separate component views by 5 pixels by setting height of separation parameter to 5.0
  // AND pad the component views from the edge of the containing view by 6 pixels at top and bottom and 2 pixels either side
  Layouter *l = [[Layouter alloc] initWithPadding:CGSizeMake(2.0, 6.0) separation:CGSizeMake(0, 5.0) horz:NO];
  [l addView:topView];
  [l addView:middleView];
  [l addView:bottomView];

  UIView *v = [l createView];

// OR:

  [l populateView:anotherView];
</code>
</pre>

## Examples and tests

See examples/example.m for more examples..

Alternatively, take a look at the unit tests (written using the excellent Kiwi test framework).


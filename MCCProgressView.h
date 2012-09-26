//
//  MCCProgressView.h
//
//  Created by Thierry Passeron on 12/09/12.
//  Copyright (c) 2012 Monte-Carlo Computing. All rights reserved.
//

/* Usage:

** Simple

  MCCProgressView *pv = [[[MCCProgressView alloc]initWithStrokeWidth:2.0 frame:CGRectMake(0, 0, self.view.bounds.size.width, 22)]autorelease];
  pv.progress = 0.1;
  
  [self.view addSubview:pv];
  
** With Stroke shadow

  MCCProgressView *pv = [[[MCCProgressView alloc]initWithStrokeWidth:2.0 frame:CGRectMake(0, 0, self.view.bounds.size.width, 22)]autorelease];
  [pv setStrokeShadow:CGSizeMake(0, 1) withColor:[UIColor blackColor] blur:0.8];

  [self.view addSubview:pv];

** Changing the colors
  
  MCCProgressView *pv = [[[MCCProgressView alloc]initWithStrokeWidth:2.0 frame:CGRectMake(0, 0, self.view.bounds.size.width, 22)]autorelease];
  pv.strokeColor = [UIColor redColor];
  pv.progressColor = [UIColor greenColor];
  pv.trackColor = [UIColor blackColor];
  
  [self.view addSubview:pv];
  
** Animating progress changes

  pv.progress = 0.0; // Not animated
  [pv setProgress:0.2 animated:YES];
  
*/

#import <UIKit/UIKit.h>

@interface MCCProgressView : UIView

- (id)initWithStrokeWidth:(CGFloat)width frame:(CGRect)frame;

/* Configure the look */

- (void)setTrackWidth:(CGFloat)value;
- (void)setTrackColor:(UIColor *)color;

- (void)setStrokeWidth:(CGFloat)value;
- (void)setStrokeShadow:(CGSize)value withColor:(UIColor*)color blur:(CGFloat)blur;
- (void)setStrokeColor:(UIColor *)color;

- (void)setProgressColor:(UIColor *)color;


/* The progress value must be between 0.0 and 1.0 */

- (CGFloat)progress;
- (void)setProgress:(CGFloat)value;
- (void)setProgress:(CGFloat)value animated:(BOOL)animated;

@end

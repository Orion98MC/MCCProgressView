//
//  MCCProgressView.m
//
//  Created by Thierry Passeron on 12/09/12.
//  Copyright (c) 2012 Monte-Carlo Computing. All rights reserved.
//

#import "MCCProgressView.h"
#import <QuartzCore/QuartzCore.h>

@interface MCCProgressViewLayer : CALayer
@property (assign, nonatomic) CGMutablePathRef path;

@property (assign, nonatomic) CGFloat trackWidth;
@property (assign, nonatomic) CGFloat strokeWidth;

@property (retain, nonatomic) UIColor *trackColor;
@property (retain, nonatomic) UIColor *progressColor;
@property (retain, nonatomic) UIColor *strokeColor;
@property (assign, nonatomic) CGSize strokeShadow;
@property (retain, nonatomic) UIColor *strokeShadowColor;
@property (assign, nonatomic) CGFloat strokeShadowBlur;

@property (assign, nonatomic) CGFloat progress;
@end

@implementation MCCProgressViewLayer
@synthesize progress, trackWidth, strokeColor, strokeWidth, progressColor, path, strokeShadow, strokeShadowColor, strokeShadowBlur;

- (id)initWithLayer:(id)layer {
  self = [super initWithLayer:layer];
  if (!self) return nil;

  if([layer isKindOfClass:[MCCProgressViewLayer class]]) {
    MCCProgressViewLayer *source = (MCCProgressViewLayer*)layer;
    
    self.progress = source.progress;
    self.path = source.path; CGPathRetain(path);
    self.trackWidth = source.trackWidth;
    self.strokeWidth = source.strokeWidth;
    self.strokeColor = source.strokeColor;
    self.progressColor = source.progressColor;
    self.trackColor = source.trackColor;
    self.strokeShadow = source.strokeShadow;
    self.strokeShadowColor = source.strokeShadowColor;
    self.strokeShadowBlur = source.strokeShadowBlur;
  }

  return self;
}

- (void)dealloc {
  if (path) CGPathRelease(path);
  self.strokeColor = nil;
  self.strokeShadowColor = nil;
  self.trackColor = nil;
  self.progressColor = nil;

  [super dealloc];
}

- (void)setupPath {
  if (path) CGPathRelease(path);
  
/*
 
      p0           p1
     (pb)         (pa)
      p3           p2
 
 */
  
  CGFloat shift = strokeWidth / 2.0;
  CGFloat x03 = (trackWidth / 2.0) + shift;
  CGFloat x12 = self.bounds.size.width - x03;
  CGFloat y01 = shift;
  CGFloat y32 = y01 + trackWidth;
  
  path = CGPathCreateMutable();
  CGPathMoveToPoint(path, &CGAffineTransformIdentity, x03, y01); // p0
  CGPathAddLineToPoint(path, &CGAffineTransformIdentity, x12, y01); // p1
  CGPathAddArc(path, &CGAffineTransformIdentity, x12, (y32 - y01) / 2.0 + shift, trackWidth / 2.0, -M_PI / 2.0, M_PI / 2.0, 0); // pa
  CGPathAddLineToPoint(path, &CGAffineTransformIdentity, x03, y32); // p3
  CGPathAddArc(path, &CGAffineTransformIdentity, x03, (y32 - y01) / 2.0 + shift, trackWidth / 2.0, M_PI / 2.0, 3.0/2.0 * M_PI, 0); // pb
  CGPathCloseSubpath(path);
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
  if ([key isEqualToString:@"progress"]) {
    return YES;
  }
  return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)context {
  if (!path) [self setupPath];

  // Clip path
  CGContextSaveGState(context);
  CGContextAddPath(context, path);
  CGContextClip(context);
  
  // draw Progress
  CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
  CGContextFillRect(context, CGRectMake(strokeWidth, strokeWidth, self.bounds.size.width * progress - strokeWidth, trackWidth));
  // draw Track
  CGContextSetFillColorWithColor(context, self.trackColor.CGColor);
  CGContextFillRect(context, CGRectMake(self.bounds.size.width * progress, strokeWidth, self.bounds.size.width - strokeWidth - self.bounds.size.width * progress, trackWidth));
  
  CGContextRestoreGState(context);

  // Stroke path
  CGContextAddPath(context, path);
  CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
  if (strokeShadow.width || strokeShadow.height) {
    CGContextSetShadowWithColor(context, strokeShadow, strokeShadowBlur, strokeShadowColor.CGColor);
  }
  CGContextSetLineWidth(context, strokeWidth);
  CGContextStrokePath(context);
}

@end

@interface MCCProgressView ()
@property (assign, nonatomic) MCCProgressViewLayer *drawingLayer;
@end

@implementation MCCProgressView
@synthesize drawingLayer;

static float animationDuration = 0.3;
+ (float)animationDuration { return animationDuration; }

- (id)initWithStrokeWidth:(CGFloat)width frame:(CGRect)frame {
  self = [self initWithFrame:frame];
  if (!self) return nil;
  
  self.strokeWidth = width;
  
  CGFloat _trackWidth = frame.size.height - 2.0 * width;
  NSAssert(_trackWidth > 0.0, @"Invalid track width");
  self.trackWidth = _trackWidth;
  
  // NSLog(@"Progress: %@ (%f; %f)", NSStringFromCGRect(frame), width, frame.size.height - 2.0 * width);
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (!self) return nil;
  
  self.opaque = NO;
  self.backgroundColor = nil;
  
  self.drawingLayer = [MCCProgressViewLayer layer];
  drawingLayer.frame = self.bounds;
  
  drawingLayer.progress = 0.5;
  drawingLayer.trackWidth = 4.0;
  drawingLayer.strokeWidth = 1.0;
  drawingLayer.strokeColor = [UIColor lightGrayColor];
  drawingLayer.trackColor = [UIColor darkGrayColor];
  drawingLayer.progressColor = [UIColor whiteColor];
  drawingLayer.strokeShadow = CGSizeZero;
  drawingLayer.strokeShadowColor = [UIColor blackColor];
  drawingLayer.strokeShadowBlur = 0.8;
  
  [self.layer addSublayer:drawingLayer];
  [drawingLayer setNeedsDisplay];
  
  return self;
}


- (void)setTrackWidth:(CGFloat)value      { drawingLayer.trackWidth = value; }
- (void)setStrokeWidth:(CGFloat)value     { drawingLayer.strokeWidth = value; }

- (void)setStrokeShadow:(CGSize)value withColor:(UIColor*)color blur:(CGFloat)blur {
  drawingLayer.strokeShadow = value;
  drawingLayer.strokeShadowColor = color;
  drawingLayer.strokeShadowBlur = blur;
}

- (void)setTrackColor:(UIColor *)color    { drawingLayer.trackColor = color; }
- (void)setStrokeColor:(UIColor *)color   { drawingLayer.strokeColor = color; }
- (void)setProgressColor:(UIColor *)color { drawingLayer.progressColor = color; }

- (CGFloat)progress { return drawingLayer.progress; }

- (void)setProgress:(CGFloat)value {
  [self setProgress:value animated:NO];
}

- (void)setProgress:(CGFloat)value animated:(BOOL)animated {
  if (value < 0) value = 0.0;
  if (value > 1.0) value = 1.0;
  if (value == drawingLayer.progress) return;

  if (!animated) {
    drawingLayer.progress = value;
    [drawingLayer setNeedsDisplay];
    return;
  }
  
  if (self.hidden) {
    drawingLayer.progress = value;
    return;
  }
  
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
  animation.duration = animationDuration;
  animation.fromValue = [NSNumber numberWithFloat:drawingLayer.progress];
  animation.toValue = [NSNumber numberWithFloat:value];
  [drawingLayer addAnimation:animation forKey:@"progressAnimation"];
  drawingLayer.progress = value;
}

@end

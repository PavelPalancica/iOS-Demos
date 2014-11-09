//
//  PPAnalogClockView.m
//  iAnalogClock
//
//  Created by AppDevWizard on 6/23/13.
//  Copyright (c) 2013 AppDevWizard. All rights reserved.
//

#import "ADWAnalogClockView.h"


@interface ADWAnalogClockView ()

@property (strong, nonatomic) NSCalendar    *calendar;
@property (strong, nonatomic) NSDate        *time;
@property (strong, nonatomic) NSTimer       *timer;

@property (assign, nonatomic) CGPoint centerPoint;

- (void)updateTime;

- (CGPoint)pointWithRadius:(CGFloat)aRadius
                     angle:(CGFloat)anAngle;

- (void)drawAnalogClockHands;

@end


@implementation ADWAnalogClockView

- (NSCalendar *)calendar
{
    if (!_calendar)
    {
        _calendar = [NSCalendar currentCalendar];
    }
    
    return _calendar;
}

- (NSDate *)time
{
    if (!_time)
    {
        _time = [NSDate date];
    }
    
    return _time;
}


- (CGPoint)centerPoint
{
    return CGPointMake(CGRectGetMidX(self.bounds),
                       CGRectGetMidY(self.bounds));
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code
        
        self.calendar = [NSCalendar currentCalendar];
        self.time = [NSDate date];
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(theContext);
    
    NSInteger theRadius = CGRectGetWidth(self.bounds) / 2.0;

    [[UIColor orangeColor] setFill];
    
    CGContextAddEllipseInRect(theContext, self.bounds);
    CGContextFillPath(theContext);
    
    [[UIColor whiteColor] setStroke];
    [[UIColor darkGrayColor] setFill];
    
    CGContextSetLineWidth(theContext, IS_IPAD ? 14.0f : 7.0f);
    CGContextSetLineCap(theContext, kCGLineCapRound);
    CGContextAddEllipseInRect(theContext, self.bounds);
    CGContextClip(theContext);
    
    for (NSInteger i = 0; i < 60; i++)
    {
        CGFloat theAngle = i * M_PI / 30.0;
        
        if (i % 5 == 0)
        {
            CGFloat theInnerRadius = theRadius * ( i % 15 == 0 ? 0.7 : 0.8);
            
            CGPoint theInnerPoint = [self pointWithRadius:theInnerRadius
                                                    angle:theAngle];
            CGPoint theOuterPoint = [self pointWithRadius:theRadius
                                                    angle:theAngle];
            
            CGContextMoveToPoint(theContext, theInnerPoint.x, theInnerPoint.y);
            CGContextAddLineToPoint(theContext, theOuterPoint.x, theOuterPoint.y);
            CGContextStrokePath(theContext);
        }
        else
        {
            CGPoint thePoint = [self pointWithRadius:theRadius * 0.95
                                               angle:theAngle];
            
            CGContextAddArc(theContext, thePoint.x, thePoint.y, IS_IPAD ? 6.0f : 3.0f, 0.0, 2 * M_PI, YES);
            CGContextFillPath(theContext);
        }
    }
    
    [self drawAnalogClockHands];
    
    CGContextRestoreGState(theContext);
}

- (void)startAnimation
{
    if (self.timer == nil)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                      target:self
                                                    selector:@selector(updateTime)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)stopAnimation
{
    [self.timer invalidate];
    
    self.timer = nil;
}

- (void)updateTime
{
    self.time = [NSDate date];
    
    [self setNeedsDisplay];
}

- (CGPoint)pointWithRadius:(CGFloat)aRadius
                     angle:(CGFloat)anAngle
{
    return CGPointMake(self.centerPoint.x + aRadius * sin(anAngle),
                       self.centerPoint.y - aRadius * cos(anAngle));
}

- (void)drawAnalogClockHands
{    
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    
    CGPoint theCenter = self.centerPoint;
    CGFloat theRadius = CGRectGetWidth(self.bounds) / 2.0f;
    
    NSDateComponents *theComponents = [self.calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self.time];
    
    CGFloat theSecond = theComponents.second * M_PI / 30.0f;
    CGFloat theMinute = theComponents.minute * M_PI / 30.0f;
    CGFloat theHour = (theComponents.hour + theComponents.minute / 60.0f) * M_PI / 6.0f;
    
    CGPoint thePoint = [self pointWithRadius:theRadius * 0.5f
                                       angle:theHour];
    
    [[UIColor yellowColor] setFill];
    [[UIColor yellowColor] setStroke];
    
    CGContextSetLineWidth(theContext, IS_IPAD ? 14.0f : 7.0f);
    CGContextSetLineCap(theContext, kCGLineCapButt);
    CGContextMoveToPoint(theContext, theCenter.x, theCenter.y);
    CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y);
    CGContextStrokePath(theContext);
    
    thePoint = [self pointWithRadius:theRadius * 0.65f
                               angle:theMinute];
    
    CGContextSetLineWidth(theContext, IS_IPAD ? 10.0f : 5.0f);
    CGContextMoveToPoint(theContext, theCenter.x, theCenter.y);
    CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y);
    CGContextStrokePath(theContext);
    
    thePoint = [self pointWithRadius:theRadius * 0.95f
                               angle:theSecond];
    
    [[UIColor purpleColor] setStroke];
    
    CGContextSetLineWidth(theContext, IS_IPAD ? 6.0f : 3.0f);
    CGContextMoveToPoint(theContext, theCenter.x, theCenter.y);
    CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y);
    CGContextStrokePath(theContext);
}

@end

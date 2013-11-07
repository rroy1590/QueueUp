//
//  SCTSwipeView.m
//  SoundCloudTest
//
//  Created by Raunak Roy on 10/28/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//

#import "SCTSwipeView.h"
#import "SCTTrackCardView.h"
#import "SCTTrackDataObject.h"

#define START_X 40
#define START_Y 150
#define DEFAULT_LENGTH 240
#define DEFAULT_CENTER_X 160
#define DEFAULT_CENTER_Y 265
#define FINAL_X_YES 560
#define FINAL_X_NO -240

@interface SCTSwipeView()
@property (nonatomic, strong) NSDictionary* currentDataItem;
@property NSUInteger numOfTracks;
@property (nonatomic, strong) UIView* swipeTarget;
@property BOOL madeSelection;
@property double firstX;
@property double firstY;
@property double currentIndex;
@end

@implementation SCTSwipeView

- (id)initWithFrame:(CGRect)frame andDeleGate: (id<SCTSwipeViewDelegate>) delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentIndex = 0;
        self.delegate = delegate;
        
        [self spawnNew];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) swipeLeft
{
    self.madeSelection = YES;
    CGPoint finalPos = CGPointMake(FINAL_X_NO, DEFAULT_CENTER_Y);
    [self animateCardTo:finalPos];
}

-(void) swipeRight
{
    self.madeSelection = YES;
    CGPoint finalPos = CGPointMake(FINAL_X_YES, DEFAULT_CENTER_Y);
    [self animateCardTo:finalPos];
}

-(void) animateCardTo: (CGPoint) point
{
    CGFloat animationDuration = .23;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidFinish)];
    [self.swipeTarget setCenter:point];
    [UIView commitAnimations];
}

- (void) spawnNew
{
    self.currentDataItem = [self.delegate dataForViewAtIndex:self.currentIndex];
    
    if(!self.currentDataItem)
    {
        return;
    }
    
    SCTTrackDataObject* track = [[SCTTrackDataObject alloc] initWithData:self.currentDataItem];
    
    
    self.swipeTarget = [[SCTTrackCardView alloc] initWithFrame:CGRectMake(START_X,START_Y,DEFAULT_LENGTH,DEFAULT_LENGTH)
                                                     withTitle:[track getTitle]
                                                   andImageUrl:[track getArtworkUrl]];
    
    [self addSubview:self.swipeTarget];
    [self bringSubviewToFront:self.swipeTarget];
    [self addGesture];
    [self.delegate setCurrentTrack:self.currentDataItem];
    
}

-(void) addGesture {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self.swipeTarget addGestureRecognizer:panRecognizer];
}

-(void)move:(id)sender {
    [self bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [[sender view] center].x;
        _firstY = [[sender view] center].y;
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    
    [[sender view] setCenter:translatedPoint];
    
    
    //animate off screen if necessary and make selection
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        CGFloat velocityX = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self].x);
        
        CGFloat finalX = translatedPoint.x + velocityX;
        CGFloat finalY = _firstY;
        
        if ( (finalX) <30)
        {
            finalX = FINAL_X_NO;
            self.madeSelection = YES;
        }
        else if ((finalX) > 290)
        {
            finalX = FINAL_X_YES;
            self.madeSelection = YES;
        }else{
            finalX = DEFAULT_CENTER_X;
            finalY = DEFAULT_CENTER_Y;
            self.madeSelection = NO;
        }
        
        [self animateCardTo:CGPointMake(finalX, finalY)];
    }
}

- (void) animationDidFinish
{
    if(self.madeSelection)
    {
        NSString* swipe = @"";
        if(self.swipeTarget.center.x < 0)
        {
            NSLog(@"NO!");
            swipe = SWIPE_NO;
        } else if(self.swipeTarget.center.x > 320)
        {
            NSLog(@"YES!");
            swipe = SWIPE_YES;
        }
        [self.swipeTarget removeFromSuperview];
        self.swipeTarget = nil;
        
        NSDictionary* selectionData = @{@"choice":swipe,@"data":self.currentDataItem};
        [self.delegate didMakeSelectionWith:selectionData];
        
        self.currentIndex++;
        if(self.currentIndex < [self.delegate numberOfTracks])
        {
            [self spawnNew];
        }
        
        self.madeSelection = NO;
    }
}


@end

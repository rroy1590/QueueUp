//
//  SCTSwipeView.h
//  SoundCloudTest
//
//  Created by Raunak Roy on 10/28/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCTSwipeViewDelegate

-(NSUInteger)numberOfTracks;
-(NSDictionary*)dataForViewAtIndex:(NSUInteger)index;

-(void)didMakeSelectionWith:(NSDictionary*)selectionData;
-(void)setCurrentTrack:(NSDictionary*)trackData;

@end

@interface SCTSwipeView : UIView

@property (weak) id<SCTSwipeViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andDeleGate:(id<SCTSwipeViewDelegate>) delegate;

-(void) swipeRight;
-(void) swipeLeft;

@end

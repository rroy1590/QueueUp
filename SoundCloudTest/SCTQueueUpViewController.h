//
//  SCTQueueUpViewController.h
//  SoundCloudTest
//
//  Created by Raunak Roy on 10/28/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTSwipeView.h"

@interface SCTQueueUpViewController : UIViewController <SCTSwipeViewDelegate>
- (void) setTracks:(NSArray *)trackList;
- (IBAction) pressedYes:(id)sender;
- (IBAction) pressedNo:(id)sender;
@end

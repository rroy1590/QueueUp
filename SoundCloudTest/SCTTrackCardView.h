//
//  SCTTrackCardView.h
//  SoundCloudTest
//
//  Created by Raunak Roy on 10/30/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTTrackCardView : UIView
- (id)initWithFrame:(CGRect)frame withTitle: (NSString*) title andImageUrl: (NSString*) imgUrl andTrackInfo: (NSString*) trackData;
-(void) showFront;
-(void) showBack;
@end

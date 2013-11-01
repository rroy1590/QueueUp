//
//  SCTSoundCloudData.h
//  SoundCloudTest
//
//  Created by Raunak Roy on 10/28/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeamAVMusicPlayerProvider.h"
#import <AVFoundation/AVAudioPlayer.h>

@interface SCTTrackManager : BeamAVMusicPlayerProvider <AVAudioPlayerDelegate>

+ (SCTTrackManager*) sharedSingleton;
-(BOOL) isAvailable;
-(void) loadData;
-(NSArray*) getFavorites;
- (void) logout;
- (void) loginFrom: (UIViewController*) fromVC;
- (NSDictionary*) getUserData;
- ( void) playTrack:(NSDictionary*) trackData;
- ( void) playTrack:(NSDictionary*) trackData immediately:(BOOL)playImmediately;
- (void) showPlayerFromView: (UIViewController*) view;
- (BOOL) canPlayMusic;
@end

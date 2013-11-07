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
#import <SCUI.h>

@interface SCTTrackManager : BeamAVMusicPlayerProvider <AVAudioPlayerDelegate>

@property (nonatomic,strong) NSArray* favorites;
@property (nonatomic, strong) NSDictionary* userData;
@property (nonatomic, strong) NSMutableArray* playQueue;

+ (SCTTrackManager*) sharedSingleton;

- (BOOL) isAvailable;
- (BOOL) canPlayMusic;

- (void) logout;
- (void) loginFrom:(UIViewController*) fromVC;

-(NSArray*) getFavorites;
- (void) setFavorites:(NSArray *)favorites;

- (void) playTrack:(NSDictionary*) trackData;
- (void) playTrack:(NSDictionary*) trackData immediately:(BOOL)playImmediately;
- (void) showPlayerFromView:(UIViewController*) view;

- (void) loadData;
- (void) loadUserDataWithHandler:(SCRequestResponseHandler) aResponseHandler;
- (void) loadFavoritesWithHandler:(SCRequestResponseHandler) aResponseHandler;
- (void) loadFavoritesFrom:(NSString*)url withHandler:(SCRequestResponseHandler)aResponseHandler;

@end

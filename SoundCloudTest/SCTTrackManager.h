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

#define STREAM_URL @"https://api.soundcloud.com/me/activities/tracks/affiliated.json"
#define FAVORITES_URL @"https://api.soundcloud.com/me/favorites.json"
#define BACKUP_URL @"https://api.soundcloud.com/users/13932803/favorites.json"

@interface SCTTrackManager : BeamAVMusicPlayerProvider <AVAudioPlayerDelegate>

@property (nonatomic,strong) NSArray* favorites;
@property (nonatomic,strong) NSArray* streamableFavorites;
@property (nonatomic,strong) NSArray* fullTrackList;
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
- (void) loadDataFrom:(NSString*)url withHandler:(SCRequestResponseHandler)aResponseHandler;

@end

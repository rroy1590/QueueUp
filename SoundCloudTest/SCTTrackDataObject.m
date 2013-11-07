//
//  SCTTrackDataObject.m
//  SoundCloudTest
//
//  Created by Raunak Roy on 10/30/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//

#import "SCTTrackDataObject.h"

#define PRIV_URL_PATH @"https://api.soundcloud.com/tracks/%@/stream?client_id=%@"

@interface SCTTrackDataObject()
@property (nonatomic,strong) NSDictionary* trackData;
@end

@implementation SCTTrackDataObject

-(id) initWithData:(NSDictionary*) data
{
    if (self =[super init])
    {
        if([data objectForKey:@"origin"])
        {
            self.trackData = [data objectForKey:@"origin"];
        } else {
            self.trackData = data;
        }
    }
    return self;
}

-(NSString*) getInfoString
{
    CGFloat duration = [[self.trackData objectForKey:@"duration"] floatValue] / 1000.0f;
    
    NSString *durationString = duration != 0.0f ? [NSString stringWithFormat:@"%d:%02d", (int)duration / 60, (int)duration % 60] : nil;
    
    NSDictionary* user = [self.trackData objectForKey:@"user"];
    
    NSString* playCount = [NSString stringWithFormat:@"%@",[self.trackData objectForKey:@"playback_count"]];
    
    NSString* favCount = [NSString stringWithFormat:@"%@",[self.trackData objectForKey:@"favoritings_count"]];
    
    NSString* info = [NSString stringWithFormat:@"User: %@ \n\nLength: %@ \n\nPlay Count: %@ \n\nFavorites: %@",[user objectForKey:@"username"],durationString, playCount, favCount];
    
    return info;
}

-(NSString*) getStreamURL
{
    NSString* streamURL = [self.trackData objectForKey:@"stream_url"];
    
    return streamURL;
}

-(NSString*) getArtworkUrl
{
    NSString* imgUrl = [self.trackData objectForKey:@"artwork_url"];
    if( [imgUrl isKindOfClass:[NSNull class]] || [imgUrl length] <= 0 )
    {
        imgUrl = [[self.trackData objectForKey:@"user"] objectForKey:@"avatar_url"];
    }
    return imgUrl;
}

-(CGFloat) getDuration
{
    CGFloat duration = [[self.trackData objectForKey:@"duration"] floatValue] / 1000.0f;
    return duration;
}

-(NSString*) getArtist
{
    return [self.trackData objectForKey:@"artist"];
}

-(NSString*) getTitle
{
    return [self.trackData objectForKey:@"title"];
}

-(NSString*) getSCAppUrl
{
    NSString* fullURLStr = [NSString stringWithFormat:@"soundcloud:sounds:%@",[self.trackData objectForKey:@"id"]];
    return fullURLStr;
}

-(NSString*) getSCSiteUrl
{
    NSString* fullURLStr = [self.trackData objectForKey:@"permalink_url"];
    return fullURLStr;
}

@end

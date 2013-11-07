//
//  SCTTrackDataObject.m
//  SoundCloudTest
//
//  Created by Raunak Roy on 10/30/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//

#import "SCTTrackDataObject.h"

@interface SCTTrackDataObject()
@property (nonatomic,strong) NSDictionary* trackData;
@end

@implementation SCTTrackDataObject

-(id) initWithData:(NSDictionary*) data
{
    if (self =[super init])
    {
        self.trackData = data;
    }
    return self;
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

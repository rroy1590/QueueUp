//
//  SCTTrackDataObject.h
//  SoundCloudTest
//
//  Created by Raunak Roy on 10/30/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCTTrackDataObject : NSObject

-(id) initWithData:(NSDictionary*) data;

-(NSString*) getArtworkUrl;
-(NSString*) getTitle;

@end

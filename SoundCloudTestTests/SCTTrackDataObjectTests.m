//
//  SCTTrackDataObjectTests.m
//  SoundCloudTest
//
//  Created by Raunak Roy on 11/1/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//
#import <XCTest/XCTestCase.h>
#import "SCTTrackDataObject.h"

@interface SCTTrackDataObjectTests : XCTestCase
@property NSDictionary* testData;
@end


@implementation SCTTrackDataObjectTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.testData = @{
                       @"kind":@"track",
                       @"id": @50636638.0f,
                       @"created_at":@"2012/06/23 17:48:39 +0000",
                       @"user_id": @16094494.0f,
                       @"duration": @187578.0f,
                       @"commentable": @YES,
                       @"state":@"finished",
                       @"original_content_size": @2999307.0f,
                       @"sharing":@"public",
                       @"tag_list":@"",
                       @"permalink":@"sak-noel-loca-people",
                       @"streamable": @YES,
                       @"embeddable_by":@"all",
                       @"downloadable": @NO,
                       @"purchase_url": [NSNull null],
                       @"label_id": [NSNull null],
                       @"purchase_title": [NSNull null],
                       @"genre":@"House",
                       @"title":@"Sak Noel - Loca People",
                       @"description":@"yup..",
                       @"label_name":@"",
                       @"release":@"",
                       @"track_type": [NSNull null],
                       @"key_signature": [NSNull null],
                       @"isrc": [NSNull null],
                       @"video_url": [NSNull null],
                       @"bpm": [NSNull null],
                       @"release_year": [NSNull null],
                       @"release_month": [NSNull null],
                       @"release_day": [NSNull null],
                       @"original_format":@"mp3",
                       @"license":@"all-rights-reserved",
                       @"uri":@"https://api.soundcloud.com/tracks/50636638",
                       @"user":  @{
                               @"id": @16094494.0f,
                               @"kind":@"user",
                               @"permalink":@"michael-molloy-1",
                               @"username":@"Michael Molloy 1",
                               @"uri":@"https://api.soundcloud.com/users/16094494",
                               @"permalink_url":@"http://soundcloud.com/michael-molloy-1",
                               @"avatar_url":@"https://i1.sndcdn.com/avatars-000014392274-xxb7s1-large.jpg?3eddc42"
                               },
                       @"user_playback_count": @1,
                       @"user_favorite": @YES,
                       @"permalink_url":@"http://soundcloud.com/michael-molloy-1/sak-noel-loca-people",
                       @"artwork_url": [NSNull null],
                       @"waveform_url":@"https://w1.sndcdn.com/qHxzwWa5HvKt_m.png",
                       @"stream_url":@"https://api.soundcloud.com/tracks/50636638/stream",
                       @"playback_count": @46107,
                       @"download_count": @100,
                       @"favoritings_count": @539,
                       @"comment_count": @6,
                       @"attachments_uri":@"https://api.soundcloud.com/tracks/50636638/attachments"
                    };

}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testObjectCreation
{
    XCTAssertNotNil([[SCTTrackDataObject alloc] initWithData:self.testData], @"Track Data Object should parse JSON data correctly and initialize");
}

- (void)testGetSiteUrl
{
    SCTTrackDataObject* testObject = [[SCTTrackDataObject alloc] initWithData:self.testData];
    
    XCTAssertNotNil([testObject getSCSiteUrl], @"Track Data Object should parse JSON data correctly and retrive site  url");
    
    XCTAssertEqual([testObject getSCSiteUrl], [self.testData objectForKey:@"permalink_url"], @"Track Data Object should retrive the correct site url from JSON");
}

- (void)testGetTitle
{
    SCTTrackDataObject* testObject = [[SCTTrackDataObject alloc] initWithData:self.testData];
    
    XCTAssertNotNil([testObject getTitle], @"Track Data Object should parse JSON data correctly and retrive title data");
    
    XCTAssertEqual([testObject getTitle], [self.testData objectForKey:@"title"], @"Track Data Object should retrive the correct Title data from JSON");
}

- (void)testGetArtUrl
{
    SCTTrackDataObject* testObject = [[SCTTrackDataObject alloc] initWithData:self.testData];
    XCTAssertNotNil([testObject getArtworkUrl], @"Track Data Object should parse JSON data correctly and retrive track art");
    
    //make sure the track object grabs the correct URL - artwork, then user avatar
    NSString* correctURL = [self.testData objectForKey:@"artwork_url"];
    if([correctURL isKindOfClass:[NSNull class]] || [correctURL length] <= 0)
    {
        correctURL = [[self.testData objectForKey:@"user"] objectForKey:@"avatar_url"];
    }
    
    XCTAssertEqual([testObject getArtworkUrl], correctURL, @"Track Data Object should retrive the correct art url data from JSON");
}

@end

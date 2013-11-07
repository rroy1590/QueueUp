//
//  SCTTrackManagerTests.m
//  SoundCloudTest
//
//  Created by Raunak Roy on 11/1/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//
#import <XCTest/XCTest.h>
#import "SCTTrackManager.h"
#import "SCSoundCloud.h"
#import "SCSoundCloud+Private.h"
#import "Defines.h"

@interface SCTTrackManagerTests : XCTestCase
@end


@implementation SCTTrackManagerTests

- (void) setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    //setup test account login details
    if(![SCSoundCloud account])
    {
        [[SCSoundCloud shared] requestAccessWithUsername:TEST_USER_LOGIN password:TEST_USER_PASS];
    }
    
    // loop until the account info/auth tokens are loaded and available
    while (![SCSoundCloud account]) {
        // spend 1 second processing events on each loop
        NSDate *oneSecond = [NSDate dateWithTimeIntervalSinceNow:1];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:oneSecond];
    }
}

- (void) testLogin
{
    XCTAssertTrue([[SCTTrackManager sharedSingleton] isAvailable], @"Need a SC auth token to run tests!");
    //this test fails some times randomly.. looks like hitting the login api repeatedly might not work out
    
    //hmmm some weird issues with the oathaccountstore and setting a token to persistent..
}

- (void) testLoadUserData
{
    __block bool finished = false;
    
    [[SCTTrackManager sharedSingleton] loadUserDataWithHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        // Handle the response
        XCTAssertNil(error, @"There should be no error");
        // Check the statuscode and parse the data
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        XCTAssertNil(jsonError, @"There should be no error");
        
        XCTAssertTrue([jsonResponse isKindOfClass:[NSDictionary class]],@"jsonResponse should be dict");

        NSLog(@"%@",jsonResponse);
        finished = true;
    }];

    // loop until the flag is set from inside the task
    while (!finished) {
        // spend 1 second processing events on each loop
        NSDate *oneSecond = [NSDate dateWithTimeIntervalSinceNow:1];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:oneSecond];
    }
}

- (void) testLoadFavorites
{
    __block bool finished = false;
    
    [[SCTTrackManager sharedSingleton] loadDataFrom:BACKUP_URL withHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        // Handle the response
        XCTAssertNil(error, @"There should be no error");
        // Check the statuscode and parse the data
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        XCTAssertNil(jsonError, @"There should be no error");
        
        XCTAssertTrue([jsonResponse isKindOfClass:[NSArray class]],@"jsonResponse should be array");

        [SCTTrackManager sharedSingleton].favorites = (NSArray*)jsonResponse;
        
        NSLog(@"%@",jsonResponse);
        finished = true;
    }];
    
    // loop until the flag is set from inside the task
    while (!finished) {
        // spend 1 second processing events on each loop
        NSDate *oneSecond = [NSDate dateWithTimeIntervalSinceNow:1];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:oneSecond];
    }
    
    //Testing queueing and playing tracks:
    
    NSArray* favorites = [[SCTTrackManager sharedSingleton] getFavorites];
    
    XCTAssertTrue((favorites != nil && [favorites count] > 0), @"Favorites should have been loaded in previous test");
    
    NSDictionary* trackOne = [favorites objectAtIndex:0];
    NSDictionary* trackTwo = [favorites objectAtIndex:1];
    
    [[SCTTrackManager sharedSingleton] playTrack:trackOne];
    
    XCTAssertTrue([[[SCTTrackManager sharedSingleton] playQueue] count] > 0, @"Player should have queued: %@", [trackOne objectForKey:@"title"]);
    
    [[SCTTrackManager sharedSingleton] playTrack:trackTwo immediately:NO];
    
    XCTAssertTrue([[[SCTTrackManager sharedSingleton] playQueue] count] == 2, @"Player should only have queued: %@", [trackOne objectForKey:@"title"]);
    
    NSArray* playQueue = [[SCTTrackManager sharedSingleton] playQueue];
    
    NSDictionary* queuedTrack = [playQueue objectAtIndex:0];
    NSString* queuedTitle = [queuedTrack objectForKey:@"title"];
    
    XCTAssertTrue([queuedTitle isEqualToString:[trackOne objectForKey:@"title"]], @"trackone should be in queue pos 0");
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end

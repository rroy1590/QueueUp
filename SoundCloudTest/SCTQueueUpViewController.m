//
//  SCTQueueUpViewController.m
//  SoundCloudTest
//
//  Created by Raunak Roy on 10/28/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//

#import "SCTQueueUpViewController.h"
#import "SCTSwipeView.h"
#import "SCTTrackManager.h"

@interface SCTQueueUpViewController ()
@property (nonatomic, strong) SCTSwipeView* swipeView;
@property (nonatomic, strong) NSArray* trackList;
@property BOOL madeSelection;
@property double firstX;
@property double firstY;
@property NSDictionary* currentTrackData;
@end

@implementation SCTQueueUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"QueueUp"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidStart) name:STARTED_PLAYING object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidStop) name:FINISHED_PLAYING object:nil];
    if([[SCTTrackManager sharedSingleton] canPlayMusic])
    {
        [self playerDidStart];
    }
    [self spawnNew];
	// Do any additional setup after loading the view.
}

- (void) spawnNew
{
    CGRect frame = CGRectMake(0,0, self.view.frame.size.width,440);
    self.swipeView = [[SCTSwipeView alloc] initWithFrame:frame andDeleGate:self];
    [self.view addSubview:self.swipeView];
    [self.view bringSubviewToFront:self.swipeView];

}

- (void) setTracks:(NSArray *)trackList
{
    self.trackList = trackList;
}

- (IBAction) pressedYes:(id)sender
{
    [self.swipeView swipeRight];
}

- (IBAction) pressedNo:(id)sender
{
    [self.swipeView swipeLeft];
}

# pragma mark - <SCTSwipeViewDelegate> Methods

- (NSUInteger) numberOfTracks
{
    return [self.trackList count];
}

-(void)didMakeSelectionWith:(NSDictionary *)selectionData
{
    NSDictionary *track = [selectionData objectForKey:@"data"];
    if( [[selectionData objectForKey:@"choice"] isEqualToString:SWIPE_YES])
    {
        [[SCTTrackManager sharedSingleton] playTrack:track];
    }
}

-(NSDictionary*)dataForViewAtIndex:(NSUInteger)index
{
    if (index < [self.trackList count])
    {
        return [self.trackList objectAtIndex:index];
    }
    
    return [NSDictionary dictionary];
}

-(void) setCurrentTrack:(NSDictionary *)trackData
{
    self.currentTrackData = trackData;
}

# pragma mark - Audio Player

- (void) playerDidStart
{
    if(self.navigationItem.rightBarButtonItem == nil)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Now Playing" style:UIBarButtonItemStyleBordered target:self action:@selector(showPlayer)];
    }
}
-(void) showPlayer
{
    //[self.navigationController pushViewController:[SCTTrackManager sharedSingleton].controller animated:YES];
    [[SCTTrackManager sharedSingleton] showPlayerFromView:self];
}
- (void) playerDidStop
{
    if (![[SCTTrackManager sharedSingleton] canPlayMusic])
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

@end

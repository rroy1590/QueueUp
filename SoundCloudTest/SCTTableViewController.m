//
//  SCTMasterViewController.m
//  SoundCloudTest
//
//  Created by Raunak Roy on 10/27/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//

#import "SCTTableViewController.h"
#import <SCUI.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SCTTrackManager.h"
#import "SCTTrackDataObject.h"
#import "SCTTableViewCell.h"

#define DEFAULT_CELL_HEIGHT 80

@implementation SCTTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self tableView] registerClass:[SCTTableViewCell class] forCellReuseIdentifier:CELL_ID];
    self.tracks = [[SCTTrackManager sharedSingleton] getFavorites];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidStart) name:STARTED_PLAYING object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidStop) name:FINISHED_PLAYING object:nil];
    if([[SCTTrackManager sharedSingleton] canPlayMusic])
    {
        [self playerDidStart];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View delegate/datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = CELL_ID;
    
    SCTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[SCTTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellId andTrackData:[self.tracks objectAtIndex:indexPath.row]];
    }
    else{
        [cell setTrackData:[self.tracks objectAtIndex:indexPath.row]];
        [cell configureView];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DEFAULT_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
    
    [[SCTTrackManager sharedSingleton] playTrack:track immediately:YES];
    
    [self.tableView reloadData];
}

# pragma mark - Audio Player

- (void) playerDidStart
{
    if(self.navigationItem.rightBarButtonItem == nil)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Now Playing" style:UIBarButtonItemStyleBordered target:self action:@selector(showPlayer)];
    }
    
    [self.tableView reloadData];
}
-(void) showPlayer
{
    //[self.navigationController pushViewController:[SCTTrackManager sharedSingleton].controller animated:YES];
    [[SCTTrackManager sharedSingleton] showPlayerFromView:self];
}
- (void) playerDidStop
{
    if (![[SCTTrackManager sharedSingleton]  canPlayMusic])
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

@end

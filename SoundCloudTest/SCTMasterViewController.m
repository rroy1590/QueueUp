//
//  SCTMasterViewController.m
//  SoundCloudTest
//
//  Created by Raunak Roy on 10/27/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//

#import "SCTMasterViewController.h"
#import <SCUI.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SCTTrackManager.h"

@interface SCTMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation SCTMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
# pragma mark - SC Data


#pragma mark - Table View

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
    static NSString* cellId = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellId];
    }

    //set up label
    NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
    [cell.textLabel setText:[track objectForKey:@"title"]];
    [cell.textLabel setNumberOfLines:5];
    
    CGSize size = [cell.textLabel sizeThatFits:CGSizeMake(320,80)];
    [cell.textLabel setFrame:CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, size.width, size.height)];
    
    if([SCTTrackManager sharedSingleton].trackDescription == track)
    {
         cell.textLabel.textColor = [UIColor orangeColor];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    //set up image
    NSString* urlStr = [track objectForKey:@"artwork_url"];
    if( [urlStr isKindOfClass:[NSNull class]] || [urlStr length] <= 0 )
    {
        urlStr = [[track objectForKey:@"user"] objectForKey:@"avatar_url"];
    }
    
    [cell.imageView setImageWithURL:[NSURL URLWithString: urlStr]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
    
    [[SCTTrackManager sharedSingleton] playTrack:track immediately:YES];
    
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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

//
//  SCTLoginViewController.m
//  SoundCloudTest
//
//  Created by Raunak Roy on 10/28/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//

#import "SCTLoginViewController.h"
#import "SCTQueueUpViewController.h"
#import "SCTTableViewController.h"
#import "SCTTrackManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"
#import <NXOAuth2Constants.h>
#import <NXOAuth2Account.h>

@interface SCTLoginViewController ()
@property UIImageView* avatar;
-(void)requestAccessFailed:(NSNotification *)aNotification;
@end

@implementation SCTLoginViewController

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
    
    logoutButton.alpha = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestAccessFailed:)
                                                 name:SCSoundCloudDidFailToRequestAccessNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestAccessFailed:)
                                                 name:NXOAuth2AccountDidLoseAccessTokenNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCancelCallback) name:LOGIN_CANCEL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailCallback) name:LOGIN_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessCallback) name:LOGIN_SUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadedFavorites) name:LOADED_FAVORITES object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadedUserData:) name:LOADED_USER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadedStream) name:LOADED_STREAM object:nil];
    
    // Do any additional setup after loading the view.
    favoritesButton.alpha = 0;
    queueUpButton.alpha = 0;
    

    //check if we have a stored auth token, and load data immediately if we do!
    if ( [[SCTTrackManager sharedSingleton] isAvailable] )
    {
        loginButton.alpha = 0;
        logoutButton.alpha = 1;
        [self loginSuccessCallback];
    } else {
        [self.navigationItem setTitle:@"Please Log In"];
    }
    
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

# pragma mark - Callbacks
- (void)requestAccessFailed:(NSNotification *)aNotification
{
    NSError *error = [[aNotification userInfo] objectForKey:NXOAuth2AccountStoreErrorKey];
    NSLog(@"Requesting access to SoundCloud did fail with error: %@", [error localizedDescription]);
    
    [self loginFailCallback];
}

- (void) loadedUserData: (NSNotification*) userData
{
    NSDictionary *data = userData.object;
    NSString* title = [NSString stringWithFormat:@"Welcome %@",[data objectForKey:@"full_name"]];
    
    [self.navigationItem setTitle:title];
    
    NSString* url = [data objectForKey:@"avatar_url"];
    self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(61.5,230,200,200)];
    [self.view addSubview:self.avatar];
    
    
    [self.avatar setImageWithURL:[NSURL URLWithString:url]
                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void) loadedStream
{
    queueUpButton.alpha = 1;
}
- (void) loadedFavorites
{
    favoritesButton.alpha = 1;
}

- (void) loginSuccessCallback
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SCTTrackManager sharedSingleton] loadData];
    
    loginButton.alpha = 0;
    logoutButton.alpha = 1;
}

- (void) loginFailCallback
{
    [self.navigationController setTitle:@"Login Error"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void) loginCancelCallback
{
    //do nothing
}

# pragma mark - IBActions

- (IBAction) login:(id) sender
{
    [[SCTTrackManager sharedSingleton] loginFrom:self];
}

- (IBAction) logout:(id) sender
{
    [[SCTTrackManager sharedSingleton] logout];
    [self.navigationItem setTitle:@"Please Log In"];
    
    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:1 animations:nil];
    self.avatar.image = nil;
    logoutButton.alpha = 0;
    loginButton.alpha = 1;
    favoritesButton.alpha = 0;
    queueUpButton.alpha = 0;
    [UIView commitAnimations];
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

# pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"QueueUpSegue"]) {
        if([[[SCTTrackManager sharedSingleton] fullTrackList] count]  > 0)
        {
            [[segue destinationViewController] setTracks:[[SCTTrackManager sharedSingleton] fullTrackList]];
        } else {
            [[segue destinationViewController] setTracks:[[SCTTrackManager sharedSingleton] getFavorites]];
        }
    } else if([[segue identifier] isEqualToString:@"FavoritesSegue"])
    {
        [[segue destinationViewController] setTracks:[[SCTTrackManager sharedSingleton] getFavorites]];
    }
}

@end

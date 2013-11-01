//
//  SCTLoginViewController.m
//  SoundCloudTest
//
//  Created by Raunak Roy on 10/28/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//

#import "SCTLoginViewController.h"
#import "SCTQueueUpViewController.h"
#import "SCTMasterViewController.h"
#import "SCTTrackManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"

@interface SCTLoginViewController ()
@property UIImageView* avatar;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCancelCallback) name:LOGIN_CANCEL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailCallback) name:LOGIN_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessCallback) name:LOGIN_SUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadedFavorites:) name:LOADED_FAVORITES object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadedUserData:) name:LOADED_USER object:nil];
    
    // Do any additional setup after loading the view.
    getFeedButton.alpha = 0;
    queueUpButton.alpha = 0;
    

    //check if we have a stored auth token, and load data immediately if we do!
    if ( [[SCTTrackManager sharedSingleton] isAvailable] )
    {
        loginButton.alpha = 0;
        [self loginSuccessCallback];
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

- (void) loadedFavorites: (NSArray*) favorites
{
    getFeedButton.alpha = 1;
    queueUpButton.alpha = 1;
}

- (void) loginSuccessCallback
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SCTTrackManager sharedSingleton] loadData];
    
    loginButton.alpha = 0;
    [loginButton setEnabled:NO];
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
        [[segue destinationViewController] setTracks:[[SCTTrackManager sharedSingleton] getFavorites]];
    }
}

@end

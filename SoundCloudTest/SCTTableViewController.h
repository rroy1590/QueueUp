//
//  SCTMasterViewController.h
//  SoundCloudTest
//
//  Created by Raunak Roy on 10/27/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SCTTableViewController : UITableViewController<AVAudioPlayerDelegate>
{
    IBOutlet UINavigationItem* nav;
}

@property (nonatomic, strong) NSArray *tracks;

@end

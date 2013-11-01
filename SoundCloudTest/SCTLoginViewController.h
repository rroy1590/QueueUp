//
//  SCTLoginViewController.h
//  SoundCloudTest
//
//  Created by Raunak Roy on 10/28/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SCUI.h>

@interface SCTLoginViewController : UIViewController
{
    IBOutlet UIButton* loginButton;
    IBOutlet UIButton* logoutButton;
    IBOutlet UIButton* getFeedButton;
    IBOutlet UIButton* queueUpButton;
}

- (IBAction) login:(id) sender;

@end

//
//  SCTDetailViewController.h
//  SoundCloudTest
//
//  Created by Raunak Roy on 10/27/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

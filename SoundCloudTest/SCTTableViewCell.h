//
//  SCTTableViewCell.h
//  SoundCloudTest
//
//  Created by Raunak Roy on 11/1/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTTrackDataObject.h"

#define CELL_ID @"SCTTableViewCellId"

@interface SCTTableViewCell : UITableViewCell

@property(nonatomic,assign) NSDictionary* trackData;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTrackData:(NSDictionary*) track;
- (void) configureView;
@end

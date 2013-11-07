//
//  SCTTableViewCell.m
//  SoundCloudTest
//
//  Created by Raunak Roy on 11/1/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//

#import "SCTTableViewCell.h"
#import "SCTTrackManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SCTTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTrackData:(NSDictionary*) track
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setTrackData:track];
        [self configureView];
    }
    return self;
}

- (void) setTrackData:(NSDictionary *)trackData
{
    _trackData = trackData;
}

- (void) configureView
{
    //set up label
    SCTTrackDataObject *tDataObj = [[SCTTrackDataObject alloc] initWithData:self.trackData];
    
    [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
    [self.textLabel setText:[tDataObj getTitle]];
    [self.textLabel setNumberOfLines:5];
    
    CGSize size = [self.textLabel sizeThatFits:CGSizeMake(320,80)];
    [self.textLabel setFrame:CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y-15, size.width, size.height)];
    self.textLabel.backgroundColor = [UIColor clearColor];
    
    if([SCTTrackManager sharedSingleton].trackDescription == self.trackData)
    {
        self.textLabel.textColor = [UIColor yellowColor];
    } else {
        self.textLabel.textColor = [UIColor whiteColor];
    }
    CALayer* shadowLayer = [self.textLabel layer];
    shadowLayer.backgroundColor = [UIColor clearColor].CGColor;
    shadowLayer.shadowColor = [UIColor blackColor].CGColor;
    shadowLayer.shadowOpacity = 1;
    shadowLayer.shadowOffset = CGSizeMake(0,1);
    shadowLayer.shadowRadius = 1;
    
    //waveform bg
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_bg.png"]];
    
    __weak UIImageView *imageViewToMask = (UIImageView*)self.backgroundView;
    
    NSString* waveUrl = [self.trackData objectForKey:@"waveform_url"];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:[NSURL URLWithString:waveUrl]
                     options:0
                    progress:nil
                   completed:^(UIImage *maskImage, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                       
                       UIImage *image = [UIImage imageNamed:@"list_bg.png"];
                       
                       CGImageRef originalMask = maskImage.CGImage;
                       CGRect crop = CGRectMake (0, 0, maskImage.size.width, maskImage.size.height/2);
                       originalMask = CGImageCreateWithImageInRect (originalMask, crop);
                       
                       
                       CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(originalMask),
                                                           CGImageGetHeight(originalMask),
                                                           CGImageGetBitsPerComponent(originalMask),
                                                           CGImageGetBitsPerPixel(originalMask),
                                                           CGImageGetBytesPerRow(originalMask),
                                                           CGImageGetDataProvider(originalMask), nil, YES);
                       
                       CGImageRef maskedImageRef = CGImageCreateWithMask(image.CGImage, mask);
                       
                       UIImage *finalImage = [UIImage imageWithCGImage:maskedImageRef scale:image.scale orientation:image.imageOrientation];
                       
                       CGImageRelease(mask);
                       CGImageRelease(maskedImageRef);
                       [imageViewToMask setImage:finalImage];
                   }];
    
    
    //set up image
    NSString* urlStr = [tDataObj getArtworkUrl];
    
    [self.imageView setImageWithURL:[NSURL URLWithString: urlStr]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

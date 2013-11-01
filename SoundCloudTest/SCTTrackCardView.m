//
//  SCTTrackCardView.m
//  SoundCloudTest
//
//  Created by Raunak Roy on 10/30/13.
//  Copyright (c) 2013 Raunak Roy. All rights reserved.
//

#import "SCTTrackCardView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SCTTrackCardView()
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* imgUrl;
@property (nonatomic, strong) UIImageView* trackArt;
@property (nonatomic, strong) UIImageView* bg;
@property (nonatomic, strong) UILabel* trackTitle;
@end

@implementation SCTTrackCardView

- (id)initWithFrame:(CGRect)frame withTitle: (NSString*) title andImageUrl: (NSString*) imgUrl
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.title = title;
        self.imgUrl = imgUrl;
        
        [self layout];
    }
    return self;
}

- (void) layout
{
    //bg
    self.bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trackviewbg.png"]];
    [self.bg setFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.width)];
    [self addSubview:self.bg];
    
    //Art
    self.trackArt = [[UIImageView alloc] initWithFrame:CGRectMake(40,17.5,160,160)];
    [self addSubview:self.trackArt];
    
    
    [self.trackArt setImageWithURL:[NSURL URLWithString:self.imgUrl]
                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    //Label
    self.trackTitle = [[UILabel alloc] init];
    [self.trackTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
    [self.trackTitle setText:self.title];
    self.trackTitle.numberOfLines = 5;
    [self.trackTitle setTextColor:[UIColor whiteColor]];
    
    CALayer* shadowLayer = [self.trackTitle layer];
    shadowLayer.backgroundColor = [UIColor clearColor].CGColor;
    shadowLayer.shadowColor = [UIColor blackColor].CGColor;
    shadowLayer.shadowOpacity = 0.85;
    shadowLayer.shadowOffset = CGSizeMake(0,1);
    shadowLayer.shadowRadius = 1;
    
    CGSize size = [self.trackTitle sizeThatFits:CGSizeMake(180,80)];
    
    CGFloat labelY = self.frame.size.height - size.height - 25;
    self.trackTitle.frame = CGRectMake(20,labelY,size.width+10,size.height+10);
    
    [self addSubview:self.trackTitle];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

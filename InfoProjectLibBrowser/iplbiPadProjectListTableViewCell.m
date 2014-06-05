//
//  iplbiPadProjectListTableViewCell.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-6-3.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbiPadProjectListTableViewCell.h"

@implementation iplbiPadProjectListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(15,5,90,90);
    float limgW =  self.imageView.image.size.width;
    if(limgW > 0) {
        self.textLabel.frame = CGRectMake(120,self.textLabel.frame.origin.y,self.textLabel.frame.size.width,self.textLabel.frame.size.height);
        self.detailTextLabel.frame = CGRectMake(120,self.detailTextLabel.frame.origin.y,self.detailTextLabel.frame.size.width,self.detailTextLabel.frame.size.height);
    }
}
@end

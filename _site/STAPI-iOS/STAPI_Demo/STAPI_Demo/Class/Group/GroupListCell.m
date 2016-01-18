//
//  GroupListCell.m
//  STAPI_Demo
//
//  Created by SenseTime on 16/1/4.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import "GroupListCell.h"

@implementation GroupListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell
{
    self.lbName = [[UILabel alloc] init];
    self.lbName.frame = CGRectMake(50, self.contentView.frame.size.height/2-5, 60, 30);
    self.lbName.font = [UIFont systemFontOfSize:12];
    self.lbName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.lbName];
    
    self.lbFaceCount = [[UILabel alloc] init];
    self.lbFaceCount.backgroundColor = [UIColor clearColor];
    self.lbFaceCount.textAlignment = NSTextAlignmentLeft;
    self.lbFaceCount.frame = CGRectMake(680, self.contentView.frame.size.height/2-5, 60, 30);
    self.lbFaceCount.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.lbFaceCount];
}

@end

//
//  ZKCommentCell.m
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/8.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKCommentCell.h"
#import "CYmiangzhu-Swift.h"
#import "ZKCommentModel.h"

NSString *const ZKCommentCellID = @"ZKCommentCellID";

@interface ZKCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet RatingBar *ratingBar;
@property (weak, nonatomic) IBOutlet UILabel *addtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end

@implementation ZKCommentCell


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.headImageView.layer.cornerRadius =self.headImageView.frame.size.width/2;
    self.headImageView.clipsToBounds = YES;
    
}

- (void)setCommentModel:(ZKCommentModel *)commentModel
{
    _commentModel = commentModel;
    
    [ZKUtil UIimageView:self.headImageView NSSting:commentModel.photo duImage:@"detail_head"];
    
    self.userNameLabel.text = [commentModel.name isEqualToString:@""]||[commentModel.name isEqualToString:@"null"] ? @"游客" : commentModel.name;
    self.ratingBar.rating = commentModel.score.doubleValue;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-M-d";
    NSDate *addDate = [NSDate dateWithTimeIntervalSince1970:commentModel.addtime / 1000];
    self.addtimeLabel.text = [fmt stringFromDate:addDate];
    self.contentLabel.text = commentModel.content;
}

@end

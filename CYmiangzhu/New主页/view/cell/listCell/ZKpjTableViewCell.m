//
//  ZKpjTableViewCell.m
//  CYmiangzhu
//
//  Created by 小腊 on 16/5/15.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKpjTableViewCell.h"

@implementation ZKpjTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier listData:(NSArray*)data;
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        float x = 5.0f;
        float y = 7.5;
        float p = 0.0f;
        
        for (int i = 0; i<data.count; i++) {
            
            float labelW = [self labelCgsizeFlot:12 Titis:data[i]];
            x = x+p;

            if (i<data.count-1 && y == 7.5) {
                
                float cqW = [self labelCgsizeFlot:12 Titis:data[i+1]];
                if (cqW + x + 5 > kDeviceWidth) {
                    
                    x = 5;
                    p = 0.0f;
                    y = 7.5+20+5;
                    x = x+p;
                    
                }
                
            }
    
            p = labelW+5;
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, labelW, 20)];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment  = NSTextAlignmentCenter;
            label.textColor = [UIColor orangeColor];
            label.text = data[i];
            label.layer.masksToBounds = YES;
            label.layer.borderWidth = 1;
            label.layer.borderColor = [UIColor orangeColor].CGColor;
            [self addSubview:label];
            
        }
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//返回label状态
- (float)labelCgsizeFlot:(float)flot Titis:(NSString*)str
{
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:flot]};
    CGSize size = [str boundingRectWithSize:CGSizeMake(kDeviceWidth, 20) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size.width+10;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

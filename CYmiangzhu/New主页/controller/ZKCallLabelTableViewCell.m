//
//  ZKCallLabelTableViewCell.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/16.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKCallLabelTableViewCell.h"

@implementation ZKCallLabelTableViewCell
- (NSMutableArray<UIButton *> *)butArray
{

    if (!_butArray) {
        
        _butArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _butArray;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier listData:(NSArray*)data;
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        float labelW = (kDeviceWidth-52)/5;
        
        for (int i =0 ; i<data.count; i++) {
            
            UIButton *bty = [[UIButton alloc]initWithFrame:CGRectMake(10+(labelW+8)*(i%5), 10+30*(i/5), labelW, 20)];
            bty.titleLabel.font = [UIFont systemFontOfSize:12];
            bty.titleLabel.textAlignment  = NSTextAlignmentCenter;
            [bty setTitle:data[i] forState:0];
            [bty setTitleColor:[UIColor orangeColor] forState:0];
            bty.tag = i;
            [bty addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            bty.selected = NO;
            bty.layer.masksToBounds = YES;
            bty.layer.borderWidth = 1;
            bty.layer.borderColor = [UIColor orangeColor].CGColor;
            [self.butArray addObject:bty];
            [self addSubview:bty];
            
        }
            
        
    }
    return self;
}

- (void)click:(UIButton*)sender
{
    [self.butArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.tag == sender.tag )
        {
            
            [obj setTitleColor:[UIColor whiteColor] forState:0];
            obj.backgroundColor = [UIColor orangeColor];
            self.choice(sender.tag);
        }
        else
        {
            [obj setTitleColor:[UIColor orangeColor] forState:0];
            obj.backgroundColor = [UIColor whiteColor];
        }
    }];
}
- (void)choice:(selecTitle)dex;
{

    self.choice = dex;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  ZKNewHomeTableViewCell.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/11.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKNewHomeTableViewCell.h"
#import "ZKInformationModel.h"
#import "ZKStrategyModel.h"

@implementation ZKNewHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier SuperViews:(homecellTyper)typer;
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.cellType = typer;
        
        self.pictureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, cellHeight)];
        self.pictureView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.pictureView];
        
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 4, kDeviceWidth-16, cellHeight-8)];
        self.backImageView.layer.masksToBounds = YES;
        self.backImageView.clipsToBounds = YES;
        self.backImageView.layer.cornerRadius = 4;
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.backImageView];
        
       
        [self initSuperViews:typer];
    }

    return self;
}


- (void)initSuperViews:(homecellTyper)typer;

{
    
    if (typer == homecellOne)
    {
        
        self.inforLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.inforLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.inforLabel.textColor = [UIColor whiteColor];
        self.inforLabel.layer.masksToBounds = YES;
        self.inforLabel.layer.cornerRadius = 10;
        self.inforLabel.font = [UIFont systemFontOfSize:14];
        [self.backImageView addSubview:self.inforLabel];
        
    }
    else
    {
    
        self.lefImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.backImageView addSubview:self.lefImageView];
        
       
        self.lefImageView.layer.masksToBounds = YES;
        self.lefImageView.layer.cornerRadius = 19;
        self.lefImageView.layer.borderWidth = 2;
        self.lefImageView.layer.borderColor = YJCorl(244, 244, 244).CGColor;
        
        self.inforLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.inforLabel.backgroundColor = [UIColor clearColor];
        self.inforLabel.textColor = [UIColor whiteColor];
        self.inforLabel.font = [UIFont systemFontOfSize:14];
        [self.backImageView addSubview:self.inforLabel];
              
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.stateLabel.backgroundColor = [UIColor clearColor];
        self.stateLabel.textColor = [UIColor whiteColor];
        self.stateLabel.font = [UIFont systemFontOfSize:13];
        [self.backImageView addSubview:self.stateLabel];
        
          }
    

}


- (void)setDataOne:(ZKInformationModel *)dataOne
{

    [ZKUtil UIimageView:self.backImageView NSSting:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, dataOne.cover]];
    self.inforLabel.text = [NSString stringWithFormat:@"     %@",dataOne.title];
}

- (void)setDataTow:(ZKStrategyModel *)dataTow
{

    [ZKUtil UIimageView:self.backImageView NSSting:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, dataTow.images]];
    self.inforLabel.text = dataTow.title;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *addDate = [NSDate dateWithTimeIntervalSince1970:dataTow.addtime.doubleValue / 1000];
    NSString * dataStr  = [fmt stringFromDate:addDate];
    NSString * str = [NSString stringWithFormat:@"%@人查看",dataTow.views];
    self.stateLabel.text = [NSString stringWithFormat:@"%@ | %@",dataStr,str];
    [ZKUtil UIimageView:self.lefImageView NSSting:dataTow.photo];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.cellType == homecellOne)
    {
        
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGSize size = [self.inforLabel.text boundingRectWithSize:CGSizeMake(kDeviceWidth-40, 20) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        float labelWidth =size.width;
        self.inforLabel.frame = CGRectMake(-10, self.backImageView.frame.size.height-30,labelWidth+14,20);

    }
    else if(self.cellType == homecellTow)
    {
    
        
        [self.lefImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.height.mas_equalTo(38);
            make.left.mas_equalTo(self.backImageView.mas_left).offset(8);
            make.bottom.mas_equalTo(self.backImageView.mas_bottom).offset(-8);
        }];
        [self.inforLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.lefImageView.mas_right).offset(4);
            make.top.mas_equalTo(self.lefImageView.mas_top);
            make.height.mas_equalTo(18);
        }];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.lefImageView.mas_right).offset(4);
            make.bottom.mas_equalTo(self.lefImageView.mas_bottom);
            make.height.mas_equalTo(18);
        }];

        
    
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

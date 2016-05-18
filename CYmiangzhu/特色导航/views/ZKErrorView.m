//
//  ZKErrorView.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/13.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKErrorView.h"

@interface ZKErrorView ()
@property (nonatomic, weak) UIButton *reloadBtn;
@end

@implementation ZKErrorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = ClearColor;
        
        UIImageView *errImgView = [[UIImageView alloc] init];
        errImgView.image = [UIImage imageNamed:@"No-record-default"];
        [self addSubview:errImgView];
        
         __weak typeof(self)wSelf = self;
        [errImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(80);
            make.top.equalTo(wSelf).with.offset(20);
            make.centerX.equalTo(wSelf);
        }];
        
        UIButton *reloadBtn = [[UIButton alloc] init];
        reloadBtn.layer.cornerRadius = 5;
        reloadBtn.layer.masksToBounds = YES;
        reloadBtn.layer.borderWidth = 1;
        reloadBtn.layer.borderColor = [UIColor grayColor].CGColor;
        reloadBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        reloadBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [reloadBtn addTarget:self action:@selector(reloadBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [reloadBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:reloadBtn];
        
        [reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 30));
            make.top.equalTo(errImgView.mas_bottom).with.offset(8);
            make.centerX.equalTo(wSelf);
        }];
    }
    return self;
}

- (void)reloadBtnClick
{
    !self.reloadBlock ? : self.reloadBlock();
}

- (void)addTarget:(id)target selector:(SEL)selector
{
    [self.reloadBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

@end

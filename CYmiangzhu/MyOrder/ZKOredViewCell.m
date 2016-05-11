//
//  HomeViewCell.m
//  thinklion
//
//  Created by user on 15/12/5.
//  Copyright (c) 2015年 user. All rights reserved.
//   本人也是iOS开发者 一枚，酷爱技术 这是我的官方交流群  519797474

#import "ZKOredViewCell.h"
#import "ZKmyOrdeMode.h"

NSString *const ZKOredViewCellID = @"ZKOredViewCellID";

@interface ZKOredViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dtIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *dtTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fotoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jgLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonClick;

@property (strong, nonatomic)ZKmyOrdeMode *list;
@end

@implementation ZKOredViewCell





//传递数据模型
-(void)setOrdeModel:(ZKmyOrdeMode *)ordeModel
{
    NSInteger index =self.state.integerValue;
    
    self.list = ordeModel;
    
    switch (index) {
        case 0:
            [self.buttonClick setTitle:@"付款" forState:0];
            break;
            
        case 1:
            if (ordeModel.validConsumeSize.integerValue == 0) {
                
                [self.buttonClick setTitle:@"已失效" forState:0];
                
            }else{
                [self.buttonClick setTitle:@"退款" forState:0];
            }
            
            break;
        case 2:
            self.buttonClick.layer.opacity = 0;
            break;
        case 3:
            
            if (ordeModel.rsize.integerValue == 0) {
                
                if (ordeModel.refundSize == 0) {
                    
                    [self.buttonClick setTitle:@"退款失败" forState:0];
                    
                }else{
                
                    [self.buttonClick setTitle:@"已退款" forState:0];
                }
      
            }else{
                [self.buttonClick setTitle:@"审核中" forState:0];
            }
        
            [self.buttonClick setBackgroundColor:YJCorl(129, 129, 129)];
            break;
        default:
            break;
    }
    
    self.dtIDLabel.text = [NSString stringWithFormat:@"订单号:%@",ordeModel.orderCode];
    self.dtTimeLabel.text =[NSString stringWithFormat:@"%@",ordeModel.buyDate];
    NSString *url = [[ordeModel.img valueForKey:@"focusimage"][0] valueForKey:@"filepath"];
    [ZKUtil UIimageView:self.fotoImage NSSting:[NSString stringWithFormat:@"%@%@",DDIMAGE_URL,url]];
    
    self.nameLabel.text =ordeModel.name;
    self.jgLabel.text = [NSString stringWithFormat:@"%@*%@",ordeModel.price,ordeModel.size];
    self.totalPriceLabel.text =[NSString stringWithFormat:@"¥%@",ordeModel.total];


}

- (IBAction)buttonClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(ZKOredViewCellbutton:)]) {
        
        [self.delegate ZKOredViewCellbutton:self.list];
    }
    
    
}



@end

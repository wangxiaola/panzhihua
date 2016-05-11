



#import "TestMapCell.h"
#import "ZKAppDelegate.h"

@implementation TestMapCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView =[[UIImageView alloc] initWithFrame:CGRectMake(4, 10, 95, 95)];
        
        self.imageView.layer.cornerRadius =7;
        self.imageView.layer.masksToBounds =YES;
        self.imageView.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.imageView];
        

        self.title =[[UILabel alloc]initWithFrame:CGRectMake(86+15, 8, self.frame.size.width-70, 35)];
        self.title.font =[UIFont systemFontOfSize:14];
        self.title.backgroundColor =[UIColor clearColor];
        self.title.textColor =[UIColor blackColor];
        self.title.numberOfLines =2;
        [self addSubview:self.title];
        
        self.subtitle =[[UILabel alloc]initWithFrame:CGRectMake(86+15, 40, self.frame.size.width-67, 32)];
        self.subtitle.backgroundColor =[UIColor clearColor];
        self.subtitle.font =[UIFont systemFontOfSize:12];
        self.subtitle.numberOfLines =2;
        self.subtitle.textColor =[UIColor grayColor];
        [self addSubview:self.subtitle];
        
        self.phoneLabel =[[UILabel alloc]initWithFrame:CGRectMake(86+15, 72, self.frame.size.width -67, 15)];
        self.phoneLabel.font =[UIFont systemFontOfSize:12];
        self.phoneLabel.textColor =[UIColor grayColor];
        self.phoneLabel.backgroundColor =[UIColor clearColor];
        [self addSubview:self.phoneLabel];
        
        UIButton *bty =[[UIButton alloc]initWithFrame:CGRectMake(102, 52, self.frame.size.width - 67, 40)];
        bty.backgroundColor = [UIColor clearColor];
        [bty addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bty];
        
        UILabel*lin =[[UILabel alloc]initWithFrame:CGRectMake(82+20, 95, self.frame.size.width-67, 1)];
        lin.backgroundColor =[UIColor grayColor];
        [self addSubview:lin];

        self.goView =[[UIImageView alloc]initWithFrame:CGRectMake(82+15, 90, self.frame.size.width-87, 20)];
        self.userInteractionEnabled =YES;
        UIImageView *views =[[UIImageView alloc]initWithFrame:CGRectMake(5, 8, 50, 16)];
        views.image =[UIImage imageNamed:@"goMP"];
        [self.goView addSubview:views];
        [self addSubview:self.goView];
        
    }
    return self;
}
-(void)click
{

    if ([self.phoneLabel.text isEqualToString:@"电话:暂无电话！"]) {
        
        [self makeToast:@"暂无电话!"];
        
        return;
    }
    NSString *str = [self.phoneLabel.text stringByReplacingOccurrencesOfString:@"电话:" withString:@""];
    
    NSMutableString * str_0=[[NSMutableString alloc] initWithFormat:@"tel:%@",[str stringByReplacingOccurrencesOfString:@"—" withString:@""]];
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str_0]]];
    [[APPDELEGATE window] addSubview:callWebview];

}
@end

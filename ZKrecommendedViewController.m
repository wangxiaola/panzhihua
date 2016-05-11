//
//  DQGrabbleRecordViewController.m
//  changyouyibin
//
//  Created by Daqsoft-Mac on 15/2/9.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKrecommendedViewController.h"
#import "ZKTextField.h"
#import "Item.h"
#import "ZKrecordMapViewController.h"
@interface ZKrecommendedViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    ZKTextField *grabble;
    
    NSString *type;
    
    NSMutableArray *dataArray;
    
    UIButton *hintButton;
    
    NSMutableArray *list;
    
    UITableView *tabelView;
    
    UIView *xView;
    
    NSMutableArray *annonArray;
    
    NSString *mykey;
    
    UIButton *recordButton;
    
    NSString *pcName;
    
}
@end

@implementation ZKrecommendedViewController

-(id)init:(NSArray*)data;
{

    
    
    self =[super init];
    
    if (self) {
        
        NSString *pc =data[0];
        NSArray *tits =[pc componentsSeparatedByString:@"="];
        type =tits[1];
        
        NSString *pb =data[1];
        NSArray *titss =[pb componentsSeparatedByString:@"="];
        pcName =titss[1];
        
        
        
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.titeLabel removeFromSuperview];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
    NSString *sPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:type];
    
    dataArray =[[NSMutableArray alloc]initWithCapacity:0];
    list =[[NSMutableArray alloc]initWithCapacity:0];
    annonArray =[[NSMutableArray alloc]initWithCapacity:0];

    if (sPath) {
        
        dataArray = [NSMutableArray arrayWithContentsOfFile:sPath];
        
        
    }
    [self initTabelView];
    
    NSLog(@" == %@",type);

    UIButton *ritButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-2-40, 20, 40, 40)];
    [ritButton setImage:[UIImage imageNamed:@"hunt"] forState:UIControlStateNormal];
    ritButton.backgroundColor =[UIColor clearColor];
    [ritButton addTarget:self action:@selector(ritButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ritButton];
    
    UILabel *lin =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width -100, 20)];
    lin.backgroundColor =[UIColor clearColor];
    lin.layer.masksToBounds =YES;
    lin.layer.borderColor =[UIColor whiteColor].CGColor;
    lin.layer.borderWidth =1;
    lin.center =CGPointMake(self.navigationBarView.frame.size.width/2, self.navigationBarView.frame.size.height/2+15);
    [self.navigationBarView addSubview:lin];
    
    
    grabble =[[ZKTextField alloc]initWithFrame:CGRectMake(0, 0, self.navigationBarView.frame.size.width-90, 30)];
    grabble.center =CGPointMake(self.navigationBarView.frame.size.width/2, self.navigationBarView.frame.size.height/2+6);
    grabble.placeholder =@" 输入关键字搜索";
    grabble.clearButtonMode = UITextFieldViewModeUnlessEditing;
    grabble.delegate =self;
    grabble.returnKeyType =UIReturnKeySearch;
    grabble.clearsOnBeginEditing = YES;
    grabble.leftViewMode = UITextFieldViewModeAlways;
    grabble.backgroundColor =CYBColorGreen;
    [self.navigationBarView addSubview:grabble];
    
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView =NO;
    [self.view addGestureRecognizer:tapGr];
    
    UILabel * hintLabel =[[UILabel alloc]initWithFrame:CGRectMake(6, 64, 70, 30)];
    hintLabel.backgroundColor =[UIColor whiteColor];
    hintLabel.textAlignment =NSTextAlignmentLeft;
    hintLabel.textColor =[UIColor orangeColor];
    hintLabel.text =@"热门搜索";
    hintLabel.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:hintLabel];
    
    [self postData];
    // Do any additional setup after loading the view.
}

#pragma mark 查询记录

-(void)initTabelView
{
    
    tabelView =[[UITableView alloc]initWithFrame:CGRectMake(0, 30+64+15, self.view.frame.size.width, self.view.frame.size.height-64-30-15)];
    tabelView.showsHorizontalScrollIndicator =NO;
    tabelView.delegate =self;
    tabelView.dataSource =self;
    tabelView.bounces =NO;
    tabelView.backgroundColor =[UIColor whiteColor];
    tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tabelView];
    
    
    UIView *forView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, tabelView.frame.size.width, 40)];
    forView.backgroundColor =[UIColor whiteColor];
    
    recordButton =[[UIButton alloc]initWithFrame:forView.bounds];
    recordButton.titleLabel.textAlignment =NSTextAlignmentCenter;
    recordButton.backgroundColor =CYBColorGreen;
    recordButton.titleLabel.font =[UIFont systemFontOfSize:13];
    if (dataArray.count ==0) {
        
        [recordButton setTitle:@"暂无搜素记录" forState:UIControlStateNormal]
        ;
        recordButton.titleLabel.textColor =[UIColor whiteColor];
    }else{
        [recordButton setTitle:@"清空搜素记录" forState:UIControlStateNormal];

    }
    
    [recordButton addTarget:self action:@selector(recordButt) forControlEvents:UIControlEventTouchUpInside];
    [forView addSubview:recordButton];
    
    tabelView.tableFooterView =forView;

    
}
/**
 *  更新坐标
 */
-(void)tabelUpdata
{

    float UseHighly =64+30+xView.frame.size.height+15;
    
    [UIView animateWithDuration:0.1 animations:^{
        
    tabelView.frame  =CGRectMake(0,UseHighly, self.view.frame.size.width, self.view.frame.size.height-UseHighly);
    }];


}
/**
 *  画推荐视图
 */
-(void)initView
{
    
    float width =(self.view.frame.size.width-40) /3;
    float interval =10;
    float sheight =64;
    
    NSInteger p_0 =list.count/3;
    
    NSInteger p_1;
    if (list.count%3>0) {
        
        p_1 =1;
    }else{
        p_1 =0;
    }
    
    NSInteger p_3 =p_0+p_1;
    
    
    xView=[[UIView alloc]initWithFrame:CGRectMake(0, sheight+30, self.view.frame.size.width, (44+10)*p_3)];
    xView.backgroundColor =[UIColor whiteColor];
    
    for (int i =0; i<list.count; i++) {
        UIButton *buy =[[UIButton alloc]initWithFrame:CGRectMake(interval + (width+interval)*(i%3),(44+interval)*(i/3), width, 44)];
        buy.layer.masksToBounds =YES;
        buy.layer.borderColor =[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1].CGColor;
        buy.layer.cornerRadius =4;
        buy.layer.borderWidth =0.4;
        Item *ites =[list objectAtIndex:i];
        [buy setTitle:ites.name  forState:UIControlStateNormal];
        [buy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        buy.titleLabel.numberOfLines =2;
        buy.titleLabel.font =[UIFont systemFontOfSize:12];
        buy.tag = i+1000;
        [buy addTarget:self action:@selector(buyClikc:) forControlEvents:UIControlEventTouchUpInside];
        [xView addSubview:buy];
        
    }
    
    [self.view addSubview:xView];
    
    UIView *label =[[UIView alloc]initWithFrame:CGRectMake(0, xView.frame.size.height-0.4, xView.frame.size.width, 0.4)];
    label.backgroundColor=[UIColor grayColor];
    [xView addSubview:label];
    
    [self  tabelUpdata];
}

/**
 *  推荐数据
 */
-(void)postData;
{

    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    
    [dic setObject:@"resoureList" forKey:@"method"];
    [dic setObject:@"48FCADED5B7009C4AED5E5461E6888C0" forKey:@"seccode"];
    [dic setObject:type forKey:@"type"];
    [dic setObject:@"" forKey:@"key"];
    [dic setObject:@"1" forKey:@"recommend"];
    
    [ZKHttp Post:@"http://192.168.0.173:8888/mz_web/app/zxwinterface.do" params:dic success:^(id responseObj) {
        
        if (responseObj) {

            NSArray *array =[responseObj valueForKey:@"rows"];
            
            for (int i=0; i<array.count; i++) {
                
                NSDictionary *dic =array[i];
                Item *lists =[[Item alloc]initWithDictionary:dic anntp: type];
                
                [list addObject:lists];

                
            }
 
            [self initView];
            
        }
        
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络不好，请稍后重试！"];
        
        
    }];
    
}

/**
 *  搜素数据
 */
-(void)searchPost
{
    if (strIsEmpty(mykey)==1) {
        
        [self.view makeToast:@"输入不能为空"];
        
        return;
    }
    
    [annonArray removeAllObjects];
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    
    [dic setObject:@"resoureList" forKey:@"method"];
    [dic setObject:@"48FCADED5B7009C4AED5E5461E6888C0" forKey:@"seccode"];
    [dic setObject:type forKey:@"type"];
    [dic setObject:mykey forKey:@"key"];
    [ZKHttp Post:@"http://192.168.0.173:8888/mz_web/app/zxwinterface.do" params:dic success:^(id responseObj) {
        
            
            NSArray *array =[responseObj valueForKey:@"rows"];

            if (array.count>0) {
                
                
                [self saveArray:mykey];
                
                
                for (int i=0; i<array.count; i++) {
                    
                    NSDictionary *dic =array[i];
                    
                    Item *lists =[[Item alloc]initWithDictionary:dic anntp: type];
                    
                    [annonArray addObject:lists];
                    
                    
                }
                
                ZKrecordMapViewController *map =[[ZKrecordMapViewController alloc]initData:annonArray titis:pcName];
                [self.navigationController pushViewController:map animated:YES];

                
            }else{
            
                [self.view makeToast:@"未查到你想要的！"];
            
            }
        

        
    } failure:^(NSError *error) {
        
        [self.view makeToast:@"网络错误!"];
        
        
    }];
    
    
}
/**
 *  用文件存数组
 *
 *  @return
 */
- (void)saveArray:(NSString*)cun {
    

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (NSString*s in dataArray) {
            
            
            if ([mykey isEqualToString:s]) {
                
                return ;
            }
            
        }
        
        NSMutableArray *dc =[[NSMutableArray alloc]initWithCapacity:0];
        if (dataArray.count>0) {
            
            dc =dataArray;
        }
        
        if (cun ==nil) {
            
            
        }else{
            
            [dc addObject:cun];
            [dataArray addObject:cun];
        }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSString *sPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:type];
        
        [dc writeToFile:sPath atomically:YES];
        
        /**
         *  刷新数据
         */
        dispatch_async(dispatch_get_main_queue(), ^{

            [tabelView reloadData];
            [recordButton setTitle:@"清空搜素记录" forState:UIControlStateNormal];
       });
        
        
    });
}


#pragma mark 点击事件
/**
 *  搜素
 */
-(void)ritButton
{

    mykey = grabble.text;
    
    [self searchPost];


}
/**
 *  点击推荐
 *
 *  @param sender
 */
-(void)buyClikc:(UIButton*)sender;
{

    NSInteger p =sender.tag -1000;
    
    [annonArray removeAllObjects];
    if (list.count>0) {
        
        [annonArray addObject:list[p]];
        
        ZKrecordMapViewController *map =[[ZKrecordMapViewController alloc]initData:annonArray titis:pcName];
        [self.navigationController pushViewController:map animated:YES];
    }
    
    
}
/**
 *  清空数据
 */
-(void)recordButt
{

    if (dataArray.count>0) {
        [dataArray removeAllObjects];
        [self saveArray:nil];
        [recordButton setTitle:@"暂无搜素记录" forState:UIControlStateNormal]
        ;
    }
    
}
#pragma mark tabel 代理




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 30;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    
    return dataArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    static NSString*indefer =@"cell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:indefer];
    
    if (!cell) {
        
       cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indefer];
       cell.backgroundColor =[UIColor whiteColor];
        
        UIView *lin =[[UIView alloc]initWithFrame:CGRectMake(1, 29.5, tabelView.frame.size.width-2, 0.4)];
        lin.backgroundColor =[UIColor whiteColor];
        [cell addSubview:lin];
    }
    
    if (dataArray.count>0) {
     
        cell.textLabel.text =dataArray[indexPath.row];
        cell.textLabel.font =[UIFont systemFontOfSize:12];
        
    }


    return cell;
    
}
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tabelView deselectRowAtIndexPath:indexPath animated:YES];
    [annonArray removeAllObjects];
    if (dataArray.count>0) {

        
        mykey =dataArray[indexPath.row];
        [self searchPost];

    }
    
}



#pragma mark textfild

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    
    [grabble   resignFirstResponder];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self ritButton];
    [grabble resignFirstResponder];
    return  YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

//
//  ViewController.m
//  AhScanner
//
//  Created by ah on 2017/3/27.
//  Copyright © 2017年 ah. All rights reserved.
//

#import "ViewController.h"
#import "IDCard.h"
#import "AhIDViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *IDBackImgView;

@property (weak, nonatomic) IBOutlet UIImageView *IDFaceImgView;

@property (weak, nonatomic) IBOutlet UILabel *IDInfoLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    IDCardFacade *face = [[IDCardFacade alloc]initWithFrame:self.view.frame];
//    [self.view addSubview:face];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)IDFaceAction:(id)sender {
    
    AhIDViewController *vc = [[AhIDViewController alloc]initWithIDCardType:IDCardTypeFace];
    vc.handle = ^(IDInfo *info,IDCardType type){
        
        if (info.IDFaceSubImg!=nil) {
            
            self.IDFaceImgView.image = info.IDFaceSubImg;
        }
        
        self.IDInfoLabel.text = [NSString stringWithFormat:@"姓名:%@\n性别:%@\n名族:%@\n地址:%@\nID号:%@\n发证机关:%@\n证件有效期%@",info.name,info.gender,info.nation,info.address,info.num,info.issue,info.valid];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)IDBackAction:(id)sender {
    
    AhIDViewController *vc = [[AhIDViewController alloc]initWithIDCardType:IDCardTypeBack];
    vc.handle = ^(IDInfo *info,IDCardType type){
        
        if (info.IDBackSubImg!=nil) {
            
            self.IDBackImgView.image = info.IDBackSubImg;
        }
         self.IDInfoLabel.text = [NSString stringWithFormat:@"姓名:%@\n性别:%@\n名族:%@\n地址:%@\nID号:%@\n发证机关:%@\n证件有效期%@",info.name,info.gender,info.nation,info.address,info.num,info.issue,info.valid];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end


# AhScanner 自动识别身份证信息
##1.功能
iOS自定义照相机,实现身份证的信息自动识别,ID正面支持头像区域检测.    
Objective-C实现.

##2.类说明

IDInfo: 身份证信息 
<p><img src="http://git.oschina.net/ah1011/HeBeiHealthKit/raw/master/IDInfo.png" alt="身份证信息数据模型"> </p>
IDCard: 识别指示图层
<p><img src="http://git.oschina.net/ah1011/HeBeiHealthKit/raw/master/IDCard.png" alt="识别信息指示图层"> </p>
AhScannerManager :自定义照相机
<p><img src="http://git.oschina.net/ah1011/HeBeiHealthKit/raw/master/Manager.png" alt="自定义照相机"> </p>     
AhIDViewController: 展示识别🆔信息的控制器.    
Resoure 资源文件夹
##3.使用

调用AhIDViewController, 使用其回调句柄handle 在回传的info中获取身份证信息.

```objc
AhIDViewController *vc = [[AhIDViewController alloc]initWithIDCardType:IDCardTypeFace];
vc.handle = ^(IDInfo *info,IDCardType type){

if (info.IDFaceSubImg!=nil) {

self.IDFaceImgView.image = info.IDFaceSubImg;
}

self.IDInfoLabel.text = [NSString stringWithFormat:@"姓名:%@\n性别:%@\n名族:%@\n地址:%@\nID号:%@\n发证机关:%@\n证件有效期%@",info.name,info.gender,info.nation,info.address,info.num,info.issue,info.valid];
};
[self.navigationController pushViewController:vc animated:YES];

```










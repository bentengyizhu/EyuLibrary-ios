//
//  UIControllerExtension.m
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/10.
//

#import "UIViewExtension.h"
#import "EYBannerAdAdapter.h"

@implementation UIView(ABUBanner)

// 分类添加的属性要生成get和set方法，不会产生私有变量。
// 需要调用runtime里面的方法，进行关联对象。
// 方法一：定义静态变量，采用静态变量的地址。
// 方法二：直接使用get函数的地址

// _cmd在Objective-C的方法中表示当前方法的selector，正如同self表示当前方法调用的对象实例一样。
// 相当于函数指针，设置objc_getAssociatedObject和objc_setAssociatedObject的key都为newName函数的指针。
-(NSString *)bannerAdapter{
    return objc_getAssociatedObject(self, _cmd);
    //return objc_getAssociatedObject(self, &kAssociatedNewName);
}

-(void)setBannerAdapter:(EYBannerAdAdapter *)bannerAdapter{
    objc_setAssociatedObject(self, @selector(bannerAdapter), bannerAdapter, OBJC_ASSOCIATION_ASSIGN);
    //objc_setAssociatedObject(self, &kAssociatedNewName, newName, OBJC_ASSOCIATION_RETAIN);
}
@end

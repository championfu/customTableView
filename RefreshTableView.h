//
//  RefreshTableView.h
//  智慧工地
//
//  Created by Fuqingping on 2017/4/13.
//  Copyright © 2017年 ESCST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshBaseTableView.h"
@class RefreshTableView;
@protocol RefreshTableViewDelegate <NSObject>

- (void)refreshTableView:(RefreshTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface RefreshTableView : RefreshBaseTableView
@property (nonatomic,weak) id<RefreshTableViewDelegate>refreshDelegate;

/**
 封装的自定义tableView初始化方法

 @param url 接口地址
 @param paramters 接口传参(一般列表请求都是POST请求)
 @param cellClassName 自定义Cell的类名
 @param modelClassName model模型类名
 @param cellModelName model在Cell中的属性名
 @return table
 */
- (instancetype)initWithRequestUrl:(NSString *)url paramters:(NSMutableDictionary *)paramters cellClassName:(NSString *)cellClassName modelClassName:(NSString *)modelClassName cellModelName:(NSString *)cellModelName;


@end

//
//  WeiboModel.m
//  XSWeibo
//
//  Created by mac on 15/9/10.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboModel.h"
#import "RegexKitLite.h"

@implementation WeiboModel

- (NSDictionary *)attributeMapDictionary
{
    //   @"属性名": @"数据字典的key"
    NSDictionary *mapAtt = @{
                             @"createDate":@"created_at",
                             @"weiboId":@"id",
                             @"weiboIdStr":@"id",
                             @"text":@"text",
                             @"source":@"source",
                             @"favorited":@"favorited",
                             @"thumbnailImage":@"thumbnail_pic",
                             @"bmiddlelImage":@"bmiddle_pic",
                             @"originalImage":@"original_pic",
                             @"geo":@"geo",
                             @"repostsCount":@"reposts_count",
                             @"commentsCount":@"comments_count",
                             @"weiboIdStr":@"idstr"
                             };
    return mapAtt;
}

- (void)setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    
    NSDictionary *reWeioDic = dataDic[@"retweeted_status"];
    if (reWeioDic != nil) {
        _reWeiboModel = [[WeiboModel alloc] initWithDataDic:reWeioDic];
    }
    NSDictionary *userDic = dataDic[@"user"];
    if (userDic != nil) {
        _userModel = [[UserModel alloc] initWithDataDic:userDic];
    }
    
    //设置表情
    NSString *regex = @"\\[\\w+\\]";
    NSArray *faceAry = [self.text componentsMatchedByRegex:regex];
    //获取表情包pilst文件
    NSString *facePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *allFaceBundleAry = [NSArray arrayWithContentsOfFile:facePath];

    //遍历数组修改微博表情内容  [心] －－》<image url = '心.png'>
    for (NSString *faceName in faceAry) {
//        NSLog(@"%@",faceName);
        NSString *predictStr = [NSString stringWithFormat:@"self.chs='%@'",faceName];
        NSPredicate *predict = [NSPredicate predicateWithFormat:predictStr];
        NSArray *items = [allFaceBundleAry filteredArrayUsingPredicate:predict];
        if (items.count > 0) {
            NSDictionary *itemsDic = [items lastObject];
            NSString *imageName = [NSString stringWithFormat:@"<image url = '%@'>",itemsDic[@"png"]];
            self.text = [self.text stringByReplacingOccurrencesOfString:faceName withString:imageName];
        }
    }
    
    
}

@end

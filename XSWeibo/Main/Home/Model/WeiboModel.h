//
//  WeiboModel.h
//  XSWeibo
//
//  Created by mac on 15/9/10.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseModel.h"
#import "UserModel.h"


@interface WeiboModel : BaseModel


@property (nonatomic,copy) NSString       *createDate;       //微博创建时间
@property (nonatomic,retain) NSNumber     *weiboId;           //微博ID
@property (nonatomic,copy) NSString       *weiboIdStr;      //微博ID字符串
@property (nonatomic,copy) NSString       *text;              //微博的内容
@property (nonatomic,copy) NSString       *source;              //微博来源
@property (nonatomic,retain) NSNumber     *favorited;         //是否已收藏
@property (nonatomic,copy) NSString       *thumbnailImage;     //缩略图片地址
@property (nonatomic,copy) NSString       *bmiddlelImage;     //中等尺寸图片地址
@property (nonatomic,copy) NSString       *originalImage;     //原始图片地址
@property (nonatomic,retain) NSDictionary *geo;               //地理信息字段
@property (nonatomic,retain) NSNumber     *repostsCount;      //转发数
@property (nonatomic,retain) NSNumber     *commentsCount;      //评论数


@property (nonatomic, strong) WeiboModel *reWeiboModel;        //转发微博信息
@property (nonatomic, strong) UserModel *userModel;            //用户信息

@end

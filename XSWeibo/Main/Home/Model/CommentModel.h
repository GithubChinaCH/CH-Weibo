//
//  CommentModel.h
//  XSWeibo
//
//  Created by mac on 15/9/22.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

/*
 created_at	string	评论创建时间
 id	int64	评论的ID
 text	string	评论的内容
 source	string	评论的来源
 user	object	评论作者的用户信息字段 详细
 mid	string	评论的MID
 idstr	string	字符串型的评论ID
 status	object	评论的微博信息字段 详细
 reply_comment	object	评论来源评论，当本评论属于对另一评论的回复时返回此字段
 */

#import "BaseModel.h"
#import "UserModel.h"

@interface CommentModel : BaseModel

@property(nonatomic, copy) NSString *created_at;  //评论创建时间
@property(nonatomic, copy) NSString *text;        //评论的内容
@property(nonatomic, copy) NSString *source;      //评论的来源
@property(nonatomic, copy) NSString *mid;         //评论的MID
@property(nonatomic, copy) NSString *idstr;       //字符串型的评论ID
@property(nonatomic, strong) UserModel *user;     //评论的内容
@property(nonatomic, strong) CommentModel *reply_comment; //评论来源评论，当本评论属于对另一评论的回复时返回此字段



@end

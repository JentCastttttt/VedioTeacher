//
//  VerifyLoginReqBody.h
//  Hey!XuanWu
//
//  Created by Cao JianRong on 14-3-5.
//  Copyright (c) 2014年 Cao JianRong. All rights reserved.
//

#import "ReqBody.h"

@interface VerifyLoginReqBody : ReqBody
{
    NSString *name;
    NSString *password;
}
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *password;
@end

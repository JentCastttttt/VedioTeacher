//
//  GetTVInfoReqBody.h
//  VedioTeacher
//
//  Created by Cao JianRong on 14-7-7.
//  Copyright (c) 2014年 Cao JianRong. All rights reserved.
//

#import "ReqBody.h"

@interface GetTVInfoReqBody : ReqBody
{
    NSString *idTV;
}
@property (nonatomic, retain) NSString *idTV;
@end

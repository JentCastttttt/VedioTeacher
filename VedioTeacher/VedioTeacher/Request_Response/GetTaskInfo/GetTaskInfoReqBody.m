//
//  GetTaskInfoReqBody.m
//  VedioTeacher
//
//  Created by Cao JianRong on 14-7-7.
//  Copyright (c) 2014年 Cao JianRong. All rights reserved.
//

#import "GetTaskInfoReqBody.h"

@implementation GetTaskInfoReqBody
@synthesize taskid;

-(void) dealloc
{
    [taskid release];
    [super dealloc];
}
@end

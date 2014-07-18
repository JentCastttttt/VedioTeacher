//
//  SendTaskViewController.m
//  VedioTeacher
//
//  Created by Cao JianRong on 14-7-16.
//  Copyright (c) 2014年 Cao JianRong. All rights reserved.
//

#import "SendTaskViewController.h"

@interface SendTaskViewController ()

@end

@implementation SendTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    NSLog(@"%@",[DataCenter shareInstance].taskDirId);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    didSection = 0;
    showTask = @"1";
    dateArray = [[NSMutableArray alloc] initWithObjects:@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020", nil];;
    taskArray = [[NSMutableArray alloc] init];
    acceptArray = [[NSMutableArray alloc] init];
    accountArray = [[NSMutableArray alloc] init];
    
    [self createInitView];
    
    [self getAccountList:[DataCenter shareInstance].loginId];
    
}

//显示我发布的任务
-(void) sendedTask:(id)sender
{
    showTask = @"1";
    [titleRect setHidden:NO];
    taskTitleField.text = @"";
    taskInfoView.text = @"";
    taskAccountName.text = @"";
    [taskAccount setHidden:YES];
    [taskAccountName setHidden:YES];
    taskInfoView.layer.borderWidth = 1.0;
    [sendedView setHidden:NO];
}

//显示我接受的任务
-(void) acceptedNewTask:(id)sender
{
    showTask = @"2";
    [titleRect setHidden:YES];
    taskTitleField.text = @"";
    taskInfoView.text = @"";
    taskAccountName.text = @"";
    [taskAccount setHidden:NO];
    [taskAccountName setHidden:NO];
    taskInfoView.layer.borderWidth = 0.0;
    [sendedView setHidden:NO];
    
}

//显示我发布的视频
-(void) sendedVideo:(id)sender
{
    [sendedView setHidden:YES];
}

-(void) submitTask:(id)sender
{
    
}

#pragma mark ----------------------------------------
#pragma mark UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section <= 6) {
        return didSection - section ? 0 : 1;
    }
    if ([showTask isEqualToString:@"1"]) {
        return 100;//[taskArray count];
    }
    return [acceptArray count];
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section > 6) {
        return nil;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:[NSString stringWithFormat:@"%@年",[dateArray objectAtIndex:section]] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 205, 25.0f);
    button.tag = section+500;
    [button addTarget:self action:@selector(sectionHeaderDidSelectAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor getColor:@"E4E4E4"]];
    if (didSection == section) {
        [button setBackgroundColor:[UIColor getColor:@"6ABAFA"]];
    }
    
    UIImageView *hor = [[UIImageView alloc] initWithFrame:CGRectMake(0, 24.5, 205, 0.5)];
    hor.alpha = 0.5;
    hor.backgroundColor = [UIColor lightGrayColor];
    [button addSubview:hor];
    [hor release];
    
    return button;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section <= 6 ? [NSString stringWithFormat:@"%@年",[dateArray objectAtIndex:section]] : nil;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section <= 6 ? 25.0f : 0.0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section <= 6 ? 80.0f : 30.0f;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section <= 6) {
        static NSString *identifier = @"date";
        DateShowCell *cell = (DateShowCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[DateShowCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
        }
        cell.delegate = self;
        [cell clearClicked];
        return cell;
    }
    static NSString *identifier = @"task";
    TaskCell *cell = (TaskCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[TaskCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
    }
    cell.taskName.text = @"123456";
    return cell;
}

-(void) sectionHeaderDidSelectAtIndex:(id) sender
{
    NSInteger section = [sender tag] - 500;
    didSection = section;
    [sendTable reloadData];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d-%d",indexPath.section,indexPath.row);
}

-(void) mouthClickAtIndex:(id)sender
{
    NSLog(@"%@",[[sender currentTitle] stringByReplacingOccurrencesOfString:@"月" withString:@""]);
    
    if ([startTime hasSuffix:[NSString stringWithFormat:@"%d",[sender tag]]]) {
        if ([startTime hasPrefix:[dateArray objectAtIndex:didSection]]) {
            return ;
        }
    }
    
    startTime = [NSString stringWithFormat:@""];
    endTime = [NSString stringWithFormat:@""];
    if ([showTask isEqualToString:@"1"]) {
        [self getMySendedTask:[DataCenter shareInstance].loginId startTime:startTime endTime:endTime];
    } else {
        [self getMyAcceptTask:[DataCenter shareInstance].loginId startTime:startTime endTime:endTime];
    }
    
    
}

-(BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, -260, 1024, 768);
    }];
    return YES;
}

-(BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, 0, 1024, 768);
    }];
    return YES;
}

/*!
 *  获取所有用户列表
 *
 *  @param account 用户ID
 */
-(void) getAccountList:(NSString *)account
{
    GetAccountListReqBody *reqBody = [[GetAccountListReqBody alloc] init];
    NSMutableURLRequest *request = [[AFHttpRequestUtils shareInstance] requestWithBody:reqBody andReqType:GET_ACCOUNTLIST];
    [reqBody release];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        GetAccountListRespBody *respBody = (GetAccountListRespBody *)[[AFHttpRequestUtils shareInstance] jsonConvertObject:(NSData *)responseObject withReqType:GET_ACCOUNTLIST];
        [self checkAccountList:respBody];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error : %@", [error localizedDescription]);
        alertMessage(@"请求失败，获取用户列表失败.");
    }];
    
    [operation start];
    [operation release];
}

-(void) checkAccountList:(GetAccountListRespBody *) response
{
    if ([response.accountListResult count] == 0) {
        alertMessage(@"请求出错，请重新获取");
        return ;
    }
    [[userScroll subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [userScroll setContentSize:CGSizeMake(204, sendedView.frame.size.height)];
    [accountArray removeAllObjects];
    for (AccountModel *model in response.accountListResult) {
        [accountArray addObject:model];
    }

    for (int i = 0; i < [accountArray count]; i++) {
//        AccountModel *model = accountArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10 + 97*(i%2), 10 + 40*(i/2), 87, 30);
        button.tag = 2000+i;
        [button.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [button setTitle:@"userName" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"preview_like_icon"] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseAccount:) forControlEvents:UIControlEventTouchUpInside];
        [userScroll addSubview:button];
    }
    [userScroll setContentSize:CGSizeMake(204, 15 + ceilf([accountArray count]/2.0))];
}

-(void) chooseAccount:(id) sender
{
    [sender setSelected:![sender isSelected]];
}

/*!
 *  获取我发布的任务
 *
 *  @param account 用户ID
 *  @param start   开始时间
 *  @param end     结束时间
 */
-(void) getMySendedTask:(NSString *)account startTime:(NSString *)start endTime:(NSString *)end
{
    GetMySendTaskListReqBody *reqBody = [[GetMySendTaskListReqBody alloc] init];
    reqBody.accountId = account;
    reqBody.startTime = start;
    reqBody.endTime = end;
    NSMutableURLRequest *request = [[AFHttpRequestUtils shareInstance] requestWithBody:reqBody andReqType:GET_MYSENDTASKLIST];
    [reqBody release];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        GetMySendTaskListRespBody *respBody = (GetMySendTaskListRespBody *)[[AFHttpRequestUtils shareInstance] jsonConvertObject:(NSData *)responseObject withReqType:GET_MYSENDTASKLIST];
        [self checkSendTaskList:respBody];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error : %@", [error localizedDescription]);
        alertMessage(@"请求失败，获取用户列表失败.");
    }];
    
    [operation start];
    [operation release];
}

-(void) checkSendTaskList:(GetMySendTaskListRespBody *) response
{
    
}

/*!
 *  获取我接受的任务
 *
 *  @param account 用户ID
 *  @param start   开始时间
 *  @param end     结束时间
 */
-(void) getMyAcceptTask:(NSString *)account startTime:(NSString *)start endTime:(NSString *)end
{
    GetMyAcceptTaskListReqBody *reqBody = [[GetMyAcceptTaskListReqBody alloc] init];
    reqBody.accountId = account;
    reqBody.startTime = start;
    reqBody.endTime = end;
    NSMutableURLRequest *request = [[AFHttpRequestUtils shareInstance] requestWithBody:reqBody andReqType:GET_MYACCEPTTASKLIST];
    [reqBody release];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        GetMyAcceptTaskListRespBody *respBody = (GetMyAcceptTaskListRespBody *)[[AFHttpRequestUtils shareInstance] jsonConvertObject:(NSData *)responseObject withReqType:GET_MYACCEPTTASKLIST];
        [self checkAccpetTaskList:respBody];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error : %@", [error localizedDescription]);
        alertMessage(@"请求失败，获取用户列表失败.");
    }];
    
    [operation start];
    [operation release];
}

-(void) checkAccpetTaskList:(GetMyAcceptTaskListRespBody *) response
{
    
}

/*!
 *  获取任务信息
 *
 *  @param taskid 任务ID
 */
-(void) getTaskInfo:(NSString *)taskid
{
    GetTaskInfoReqBody *reqBody = [[GetTaskInfoReqBody alloc] init];
    reqBody.taskid = taskid;
    NSMutableURLRequest *request = [[AFHttpRequestUtils shareInstance] requestWithBody:reqBody andReqType:GET_TASKINFO];
    [reqBody release];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        GetTaskInfoRespBody *respBody = (GetTaskInfoRespBody *)[[AFHttpRequestUtils shareInstance] jsonConvertObject:(NSData *)responseObject withReqType:GET_TASKINFO];
        [self checkTaskInfo:respBody];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error : %@", [error localizedDescription]);
        alertMessage(@"请求失败，获取用户列表失败.");
    }];
    
    [operation start];
    [operation release];
}

-(void) checkTaskInfo:(GetTaskInfoRespBody *) response
{
    
}

/*!
 *  获取我发布的视频
 *
 *  @param accound 用户ID
 *  @param byTime  是否根据时间来排序   YES:时间倒序  NO:点赞数倒序
 */
-(void) getMyTV:(NSString *) accound withTime:(BOOL)byTime
{
    if (byTime) {
        GetMyTVListOfTimeReqBody *reqBody = [[GetMyTVListOfTimeReqBody alloc] init];
        reqBody.accountId = [DataCenter shareInstance].loginId;
        NSMutableURLRequest *request = [[AFHttpRequestUtils shareInstance] requestWithBody:reqBody andReqType:GET_MYTVLIST_TIME];
        [reqBody release];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            GetMyTVListOfTimeRespBody *respBody = (GetMyTVListOfTimeRespBody *)[[AFHttpRequestUtils shareInstance] jsonConvertObject:(NSData *)responseObject withReqType:GET_MYTVLIST_TIME];
            [self checkTVList:respBody];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error : %@", [error localizedDescription]);
            alertMessage(@"请求失败，获取用户列表失败.");
        }];
        
        [operation start];
        [operation release];
    } else {
        GetMyTVListOfGoodCountReqBody *reqBody = [[GetMyTVListOfGoodCountReqBody alloc] init];
        reqBody.accountId = [DataCenter shareInstance].loginId;
        NSMutableURLRequest *request = [[AFHttpRequestUtils shareInstance] requestWithBody:reqBody andReqType:GET_MYTVLIST_GOODCOUNT];
        [reqBody release];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            GetMyTVListOfGoodCountRespBody *respBody = (GetMyTVListOfGoodCountRespBody *)[[AFHttpRequestUtils shareInstance] jsonConvertObject:(NSData *)responseObject withReqType:GET_MYTVLIST_GOODCOUNT];
            [self checkTVList:respBody];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error : %@", [error localizedDescription]);
            alertMessage(@"请求失败，获取用户列表失败.");
        }];
        
        [operation start];
        [operation release];
    }
}

-(void) checkTVList:(id) response
{
    
}

-(void) createInitView
{
//--------------------------------------------------------
//---------- 个人中心头部界面/高度为300  ---------------------
//--------------------------------------------------------
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 300)];
    headerView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:headerView];
    [headerView release];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 260)];
    [bgView setBackgroundColor:[UIColor grayColor]];
    [headerView addSubview:bgView];
    [bgView release];
    
    UIButton *sendTask = [UIButton buttonWithType:UIButtonTypeCustom];
    sendTask.frame = CGRectMake(15, headerView.frame.size.height - 35, 90, 30);
    sendTask.layer.cornerRadius = 3.0;
    [sendTask setTitle:@"我发布的任务" forState:UIControlStateNormal];
    [sendTask setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendTask.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [sendTask addTarget:self action:@selector(sendedTask:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sendTask];
    
    UIButton *newTask = [UIButton buttonWithType:UIButtonTypeCustom];
    newTask.frame = CGRectMake(sendTask.frame.size.width + sendTask.frame.origin.x + 10, headerView.frame.size.height - 35, 90, 30);
    newTask.layer.cornerRadius = 3.0;
    [newTask setTitle:@"我的任务" forState:UIControlStateNormal];
    [newTask setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newTask.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [newTask addTarget:self action:@selector(acceptedNewTask:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:newTask];
    
    UIButton *sendVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    sendVideo.frame = CGRectMake(newTask.frame.size.width + newTask.frame.origin.x + 10, headerView.frame.size.height - 35, 90, 30);
    sendVideo.layer.cornerRadius = 3.0;
    [sendVideo setTitle:@"我的视频" forState:UIControlStateNormal];
    [sendVideo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendVideo.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [sendVideo addTarget:self action:@selector(sendedVideo:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sendVideo];
    
    submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = CGRectMake(headerView.frame.size.width - 105, headerView.frame.size.height - 35, 90, 30);
    submit.layer.cornerRadius = 3.0;
    [submit setTitle:@"立即发布任务" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [submit addTarget:self action:@selector(submitTask:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:submit];
    
    userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    userIcon.layer.cornerRadius = userIcon.frame.size.height/2.0f;
    userIcon.clipsToBounds = YES;
    userIcon.layer.borderWidth = 2.0;
    userIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    [userIcon setImage:[UIImage imageNamed:@"take_photo"]];
    userIcon.center = CGPointMake(headerView.frame.size.width/2.0f - 60, headerView.frame.size.height/2.0f - 30);
    [headerView addSubview:userIcon];
    [userIcon release];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userIcon.frame.size.width + userIcon.frame.origin.x + 10, userIcon.frame.origin.y + 20, 200, 20)];
    nameLabel.text = @"未登录";
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:17.0f];
    [headerView addSubview:nameLabel];
    [nameLabel release];
    
//-------------------------------------------------------
//---------- 三块位置占比 215:615:215 ---------------------
//-------------------------------------------------------
    sendedView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height, 1024, 710 - headerView.frame.size.height)];
    sendedView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sendedView];
    [sendedView release];
    
    sendTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 205, sendedView.frame.size.height) style:UITableViewStylePlain];
    sendTable.showsVerticalScrollIndicator = NO;
    sendTable.backgroundColor = [UIColor getColor:@"E4E4E4"];
    sendTable.delegate = self;
    sendTable.dataSource = self;
    sendTable.separatorInset = UIEdgeInsetsZero;
    sendTable.separatorColor = [UIColor clearColor];
    [sendedView addSubview:sendTable];
    [sendTable release];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(sendTable.frame.size.width + 50, 30, 100, 20)];
    name.text = @"任务名称:";
    name.textAlignment = NSTextAlignmentRight;
    name.textColor = [UIColor blackColor];
    name.backgroundColor = [UIColor clearColor];
    name.font = [UIFont systemFontOfSize:15.0f];
    [sendedView addSubview:name];
    [name release];
    
    titleRect = [[UIImageView alloc] initWithFrame:CGRectMake(name.frame.origin.x + name.frame.size.width + 15, name.frame.origin.y - 5, 250, 30)];
    titleRect.layer.borderWidth = 1.0;
    titleRect.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [sendedView addSubview:titleRect];
    [titleRect release];
    
    taskTitleField = [[UITextField alloc] initWithFrame:CGRectMake(name.frame.origin.x + name.frame.size.width + 19, name.frame.origin.y - 5, 242, 30)];
    taskTitleField.text = @"任务每次名称";
    [taskTitleField setFont:[UIFont systemFontOfSize:15.0f]];
    taskTitleField.borderStyle = UITextBorderStyleNone;
    [sendedView addSubview:taskTitleField];
    [taskTitleField release];
    
    taskAccount = [[UILabel alloc] initWithFrame:CGRectMake(sendTable.frame.size.width + 50, name.frame.origin.y + name.frame.size.height + 20, 100, 20)];
    [taskAccount setHidden:YES];
    taskAccount.text = @"任务发布者:";
    taskAccount.textAlignment = NSTextAlignmentRight;
    taskAccount.textColor = [UIColor blackColor];
    taskAccount.backgroundColor = [UIColor clearColor];
    taskAccount.font = [UIFont systemFontOfSize:15.0f];
    [sendedView addSubview:taskAccount];
    [taskAccount release];
    
    taskAccountName = [[UILabel alloc] initWithFrame:CGRectMake(taskAccount.frame.origin.x + taskAccount.frame.size.width + 15, taskAccount.frame.origin.y, 100, 20)];
    [taskAccountName setHidden:YES];
    taskAccountName.text = @"任务发布者";
    taskAccountName.textColor = [UIColor blackColor];
    taskAccountName.backgroundColor = [UIColor clearColor];
    taskAccountName.font = [UIFont systemFontOfSize:15.0f];
    [sendedView addSubview:taskAccountName];
    [taskAccountName release];
    
    taskInfo = [[UILabel alloc] initWithFrame:CGRectMake(sendTable.frame.size.width + 50, taskAccount.frame.origin.y + taskAccount.frame.size.height + 20, 100, 20)];
    taskInfo.text = @"任务脚本内容:";
    taskInfo.textAlignment = NSTextAlignmentRight;
    taskInfo.textColor = [UIColor blackColor];
    taskInfo.backgroundColor = [UIColor clearColor];
    taskInfo.font = [UIFont systemFontOfSize:15.0f];
    [sendedView addSubview:taskInfo];
    [taskInfo release];
    
    taskInfoView = [[UITextView alloc] initWithFrame:CGRectMake(taskInfo.frame.origin.x + taskInfo.frame.size.width + 15, taskInfo.frame.origin.y - 8, 400, 200)];
    taskInfoView.text = @"任务脚本内容任务";
    taskInfoView.delegate = self;
    taskInfoView.layer.borderWidth = 1.0;
    taskInfoView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [taskInfoView setFont:[UIFont systemFontOfSize:15.0]];
    [sendedView addSubview:taskInfoView];
    [taskInfoView release];
    
    userScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(1024 - 204, 0, 204, sendedView.frame.size.height)];
    userScroll.backgroundColor = [UIColor getColor:@"E4E4E4"];
    [sendedView addSubview:userScroll];
    [userScroll release];
    
    sendTask.backgroundColor = [UIColor brownColor];
    newTask.backgroundColor = [UIColor brownColor];
    sendVideo.backgroundColor = [UIColor brownColor];
    submit.backgroundColor = [UIColor brownColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc
{
    [accountArray release];
    [dateArray release];
    [taskArray release];
    [accountArray release];
    [super dealloc];
}

@end

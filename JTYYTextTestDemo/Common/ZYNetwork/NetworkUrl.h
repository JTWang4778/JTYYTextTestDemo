//
//  NetworkUrl.h
//  EHuaTuFramework
//
//  Created by JW on 2018/9/30.
//

#ifndef NetworkUrl_h
#define NetworkUrl_h

#pragma mark -  Network
static NSString * const NetworkHost = @"http://test-px.huatu.com/";
#define Host_text(path) [NSString stringWithFormat:@"%@%@",NetworkHost,path]
//接口相关
#define Host_Append(path) [NSString stringWithFormat:@"%@%@",[EHTTrainManager sharedInstance].baseUrl,path]

#define kBaseUrl @"http://jk-test.htznbm.com/api/"
#define Especial_Append(path) [NSString stringWithFormat:@"%@%@",kBaseUrl,path]
// 用户对接 接口
static NSString * const ELearnEntrance = @"api/app/getAppToken";



//首页接口
static NSString * const HomeDataList = @"api/app/home";

//我的课程列表
static NSString * const MyCourseList = @"api/app/course/myCourse/type={type}";

//课程列表
static NSString * const OnlineCourseList = @"api/app/courseBasis";

//课程详情
static NSString * const CourseDetails = @"api/app/courseInfo/basis_id={basis_id}/st={st}";

//加入学习 api/app/course/study/basis_id={basis_id}
static NSString * const JoinLearning = @"api/app/course/study/basis_id={basis_id}";

//课程分类列表
static NSString * const CourseClassify = @"api/app/courseClassify/1";

//请求视频播放权限
static NSString * const VideoToken = @"api/app/course/getPlayToken/video_id={video_id}";
//添加播放时长
static NSString * const VideoUpdate = @"api/app/setWatchChapter";


//线下培训列表
static NSString * const OfflineTrainingList = @"api/app/course/offlineTraining/st={st}";

//线下培训详情
static NSString * const OfflineTrainingDetail = @"api/app/courseInfo/basis_id={basis_id}/st={st}";

//我的任务列表
static NSString * const MyTaskList = @"api/app/task/index";

//任务详情
static NSString * const MyTaskDetail = @"api/app/task/index/id={id}";


//我的培训列表
static NSString * const MyTrainingList = @"api/app/course/myOfflineTraining/type={type}";


//课程评论列表
//static NSString * const Commentlist = @"api/app/commentlist?comment_shop_id={comment_shop_id}/page={page}";
static NSString * const Commentlist = @"api/app/commentlist";

//添加评论
static NSString * const SubmitComment = @"api/app/comment";



//用户个人信息
static NSString * const UserAccountInfo = @"api/app/webuser/index/id={id}";

//我的消息
static NSString * const UserMessage = @"api/app/message";

//标记消息为已读  api/app/signread
static NSString * const ReadOneMessage = @"api/app/signread";

// 查询当前用户消息
static NSString * const QueryUserMsgCount = @"api/app/user_message_count";



//请求调查问卷
static NSString * const Questionnaire = @"api/app/courseChapter/id={id}";

//提交调查问卷
static NSString * const SubmitQuestionnaire = @"api/app/questionnaire";

//我的积分
static NSString * const MyIntegral = @"api/app/webuser/integral/id={id}";

//积分纪录
static NSString * const IntegralRecord = @"api/app/webuser/integral_details/id={id}";

//积分排行榜
static NSString * const IntegralRank = @"api/app/user/ranking/id={id}";

//员工反馈
static NSString * const UserFeedback = @"api/app/user/feedback";


#pragma mark -  社区相关
//小组列表
static NSString * const CommunityGroup = @"api/app/discuss/getMoreGroup";

//小组详情 api/app/discuss/group/group_id=1?st=1
static NSString * const GroupDetailInfo = @"api/app/discuss/group/group_id={group_id}?st={st}";

//小组详情内话题列表
static NSString * const GroupTopicList = @"api/app/discuss/getQuestion/type={type}?group_id={group_id}";

//帖子 评论  搜索
static NSString * const Search = @"api/app/discuss/search/type=1";

// 搜索评论
static NSString * const SearchComment = @"api/app/discuss/search/type=2";

// 是否被禁言
static NSString * const IsBanned = @"api/app/discuss/isBanned";

//http://www.htnx.test/429

//帖子评论列表
static NSString * const PostDetailsAppCommentList = @"api/app/discuss/appComment/question_id={question_id}?st={st}";

//评论详情
static NSString * const appCommentInfo = @"api/app/discuss/appCommentInfo/comment_id={comment_id}";

//评论详情子评论列表
static NSString * const appCommentSonInfo = @"api/app/discuss/appCommentSonInfo/comment_id={comment_id}";
//修改话题的类型
static NSString * const PostEditQuestionType = @"api/app/discuss/editQuestionType";


//帖子详情 没有用此接口
static NSString * const PostDetails = @"api/app/discuss/question/question_id={question_id}?st={st}";

//帖子详情 删除帖子
static NSString * const DelQuestion = @"api/app/discuss/delQuestion";

//帖子详情 删除评论
static NSString * const DelComment = @"api/app/discuss/delComment";


//帖子详情评论列表
static NSString * const PostCommentList = @"api/app/discuss/comment/question_id={question_id}?st={st}";

//帖子添加评论
static NSString * const AddPostComment = @"api/app/discuss/createComment";
//点赞
static NSString * const QuestionLike = @"api/app/discuss/questionLike/question_id={question_id}";

//点赞 评论
static NSString * const CommentLike = @"api/app/discuss/commentLike/comment_id={comment_id}";
//采纳 评论
static NSString * const CommentAdopt = @"api/app/discuss/comment/comment_id={comment_id}";


//社区帖子列表
static NSString * const CommunityPostList = @"api/app/discuss/getQuestion/type={type}";

// 加入退出小组 
static NSString * const JoinUserGroup = @"api/app/discuss/userGroup";

//我的小组
static NSString * const UserGroupList = @"api/app/discuss/myGroup";

//我的参与
static NSString * const UserJoinList = @"api/app/discuss/myPart";

///发布话题
static NSString * const EHTCreateQuestion = @"api/app/discuss/createQuestion";

///编辑话题
static NSString * const EHTEditQuestion = @"api/app/discuss/editQuestion";

///图片上传
static NSString * const EHTUploadImage = @"api/app/public/images";



//我的证书
static NSString * const MyCertificate = @"api/app/MyCertificate";


//文库分类
static NSString * const EHTLibraryType = @"api/app/library/classify";

//文库列表
static NSString * const EHTLibraryList = @"api/app/library";

//文库详情
static NSString * const EHTLibraryInfo = @"api/app/libraryInfo/library_id={library_id}";

//文库收藏
static NSString * const LibraryCollection = @"api/app/librarycollection";

//我的文库
static NSString * const Mylibrarylist = @"api/app/mylibrarylist";


//资讯分类
static NSString * const InformationType = @"api/app/informationType";

//资讯列表
static NSString * const EHTInformationList = @"api/app/information";



//获取试卷试题
static NSString * const PaperQuestion = @"api/app/paper_question";
//获取问卷试题
static NSString * const NaireQuestion = @"api/app/question_naire";
//提交答案
static NSString * const UploadQuestions = @"api/app/question/submit";

//试卷报告
static NSString * const PaperReport = @"api/app/question/report/id={id}";

//试卷解析
static NSString * const PaperAnalysis = @"api/app/question/analysis/id={id}";

//错题解析
static NSString * const ErrorAnalysis = @"api/app/question/error_analysis/id={id}";

//问卷报告
static NSString * const QuestionnaireReport = @"api/app/question/ques_naire_report/id={id}";

// 线下签到
static NSString * const EHTAttendance = @"api/app/attendance/basis_id={basis_id}/chapter_id={chapter_id}";

#pragma mark - 广告页
static NSString * const Advist = @"api/app/discuss/getBanner";


#endif /* NetworkUrl_h */

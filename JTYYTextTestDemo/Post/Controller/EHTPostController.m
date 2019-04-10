//
//  EHTPostController.m
//  EHuaTuFramework
//
//  Created by wangjintao on 2019/4/2.
//  Copyright © 2019年 ZhiYun. All rights reserved.
//

#import "EHTPostController.h"
#import "YYText.h"
#import "EHTPostToolView.h"
#import "JTEmojiKeyboardView.h"
#import "JTEmojiModel.h"
#import "EHTSelectImageManager.h"
#import "ZYNetworking.h"
#import "JTHyberLinkLabel.h"
#import "CommunityPublishInpugHyperlinksView.h"

@interface EHTPostController ()<EHTPostToolViewDelegate, YYTextViewDelegate>
{
    CGFloat ToolBarHeight;
    CGFloat EmojiKeyboardHeight;
    NSInteger OnePageEmojiCount;
    BOOL isEmojiKeyboard;
    BOOL isYYTextEditing;
}
@property (nonatomic,weak)UITextField *textField;
@property (nonatomic,strong)NSDictionary *emojiMapDict;
@property (nonatomic,weak)YYTextView *textView;

@property (nonatomic,strong)EHTPostToolView *toolView;

@property (nonatomic,strong)JTEmojiKeyboardView *emojiKeyboard;

@property (nonatomic,strong)NSArray <JTEmojiModel *> * emojiModelArr;
@property (nonatomic,strong)NSArray <JTEmojiModel *> * tutuModelArr;


@end

@implementation EHTPostController

- (void)viewDidLoad {
    [super viewDidLoad];
    ToolBarHeight = 45;
    OnePageEmojiCount = 27;
    EmojiKeyboardHeight = 218 + BottomSafeHeight;
    // 加载plist表情包 准备数据
    [self loadEmojiInfo];
    [self loadTutuGifInfo];
    [self setupViews];
    [self addObserver];
}

- (void)loadTutuGifInfo{
    /// 加载兔兔表情包和数据准备可以异步操作
    NSString *tutuPath = [[NSBundle mainBundle] pathForResource:@"TutuEmoji"ofType:@"bundle"];
    NSBundle *tutuBundle = [NSBundle bundleWithPath:tutuPath];
    NSString *plistPath = [tutuBundle pathForResource:@"TutuEmojiInfo" ofType:@"plist"];
    NSArray <NSDictionary *> *tutuInfoArr = [[NSArray alloc] initWithContentsOfFile:plistPath];
    NSMutableArray *mutableArr = [NSMutableArray array];
    [tutuInfoArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JTEmojiModel *model = [[JTEmojiModel alloc] init];
        model.code = obj[@"code"];
        model.imageName = obj[@"fileName"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TutuEmoji" ofType:@"bundle"];
        NSBundle *tutuBundle = [NSBundle bundleWithPath:path];
        NSString *gifPath = [tutuBundle pathForResource:model.imageName ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:gifPath];
        YYImage *image = [YYImage imageWithData:data scale:2];
        image.code = model.code;
        model.gifImage = image;
        [mutableArr addObject:model];
    }];
    self.tutuModelArr = mutableArr;
}
- (void)loadEmojiInfo{
    NSString *emojiPath = [[NSBundle mainBundle] pathForResource:@"EmoticonQQ"ofType:@"bundle"];
    NSBundle *emojiBundle = [NSBundle bundleWithPath:emojiPath];
    NSString *plistPath = [emojiBundle pathForResource:@"info" ofType:@"plist"];
    NSArray <NSDictionary *> *emojiInfoArr = [[NSArray alloc] initWithContentsOfFile:plistPath];
    NSMutableArray *mutableArr = [NSMutableArray array];
    
    NSInteger pageCount;
    if (emojiInfoArr.count % OnePageEmojiCount == 0) {
        pageCount = emojiInfoArr.count / OnePageEmojiCount;
    }else{
        pageCount = emojiInfoArr.count / OnePageEmojiCount + 1;
    }
    
    NSMutableDictionary *mapDict = [NSMutableDictionary dictionary];
    NSInteger emojiIndex = 0;
    for (int i = 0; i < pageCount * OnePageEmojiCount; i++) {
        
        JTEmojiModel *model = [[JTEmojiModel alloc] init];
        if (emojiIndex < emojiInfoArr.count) {
            // 还有表情
            if (((i + 1) % OnePageEmojiCount) == 0) {
                // 插入删除
                model.type = JTEmojiTypeDelete;
                model.imageName = @"shachu";
            }else{
                // 插入表情
                NSDictionary *infoDict = emojiInfoArr[emojiIndex];
                model.type = JTEmojiTypeEmoji;
                NSString *key = infoDict.allKeys.firstObject;
                NSString *imageName = infoDict.allValues.firstObject;
                model.code = key;
                model.imageName = imageName;
                UIImage *image = [UIImage imageNamed:imageName];
                model.iamge = image;
                [mapDict setValue:image forKey:model.code];
                emojiIndex++;
            }
        }else{
            // 没有了表情。插入空白和删除
            if ((i + 1) % OnePageEmojiCount == 0) {
                // 插入删除
                model.type = JTEmojiTypeDelete;
                model.imageName = @"shachu";
            }else{
                // 插入空白
                model.type = JTEmojiTypeBlankSpace;
                model.imageName = nil;
            }
        }
        model.page = (i / OnePageEmojiCount);
        model.pageIndex = (i % OnePageEmojiCount);
        [mutableArr addObject:model];
        
    }
    self.emojiMapDict = mapDict;
    self.emojiModelArr = mutableArr;
    
}

- (void)didClickPostButton: (UIButton *)sender{

    // 获取属性字符串
    // 遍历 替换emoji。gif，图片附件为响应的编码
    /*
        通过打印不同类型的属性字典发现， 普通文本的属性字典如下
         {
             NSFont = "<UICTFont: 0x7fba62c1ba00> font-family: \".SFUIText\"; font-weight: normal; font-style: normal; font-size: 15.00pt";
         }
     
        emoji表情的字典如下，多了三个键值，其中YYTextAttachment表示附件对象，YYTextBackedString表示原来字符串对象
         {
             CTRunDelegate = "<CTRunDelegate 0x600002203900 [0x10fc4fb68]>";
             NSFont = "<UICTFont: 0x7fba62c1ba00> font-family: \".SFUIText\"; font-weight: normal; font-style: normal; font-size: 15.00pt";
             YYTextAttachment = "<YYTextAttachment: 0x600001391100>";
             YYTextBackedString = "<YYTextBackedString: 0x600000438850>";
         }
     
        tutu gif表情
         {
             CTRunDelegate = "<CTRunDelegate 0x600001dd1ce0 [0x113fa5b68]>";
             NSColor = "UIExtendedSRGBColorSpace 0.25098 0.254902 0.270588 1";
             NSFont = "<UICTFont: 0x7fa454d06970> font-family: \".SFUIText\"; font-weight: normal; font-style: normal; font-size: 15.00pt";
             YYTextAttachment = "<YYTextAttachment: 0x600002c12f80>";
         }
     
         图片
         {
             CTRunDelegate = "<CTRunDelegate 0x600001df47e0 [0x113fa5b68]>";
             NSColor = "UIExtendedSRGBColorSpace 0.25098 0.254902 0.270588 1";
             NSFont = "<UICTFont: 0x7fa454d06970> font-family: \".SFUIText\"; font-weight: normal; font-style: normal; font-size: 15.00pt";
             YYTextAttachment = "<YYTextAttachment: 0x600002c7a080>";
         }
     
     */
    NSAttributedString *attributString = self.textView.attributedText;
    [attributString enumerateAttributesInRange:attributString.yy_rangeOfAll options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSString *tip;
        if (attrs[@"YYTextAttachment"] == nil) {
            tip = @"普通文本";
            NSLog(@"%@   \n\n",tip);
        }else{
            tip = @"有附件";
            YYTextAttachment *attachment = attrs[@"YYTextAttachment"];
            YYTextBackedString *str = attrs[@"YYTextBackedString"];
            id content = attachment.content;
            if ([content isMemberOfClass:[UIImage class]]) {
                // emoji
                NSLog(@"emoji %@",str.string);
            }else if ([content isMemberOfClass:[UIImageView class]]) {
                // 图片
                NSLog(@"图片 %@",str.string);
            }else if ([content isMemberOfClass:[YYAnimatedImageView class]]){
                // gif
                NSLog(@"gif %@",str.string);
            }else if ([content isMemberOfClass:[JTHyberLinkLabel class]]){
                // a link
                NSLog(@"alink %@",str.string);
            }

        }
        NSLog(@"%@   ",NSStringFromRange(range));
    }];
    
}
- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivedFrameWillChangeNoti:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivedEmojiKeyboardNoti:) name:JTEmojiKeyboardActionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivedTutuGifKeyboardNoti:) name:JTTutuGifKeyboardActionNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivedFrameDidChangeNoti:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)setupViews{
    self.title = @"发帖";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = UIFontMake(15);
    //    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button setTitle:@"发布" forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didClickPostButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = UIFontMake(15);
    textField.textColor = [UIColor jt_colorWithHexString:@"404145"];
//    textField.delegate = self;
    NSAttributedString *place = [[NSAttributedString alloc] initWithString:@"请输入标题" attributes:@{ NSForegroundColorAttributeName : [UIColor jt_colorWithHexString:@"999CAA"], NSFontAttributeName :  UIFontMake(15)}];
    textField.attributedPlaceholder = place;
//    textField.backgroundColor = [UIColor lightGrayColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealValueWidthIn6(16));
        make.right.mas_equalTo(kRealValueWidthIn6(-16));
        make.top.mas_equalTo(kRealValueWidthIn6(8));
        make.height.mas_equalTo(kRealValueWidthIn6(44));
    }];
    self.textField = textField;
    
    YYTextSimpleEmoticonParser *parser = [[YYTextSimpleEmoticonParser alloc] init];
    parser.emoticonMapper = self.emojiMapDict;
    
//    YYTextLinePositionSimpleModifier *mod = [YYTextLinePositionSimpleModifier new];
//    mod.fixedLineHeight = 22;
//
    YYTextView *text = [[YYTextView alloc] init];
    text.textParser = parser;
//    text.font = UIFontMake(15);
//    text.textColor = [UIColor blackColor];
    text.placeholderFont = UIFontMake(15);
    text.placeholderTextColor = [UIColor jt_colorWithHexString:@"999CAA"];
    text.placeholderText = @"输入内容";
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    style.lineSpacing = 6;
    text.typingAttributes = @{NSForegroundColorAttributeName : [UIColor redColor], NSFontAttributeName : UIFontMake(15), NSParagraphStyleAttributeName : style};
    text.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//    text.linePositionModifier = mod;
//    text.text = @"[微笑][微笑][微笑][微笑]";
//    text.attributedText = [[NSAttributedString alloc] initWithString:@"[微笑][微笑][微笑][微笑]"];
    text.delegate = self;
    [self.view addSubview:text];
    self.textView = text;
    
    CGFloat bottom = -ToolBarHeight;
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealValueWidthIn6(16));
        make.right.mas_equalTo(kRealValueWidthIn6(-16));
        make.top.mas_equalTo(kRealValueWidthIn6(44));
        make.bottom.mas_equalTo(kRealValueWidthIn6(bottom));
    }];
    
    EHTPostToolView *tool = [[EHTPostToolView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - StatusAndNaviBarHeight - ToolBarHeight, SCREEN_WIDTH, ToolBarHeight)];
    tool.delegate = self;
    [self.view addSubview:tool];
    self.toolView = tool;
    
    
    JTEmojiKeyboardView *keyboard = [[JTEmojiKeyboardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, EmojiKeyboardHeight)];
    keyboard.emojiModelArr = self.emojiModelArr;
    keyboard.tutuModelArr = self.tutuModelArr;
    self.emojiKeyboard = keyboard;
    
//    self.textView.
    
    /*
        自定义inputView，在控件成为第一响应者的时候以动画的方式的出现，默认情况为nil， 弹出系统默认键盘
    */
//    textField.inputView = tool;
    /*
     键盘高度  不同机型上高度可能不一样
     iphoneX 335
     
     inputAccessoryView  辅助输入视图，在键盘上方， 成为键盘的一部分，并且键盘frame改变的时候发送通知其中的frame算上inputAccessoryView的高度
     */
    
//    textField.inputAccessoryView = tool;
//    [textField becomeFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
}
#pragma mark - 插入附件方法
// 插入图片
/*
 1，对图片进行等比缩放。 使宽度等于textView的宽度
 2，根据图片创建属性字符串，并在前后插入换行符
 3，获取textView当前选中位置，以及当前属性字符串，插入图片，重新设置给textView
 4,调用上传图片的接口， 如果上传成功， 根据返回的地址
 
 发现一个问题：  插入属性字符串后。textView的样式变了。 字体大小改变了 需要重新设置属性
 */
- (void)insertImageWith:(NSArray <UIImage *> *)imageArray{
    
//    UIImage *image = [UIImage imageNamed:@"pia"];
//    image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];    
    NSMutableAttributedString *mutableAttri = [[NSMutableAttributedString alloc] init];
    [imageArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 保存文件到本地
        NSString *imageName = [NSString randomStringWithLength:15];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *imagePath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@.png",imageName]];
        [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
        
        
        // 文件读取
        UIImage *readImage = [UIImage imageNamed:imagePath];
        
        // 获取缩放后适合的图片大小
        CGFloat oldWidth = image.size.width;
        CGFloat oldHeight = image.size.height;
        CGFloat newWidth = self.textView.width - self.textView.contentInset.left - self.textView.contentInset.right;
        CGFloat newHeight = (oldHeight * newWidth) / oldWidth;
        CGSize newSize = CGSizeMake(newWidth, newHeight);
        
        //    UIImage 附件
        //    NSMutableAttributedString *imageAttachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:newSize alignToFont:UIFontMake(15) alignment:YYTextVerticalAlignmentCenter];
        
        // UIView附件
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, newWidth, newHeight)];
        imageView.image = image;
        NSMutableAttributedString *imageAttachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:newSize alignToFont:UIFontMake(15) alignment:YYTextVerticalAlignmentCenter];
        YYTextBackedString *str = [YYTextBackedString stringWithString:imagePath];
        [imageAttachText addAttribute:@"YYTextBackedString" value:str range:imageAttachText.yy_rangeOfAll];
        
        [imageAttachText insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:0];
        [imageAttachText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        [mutableAttri appendAttributedString:imageAttachText];
    }];
    
    NSMutableAttributedString *originalAttribut = [[NSMutableAttributedString alloc] initWithAttributedString: self.textView.attributedText];
    NSRange selectedRange = self.textView.selectedRange;
    
    // 重新设置字体大小和颜色 不然样式会丢失
    [originalAttribut insertAttributedString:mutableAttri atIndex:selectedRange.location];
    [originalAttribut addAttributes:self.textView.typingAttributes range:originalAttribut.yy_rangeOfAll];
    self.textView.attributedText = originalAttribut;
    self.textView.selectedRange = NSMakeRange(selectedRange.location + mutableAttri.length, 0);
}

// 插入gif
- (void)insertGifWith: (JTEmojiModel *)model{
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:model.gifImage];
    
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:UIFontMake(15) alignment:YYTextVerticalAlignmentCenter];
    YYTextBackedString *str = [YYTextBackedString stringWithString:model.code];
    [attachText addAttribute:@"YYTextBackedString" value:str range:attachText.yy_rangeOfAll];
    
    NSMutableAttributedString *originalAttribut = [[NSMutableAttributedString alloc] initWithAttributedString: self.textView.attributedText];
    NSRange selectedRange = self.textView.selectedRange;
    
    // 插入一个相同属性的字符串  这样有一个bug就是可以删除 并且删除之后样式还是会乱
//    [attachText appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:self.textView.typingAttributes]];
    
    // 重新设置字体大小和颜色 不然样式会丢失
    [originalAttribut insertAttributedString:attachText atIndex:selectedRange.location];
    [originalAttribut addAttributes:self.textView.typingAttributes range:originalAttribut.yy_rangeOfAll];
    
    self.textView.attributedText = originalAttribut;
    self.textView.selectedRange = NSMakeRange(selectedRange.location + attachText.length, 0);
}
// 插入超链接
- (void)insertHyperlinks{
    [CommunityPublishInpugHyperlinksView loadingMaskTitle:@"插入超链接" callBack:^(CommunityPublishInpugHyperlinksView * _Nonnull hyperView) {
        NSLog(@"%@",hyperView.hyperlinks.text);
        NSLog(@"%@",hyperView.hyperlinksTitle.text);
        NSString *address = hyperView.hyperlinks.text;
        NSString *title = hyperView.hyperlinksTitle.text;
        title = @"超链接";
        address = @"http://www.baidu.com";
        if ([address length] == 0) {
            return ;
        }
        
        if ([title length] == 0) {
            title = address;
        }
        // 这种方式有问题， 经典问题就是插入之后 样式变了。 所以考虑另外一种方式 ，和插入图片和gif思路一样，插入附件
//        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:title];
//        attri.yy_underlineStyle = NSUnderlineStyleSingle;
//        YYTextHighlight *highlight = [YYTextHighlight new];
//        [highlight setColor:[UIColor blueColor]];
//        highlight.userInfo = @{@"urlStr" : address};
//        [attri yy_setTextHighlight:highlight range:attri.yy_rangeOfAll];
//        [attri yy_setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:attri.yy_rangeOfAll];
//        [attri addAttributes:@{NSForegroundColorAttributeName : [UIColor blueColor], NSFontAttributeName : UIFontMake(15)} range:attri.yy_rangeOfAll];
        
        
        JTHyberLinkLabel *label = [[JTHyberLinkLabel alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickLink:)];
        label.userInteractionEnabled = YES;
        label.address = address;
        [label addGestureRecognizer:tap];
        NSMutableAttributedString *labelAttriStr = [[NSMutableAttributedString alloc] initWithString:title];
        [labelAttriStr addAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),NSForegroundColorAttributeName : [UIColor blueColor], NSFontAttributeName : UIFontMake(15), @"address" : address} range:labelAttriStr.yy_rangeOfAll];
        label.attributedText = labelAttriStr;
        [label sizeToFit];
        
//        NSMutableAttributedString *attri
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:label contentMode:UIViewContentModeCenter attachmentSize:label.size alignToFont:UIFontMake(15) alignment:YYTextVerticalAlignmentCenter];
        YYTextBackedString *str = [YYTextBackedString stringWithString:address];
        [attachText addAttribute:@"YYTextBackedString" value:str range:attachText.yy_rangeOfAll];
        
        
        
        NSMutableAttributedString *originalAttribut = [[NSMutableAttributedString alloc] initWithAttributedString: self.textView.attributedText];
        NSRange selectedRange = self.textView.selectedRange;
        
        // 重新设置字体大小和颜色 不然样式会丢失
        [originalAttribut insertAttributedString:attachText atIndex:selectedRange.location];
        [originalAttribut addAttributes:self.textView.typingAttributes range:originalAttribut.yy_rangeOfAll];
        self.textView.attributedText = originalAttribut;
        self.textView.selectedRange = NSMakeRange(selectedRange.location + attachText.length, 0);
    }];
}

// 插入换行
- (void)insertNewLine{
    NSMutableAttributedString *originalAttribut = [[NSMutableAttributedString alloc] initWithAttributedString: self.textView.attributedText];
    NSRange selectedRange = self.textView.selectedRange;
    NSAttributedString * attri = [[NSAttributedString alloc] initWithString:@"\n"];
    // 重新设置字体大小和颜色 不然样式会丢失
    [originalAttribut insertAttributedString:attri atIndex:selectedRange.location];
    [originalAttribut addAttributes:@{NSForegroundColorAttributeName : [UIColor jt_colorWithHexString:@"404145"], NSFontAttributeName : UIFontMake(15)} range:originalAttribut.yy_rangeOfAll];
    self.textView.attributedText = originalAttribut;
    self.textView.selectedRange = NSMakeRange(selectedRange.location + attri.length, 0);
}
#pragma mark - 点击超链接方法
- (void)didClickLink: (UIGestureRecognizer *)ges{
    JTHyberLinkLabel *label = (JTHyberLinkLabel *)ges.view;
    NSLog(@"%@",label.address);
}

#pragma mark - EHTPostToolViewDelegate
- (void)didClickButtonWithIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
            // @
            NSLog(@"@");
        }
            break;
        case 1:
        {
            // 视频
            NSLog(@"视频");
        }
            break;
        case 2:
        {
            // 超链接
            NSLog(@"超链接");
            [self insertHyperlinks];
        }
            break;
        case 3:
        {
            // 图片
            [self.textView resignFirstResponder];
            WEAKSELF;
            EHTSelectImageManager *mgr = [EHTSelectImageManager sharedSelectImageManager];
            mgr.selectedPhotos = nil;
            [mgr addImages];
            mgr.addImageBlock = ^(NSMutableArray *images) {
                [weakSelf insertImageWith:images];
            };
        }
            break;
        case 4:
        {
            // 表情键盘
            NSLog(@"表情键盘");
            if (isEmojiKeyboard) {
                isEmojiKeyboard = NO;
                [self.textView resignFirstResponder];
                self.textView.inputView = nil;
                [self.textView becomeFirstResponder];
            }else{
                isEmojiKeyboard = YES;
                [self.textView resignFirstResponder];
                self.textView.inputView = self.emojiKeyboard;
                [self.textView becomeFirstResponder];
            }
            
        }
            break;
        case 5:
        {
            // 换行
            NSLog(@"换行");
            [self insertNewLine];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - YYTextViewDelegate
- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView{
    isYYTextEditing = YES;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(YYTextView *)textView{
    return YES;
}
- (void)textViewDidBeginEditing:(YYTextView *)textView{
    NSLog(@"textViewDidBeginEditing");
    
}
- (void)textViewDidEndEditing:(YYTextView *)textView{
    isYYTextEditing = NO;
    NSLog(@"textViewDidEndEditing");
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"shouldChangeTextInRange   range=%@ || text=%@",NSStringFromRange(range),text);
    return YES;
}
- (void)textViewDidChange:(YYTextView *)textView{
    NSLog(@"textViewDidChange %@",textView.text);
}
- (void)textViewDidChangeSelection:(YYTextView *)textView{
    
    NSLog(@"textViewDidChangeSelection  currentSeletedRange:%@",NSStringFromRange(textView.selectedRange));
}

// 点击方法
- (void)textView:(YYTextView *)textView didTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect{
    NSDictionary *userInfo = highlight.userInfo;
    NSString *urlStr = userInfo[@"urlStr"];
    NSLog(@"%@",urlStr);
}

#pragma - mark 通知方法
- (void)didReceivedFrameWillChangeNoti: (NSNotification *)noti{
    
    /*
     通知中有这样几个信息
     UIKeyboardAnimationCurveUserInfoKey = 7;  动画curve
     UIKeyboardAnimationDurationUserInfoKey = "0.25";  动画持续时间
     UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 335}}";   键盘的bpunds
     UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 666.5}";   开始时center
     UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 644.5}";  结束时center
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 521}, {375, 291}}";  开始时frame
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 477}, {375, 335}}"; 结束时frame
     UIKeyboardIsLocalUserInfoKey = 1;
     */
    if (isYYTextEditing == NO) {
        return;
    }
    
    NSDictionary *userinfo = noti.userInfo;
    NSInteger curve = [[userinfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [[userinfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endFrame = [[userinfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat endY = endFrame.origin.y;
    NSLog(@"%@,%@",noti.object,NSStringFromCGRect(endFrame));
    CGFloat endBottom = endY - SCREEN_HEIGHT - ToolBarHeight;
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:curve];
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(endBottom);
        }];
        
        self.toolView.y = (endY - self->ToolBarHeight - StatusAndNaviBarHeight);
    }];
}

- (void)didReceivedEmojiKeyboardNoti: (NSNotification *)noti{
    JTEmojiModel *model = noti.object;
    if (model.type == JTEmojiTypeEmoji) {
        // 插入
        [self.textView insertText:model.code];
    }else{
        [self.textView deleteBackward];
    }
}

- (void)didReceivedTutuGifKeyboardNoti: (NSNotification *)noti{
    JTEmojiModel *model = noti.object;
    [self insertGifWith:model];
}

//- (void)didReceivedFrameDidChangeNoti: (NSNotification *)noti{
//    NSDictionary *userinfo = noti.userInfo;
//    NSLog(@"didChange %@",userinfo);
//}

-(void)dealloc{
    [EHTSelectImageManager deallocManager];
}

@end

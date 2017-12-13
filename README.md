# iOS 各种边距

## 1.UIViewController的边距

### edgesForExtendedLayout、automaticallyAdjustsScrollViewInsets属性

**edgesForExtendedLayout**

默认值为UIRectEdgeAll

作用：
> 指定边缘延伸的方向，默认值是UIRectEdgeAll四周延伸，就是说即使视图中上有navigationBar，下有tabBar，那么视图仍会延伸覆盖到四周的区域。

```objc
typedef NS_OPTIONS(NSUInteger, UIRectEdge) {
    UIRectEdgeNone   = 0,
    UIRectEdgeTop    = 1 << 0,
    UIRectEdgeLeft   = 1 << 1,
    UIRectEdgeBottom = 1 << 2,
    UIRectEdgeRight  = 1 << 3,
    UIRectEdgeAll    = UIRectEdgeTop | UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight
} NS_ENUM_AVAILABLE_IOS(7_0);
```

**automaticallyAdjustsScrollViewInsets**

iOS7以后布局是全局的如果设置了frame y从0开始的话则，在有导航栏的情况下，tableView的布局会被遮住一部分，为了解决这个问题增加了automaticallyAdjustsScrollViewInsets属性,默认YES

在一个界面有tatus bar，navigationbar，tabbar时候，UIScrollViw及其子类如UITableView，UIWebView，UITextView就会调整内边距，让frame的 y 不是从tatus bar，navigationbar底部开始为。

（1）当automaticallyAdjustsScrollViewInsets为YES的时候

<img src="https://github.com/gurongkang/KRTestLayout/raw/master/images/adjust_yes.png" width="320">

(2) self.automaticallyAdjustsScrollViewInsets = NO;

<img src="https://github.com/gurongkang/KRTestLayout/raw/master/images/adjust_no.png" width="320">
(3) 当automaticallyAdjustsScrollViewInsets为YES的时候edgesForExtendedLayout属性没啥作用

(4) 当automaticallyAdjustsScrollViewInsets为NO的时候edgesForExtendedLayout属性默认的时候既UIRectEdgeAll时候
情况同（2）一样
edgesForExtendedLayout属性为UIRectEdgeNone时候同(1)一样

综上所述，两个属性作用平时开发起来很恶心，因为实际场景中会经常遇到隐藏导航栏的情况，有些时候记住这些属性比较麻烦，因此同意设定为

```objc
self.automaticallyAdjustsScrollViewInsets = NO;
self.edgesForExtendedLayout = UIRectEdgeAll;
```
所有的情况由我们自己控制。


### 2.safeArea

上述属性是在iOS7 - iOS10中的到了iOS 11中又出现了新的特性safeArea，并且把automaticallyAdjustsScrollViewInsets给废除了，又导致了很多蛋疼的问题。

因为iPhone X的奇葩外观，必须确保布局充满屏幕，并且布局不会被设备的圆角、传感器外壳或者用于访问主屏幕的指示灯遮挡住。因此，苹果提出了safe area（安全区）的概念，就是上述可能遮挡界面的区域以外的区域被定义为安全区。

苹果推荐的安全区，竖屏下如图所示，栏高度为 44pt，下方指示灯处的高度为 34pt

<img src="https://github.com/gurongkang/KRTestLayout/raw/master/images/safe_v.jpg" width="320">

横屏下，上下安全边距分别为 0pt/21pt，左右安全边距为 44pt/44pt

<img src="https://github.com/gurongkang/KRTestLayout/raw/master/images/safe_h.jpg" width="320">

使用了UINavigationBar和UITabBar，安全区的上边缘会变成导航栏下边缘的位置

实际使用中可以通过下面的宏进行适配

状态栏高度的宏定义为：

```objc
#define STATUS_HEIGHT   (IS_IPHONE_X?44:20)
```

增加安全区域下面的区域的高度宏定义为：

```objc
#define BOTTOM_SAFEAREA_HEIGHT (IS_IPHONE_X? 34 : 0)
```

如果你同时也用了自定义的UITabBar那么就需要修改TABBAR_HEIGHT的宏定义为：

```objc
#define TABBAR_HEIGHT   (IS_IPHONE_X? (49 + 34) : 49)
```

安全区主要是通过下面两个属性一个方法确定

```objc
safeAreaInsets和safeAreaLayoutGuide
-(void)viewSafeAreaInsetsDidChange
```

方法测试  有navgationbar 

```objc
- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    NSLog(@"%@", NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
    NSLog(@"%@", NSStringFromUIEdgeInsets(self.additionalSafeAreaInsets));
    /**
     * 在iOS 11 iPhone 8 有navgationbar 打印如下
     * 2017-12-12 17:27:34.789117+0800 KRTestLayout[7520:1607431] {64, 0, 0, 0}
     * 2017-12-12 17:27:34.789314+0800 KRTestLayout[7520:1607431] {0, 0, 0, 0}
     *
     * 在iOS 11 iPhone X 有navgationbar 打印如下
     * 2017-12-12 17:30:55.503033+0800 KRTestLayout[7633:1623120] {88, 0, 34, 0}
     *  2017-12-12 17:30:55.503169+0800 KRTestLayout[7633:1623120] {0, 0, 0, 0}
     */
}
```

无navgationbar 

```objc
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    /**
     * 在iOS 11 iPhone 8 无navgationbar 打印如下
     * 2017-12-12 17:34:37.382000+0800 KRTestLayout[7756:1637921] {20, 0, 0, 0}
     * 2017-12-12 17:34:37.382157+0800 KRTestLayout[7756:1637921] {0, 0, 0, 0}
     *
     * 在iOS 11 iPhone X 无navgationba 打印如下
     * 2017-12-12 17:35:18.205627+0800 KRTestLayout[7801:1646680] {44, 0, 34, 0}
     * 2017-12-12 17:35:18.205811+0800 KRTestLayout[7801:1646680] {0, 0, 0, 0}
     */
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
```

## 3.UIScrollView、UITableView的各种边距

UIScrollView 可滚动视图，UITableView集成UIScrollView.

令人迷惑的三个属性

```objc
contentSize
contentInset
contentOffset
```

**contentSize:**可以滚动的区域
**contentOffset:**偏移量,其中分为contentOffset.y=内容的顶部和frame顶部的差值,contentOffset.x=内容的左边和frame左边的差值,
**contentInset:**即内边距,contentInset = 在内容周围增加的间距(粘着内容),contentInset的单位是UIEdgeInsets,默认值为UIEdgeInsetsZero。

几者之间关系：
>contentOffset.y = 内容的顶部 与 frame顶部差值
 contentInset = 在内容周围增加边距


tableView的contentSize包括的：
>Cell、TableViewHeaderView、TableViewFooterView、SectionHeader、 SectionFooter

（1）情景一：没有cell，没有contentInset，没有tableHeaderView\tableFooterView

<img src="https://github.com/gurongkang/KRTestLayout/raw/master/images/site1.png" width="500">

（2）情景二：没有cell，没有contentInset，有tableHeaderView\tableFooterView

<img src="https://github.com/gurongkang/KRTestLayout/raw/master/images/site2.png" width="500">

（3）情景三：有cell，没有contentInset，没有tableHeaderView\tableFooterView

<img src="https://github.com/gurongkang/KRTestLayout/raw/master/images/site3.png" width="500">

（4）情景四：有cell，有contentInset，没有tableHeaderView\tableFooterView

<img src="https://github.com/gurongkang/KRTestLayout/raw/master/images/site4.png" width="500">

（5）情景五：有cell，没有contentInset，有tableHeaderView\tableFooterView

<img src="https://github.com/gurongkang/KRTestLayout/raw/master/images/site5.png" width="500">

（6）情景六：有cell，有contentInset，有tableHeaderView\tableFooterView

<img src="https://github.com/gurongkang/KRTestLayout/raw/master/images/site6.png" width="500">

（7）情景七：有cell，有contentInset，没有tableHeaderView\tableFooterView，添加了一个子控件，frame是CGRectMake(0, 0, 300, 50)，子控件的frame以父控件内容左上角为坐标原点{0,0}

<img src="https://github.com/gurongkang/KRTestLayout/raw/master/images/site7.1.png" width="500">

<img src="https://github.com/gurongkang/KRTestLayout/raw/master/images/site7.2.png" width="500">

（8）情景八：有cell，有contentInset，没有tableHeaderView\tableFooterView,添加了一个子控件，frame是CGRectMake(0,-50, 300, 50)，子控件的frame以父控件内容左上角为坐标原点{0,0}

<img src="https://github.com/gurongkang/KRTestLayout/raw/master/images/site8.1.png" width="500">

<img src="https://github.com/gurongkang/KRTestLayout/raw/master/images/site8.2.png" width="500">

（9）情景九：有cell，没有contentInset，有tableHeaderView\tableFooterVi添加了一个子控件，frame是CGRectMake(0,-50, 300, 50)，子控件的frame以父控件内容左上角为坐标原点{0,0}

<img src="https://github.com/gurongkang/KRTestLayout/raw/master/images/site9.1.png" width="500">

<img src="https://github.com/gurongkang/KRTestLayout/raw/master/images/site9.2.png" width="500">

**在iOS11增加了两个新的属性**

```objc
adjustContentInset
contentInsetAdjustmentBehavior
```

进头文件里面去看看

```objc
/* When contentInsetAdjustmentBehavior allows, UIScrollView may incorporate
 its safeAreaInsets into the adjustedContentInset.
 */
@property(nonatomic, readonly) UIEdgeInsets adjustedContentInset API_AVAILABLE(ios(11.0),tvos(11.0));

/* Also see -scrollViewDidChangeAdjustedContentInset: in the UIScrollViewDelegate protocol.
 */
- (void)adjustedContentInsetDidChange API_AVAILABLE(ios(11.0),tvos(11.0)) NS_REQUIRES_SUPER;

/* Configure the behavior of adjustedContentInset.
 Default is UIScrollViewContentInsetAdjustmentAutomatic.
 */
@property(nonatomic) UIScrollViewContentInsetAdjustmentBehavior contentInsetAdjustmentBehavior API_AVAILABLE(ios(11.0),tvos(11.0));

```
adjustedContentInset是一个只读属性，我们不可以改变，那么它的值代表什么呢？怎么才会改变的？

adjustedContentInset代表的含义和contentInset 是一样的，contentView.frame.origin偏移了scrollview.frame.origin多少。

adjustedContentInset是只读的，它的值由safeAreaInset 与 contentInset 计算而来的，计算方式由以下4种方式，由新加的枚举属性`contentInsetAdjustmentBehavior`决定

```objc
typedef NS_ENUM(NSInteger, UIScrollViewContentInsetAdjustmentBehavior) {
    UIScrollViewContentInsetAdjustmentAutomatic, // Similar to .scrollableAxes, but for backward compatibility will also adjust the top & bottom contentInset when the scroll view is owned by a view controller with automaticallyAdjustsScrollViewInsets = YES inside a navigation controller, regardless of whether the scroll view is scrollable
    UIScrollViewContentInsetAdjustmentScrollableAxes, // Edges for scrollable axes are adjusted (i.e., contentSize.width/height > frame.size.width/height or alwaysBounceHorizontal/Vertical = YES)
    UIScrollViewContentInsetAdjustmentNever, // contentInset is not adjusted
    UIScrollViewContentInsetAdjustmentAlways, // contentInset is always adjusted by the scroll view's safeAreaInsets
} API
```
>测试代码见项目中KRSafeAreaViewController控制器，测试值在iOS 11 iPhone 8中打印

**(1)当contentInsetAdjustmentBehavior为UIScrollViewContentInsetAdjustmentAutomatic时**

如果scrollview在一个contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic的controller上，并且这个Controller包含在一个navigation controller中，这种情况下会设置在top & bottom上 adjustedContentInset = safeAreaInset + contentInset 不管是否滚动。

```objc
- (void)testAdjustContentInsetAutomatic {
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        
        self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
//        2017-12-13 16:21:09.759001+0800 KRTestLayout[6338:1032624] contentInset-> {60, 0, 0, 0}
//        2017-12-13 16:21:09.759123+0800 KRTestLayout[6338:1032624] safeAreaInsets-> {64, 0, 0, 0}
//        2017-12-13 16:21:09.759214+0800 KRTestLayout[6338:1032624] additionalSafeAreaInsets-> {0, 0, 0, 0}
//        2017-12-13 16:21:09.759306+0800 KRTestLayout[6338:1032624] adjustedContentInset-> {124, 0, 0, 0}
        self.additionalSafeAreaInsets =  UIEdgeInsetsMake(120, 0, 0, 0);
//        2017-12-13 16:22:20.659263+0800 KRTestLayout[6368:1037697] contentInset-> {60, 0, 0, 0}
//        2017-12-13 16:22:20.659419+0800 KRTestLayout[6368:1037697] safeAreaInsets-> {184, 0, 0, 0}
//        2017-12-13 16:22:20.659537+0800 KRTestLayout[6368:1037697] additionalSafeAreaInsets-> {120, 0, 0, 0}
//        2017-12-13 16:22:20.659649+0800 KRTestLayout[6368:1037697] adjustedContentInset-> {244, 0, 0, 0}
    }
}
```

**(2)当contentInsetAdjustmentBehavior为UIScrollViewContentInsetAdjustmentScrollableAxes时**

在可滚动方向上adjustedContentInset = safeAreaInset + contentInset，在不可滚动方向上adjustedContentInset = contentInset；依赖于scrollEnabled和alwaysBounceHorizontal / vertical = YES，scrollEnabled默认为yes，所以大多数情况下，计算方式还是adjustedContentInset = safeAreaInset + contentInset

```objc
- (void)testAdjustContentInsetScrollableAxes {
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentScrollableAxes;
        
        self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
//        2017-12-13 16:30:01.264643+0800 KRTestLayout[6507:1064131] contentInset-> {60, 0, 0, 0}
//        2017-12-13 16:30:01.264804+0800 KRTestLayout[6507:1064131] safeAreaInsets-> {64, 0, 0, 0}
//        2017-12-13 16:30:01.264890+0800 KRTestLayout[6507:1064131] additionalSafeAreaInsets-> {0, 0, 0, 0}
//        2017-12-13 16:30:01.264983+0800 KRTestLayout[6507:1064131] adjustedContentInset-> {124, 0, 0, 0}
        
        self.tableView.scrollEnabled = NO;
//        2017-12-13 16:30:47.083295+0800 KRTestLayout[6539:1067398] contentInset-> {60, 0, 0, 0}
//        2017-12-13 16:30:47.083438+0800 KRTestLayout[6539:1067398] safeAreaInsets-> {0, 0, 0, 0}
//        2017-12-13 16:30:47.083549+0800 KRTestLayout[6539:1067398] additionalSafeAreaInsets-> {0, 0, 0, 0}
//        2017-12-13 16:30:47.083636+0800 KRTestLayout[6539:1067398] adjustedContentInset-> {60, 0, 0, 0}
    }
}
```

**(3)当contentInsetAdjustmentBehavior为UIScrollViewContentInsetAdjustmentNever时**

adjustContentInset值不受SafeAreaInset值的影响。

adjustedContentInset = contentInset

```
- (void)testAdjustContentInsetNever {
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
        
//        2017-12-13 16:33:20.537079+0800 KRTestLayout[6618:1080094] contentInset-> {60, 0, 0, 0}
//        2017-12-13 16:33:20.537246+0800 KRTestLayout[6618:1080094] safeAreaInsets-> {0, 0, 0, 0}
//        2017-12-13 16:33:20.537390+0800 KRTestLayout[6618:1080094] additionalSafeAreaInsets-> {0, 0, 0, 0}
//        2017-12-13 16:33:20.537490+0800 KRTestLayout[6618:1080094] adjustedContentInset-> {60, 0, 0, 0}
    }
}
```

**(4)当contentInsetAdjustmentBehavior为UIScrollViewContentInsetAdjustmentAlways时**

adjustedContentInset = safeAreaInset + contentInset

```
- (void)testAdjustContentInsetAlways {
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
        self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
        
//        2017-12-13 16:35:05.990422+0800 KRTestLayout[6666:1088653] contentInset-> {60, 0, 0, 0}
//        2017-12-13 16:35:05.990543+0800 KRTestLayout[6666:1088653] safeAreaInsets-> {64, 0, 0, 0}
//        2017-12-13 16:35:05.990670+0800 KRTestLayout[6666:1088653] additionalSafeAreaInsets-> {0, 0, 0, 0}
//        2017-12-13 16:35:05.990771+0800 KRTestLayout[6666:1088653] adjustedContentInset-> {124, 0, 0, 0}
    }
}
```

UITableView中莫名多20个像素的问题


## 4.NavigationBar的各种边距







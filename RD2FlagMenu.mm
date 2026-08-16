// ============================================================
//  RD2 Flag Menu — 非脱獄内蔵MODメニュー（データフラグ方式）
//  ・UnityFrameworkは静的トランポリン改造済み（署名前に焼込）
//  ・このdylibは「フラグ(RWデータ)を1/0書くだけ」でトグル
//    → コード改変じゃないのでiOS18でもクラッシュしない
//  ・フローティング🎲 → 紫のスリークなパネル
// ============================================================
#import <UIKit/UIKit.h>
#include <mach-o/dyld.h>
#include <string.h>

#pragma mark - Flag Engine（データ書込のみ／コード改変なし）

static uintptr_t gSlide = 0;
static bool      gResolved = false;
static const char *kImage = "UnityFramework";

static void resolveSlide(void) {
    uint32_t n = _dyld_image_count();
    for (uint32_t i = 0; i < n; i++) {
        const char *nm = _dyld_get_image_name(i);
        if (!nm) continue;
        size_t l = strlen(nm), k = strlen(kImage);
        if (l >= k && strcmp(nm + l - k, kImage) == 0) {
            gSlide = (uintptr_t)_dyld_get_image_vmaddr_slide(i);
            gResolved = true; return;
        }
    }
}
// フラグ(RW __data)へ 1/0 を書くだけ。vm_protect不要（元からRW）。
static bool setFlag(uint64_t vmoff, bool on) {
    if (!gResolved) resolveSlide();
    if (!gResolved) return false;
    volatile uint8_t *p = (volatile uint8_t *)(gSlide + (uintptr_t)vmoff);
    *p = on ? 1 : 0;
    return true;
}

#pragma mark - Cheat 定義（name, sub, flag vmoffset）
// ※フラグのvmoffsetは UnityFramework 静的改造ツールが割り当てた値。
//   Phase1 POC: SP無限のみ（0xCEEBB90）。以降ここに追記して増やす。
static NSArray *cheats(void) {
    return @[
      @{ @"name":@"即死", @"sub":@"敵をワンパンで撃破", @"flag":@(0xCF3A881) },
      @{ @"name":@"ボス超火力", @"sub":@"対ボスダメージ巨大化", @"flag":@(0xCF3A882) },
      @{ @"name":@"無敵", @"sub":@"自分のHPが減らない", @"flag":@(0xCF3A883) },
      @{ @"name":@"SP 無限", @"sub":@"召喚・強化がタダ", @"flag":@(0xCF3A884) },
      @{ @"name":@"SP獲得 +30000", @"sub":@"撃破/ウェーブ/初期SP", @"flag":@(0xCF3A885) },
      @{ @"name":@"自由合成 ★", @"sub":@"合成可否を常時OK", @"flag":@(0xCF3A886) },
      @{ @"name":@"自由合成 ②", @"sub":@"種類チェック解除", @"flag":@(0xCF3A887) },
      @{ @"name":@"自由合成 ③", @"sub":@"出目チェック解除", @"flag":@(0xCF3A888) },
      @{ @"name":@"倍速 2倍", @"sub":@"VIP速度と同経路", @"flag":@(0xCF3A889) },
      @{ @"name":@"倍速 5倍", @"sub":@"2倍とはどちらか一方", @"flag":@(0xCF3A88A) },
      @{ @"name":@"常に死亡", @"sub":@"敵が湧いた瞬間に消える(実験的)", @"flag":@(0xCF3A88B) },
      @{ @"name":@"サポーター技 回数無制限", @"sub":@"発動可否を常時OK", @"flag":@(0xCF3A88C) },
      @{ @"name":@"サポーター技 CT除去★", @"sub":@"充填クールタイム消滅", @"flag":@(0xCF3A88D) },
      @{ @"name":@"合成スコア ×5", @"sub":@"対戦モード限定", @"flag":@(0xCF3A88E) },
      @{ @"name":@"撃破スコア ×5 (1000)", @"sub":@"協力=BAN注意", @"flag":@(0xCF3A88F) },
      @{ @"name":@"撃破スコア ×1.3 (1000)", @"sub":@"控えめ/検知され難い", @"flag":@(0xCF3A890) },
      @{ @"name":@"撃破スコア ×5 (5000)", @"sub":@"協力=BAN注意", @"flag":@(0xCF3A891) },
      @{ @"name":@"撃破スコア ×1.3 (5000)", @"sub":@"控えめ/検知され難い", @"flag":@(0xCF3A892) },
      @{ @"name":@"撃破スコア ×5 (50)", @"sub":@"協力=BAN注意", @"flag":@(0xCF3A893) },
      @{ @"name":@"撃破スコア ×1.3 (50)", @"sub":@"控えめ/検知され難い", @"flag":@(0xCF3A894) },
      @{ @"name":@"撃破スコア ×5 (500)", @"sub":@"協力=BAN注意", @"flag":@(0xCF3A895) },
      @{ @"name":@"撃破スコア ×1.3 (500)", @"sub":@"控えめ/検知され難い", @"flag":@(0xCF3A896) },

    ];
}

#pragma mark - 配色（Random Dice 2 テーマ）
static UIColor *PUR(void){ return [UIColor colorWithRed:0.78 green:0.49 blue:1.00 alpha:1]; } // accent紫
static UIColor *PUR2(void){return [UIColor colorWithRed:0.55 green:0.31 blue:0.85 alpha:1]; }
static UIColor *PINK(void){return [UIColor colorWithRed:1.00 green:0.43 blue:0.78 alpha:1]; }
static UIColor *GOLD(void){return [UIColor colorWithRed:1.00 green:0.84 blue:0.29 alpha:1]; }

// パススルーWindow（背景タッチはゲームへ）
@interface RD2Window : UIWindow @end
@implementation RD2Window
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *v = [super hitTest:point withEvent:event];
    if (v == self || v == self.rootViewController.view) return nil;
    return v;
}
@end

@interface RD2Menu : NSObject
@property (nonatomic, strong) UIWindow *win;
@property (nonatomic, strong) UIButton *fab;
@property (nonatomic, strong) UIView   *panel;
@property (nonatomic, assign) BOOL open;
+ (instancetype)shared; - (void)boot;
@end

@implementation RD2Menu
+ (instancetype)shared { static RD2Menu *s; static dispatch_once_t o; dispatch_once(&o,^{ s=[RD2Menu new]; }); return s; }

- (UIWindowScene *)activeScene {
    for (UIScene *sc in UIApplication.sharedApplication.connectedScenes)
        if ([sc isKindOfClass:UIWindowScene.class] && sc.activationState==UISceneActivationStateForegroundActive)
            return (UIWindowScene *)sc;
    for (UIScene *sc in UIApplication.sharedApplication.connectedScenes)
        if ([sc isKindOfClass:UIWindowScene.class]) return (UIWindowScene *)sc;
    return nil;
}

- (void)boot {
    UIWindowScene *scene = [self activeScene];
    if (!scene) { dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(1.5*NSEC_PER_SEC)),dispatch_get_main_queue(),^{ [self boot]; }); return; }
    self.win = [[RD2Window alloc] initWithWindowScene:scene];
    self.win.frame = UIScreen.mainScreen.bounds;
    self.win.windowLevel = UIWindowLevelStatusBar + 1000;
    self.win.backgroundColor = UIColor.clearColor;
    self.win.rootViewController = [UIViewController new];
    self.win.rootViewController.view.backgroundColor = UIColor.clearColor;
    self.win.hidden = NO;
    [self buildFab]; [self buildPanel]; self.panel.hidden = YES;
}

- (void)buildFab {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = CGRectMake(20, 140, 60, 60);
    b.layer.cornerRadius = 30; b.clipsToBounds = YES;
    CAGradientLayer *g = [CAGradientLayer layer];
    g.frame = b.bounds; g.cornerRadius = 30; g.masksToBounds = YES;
    g.colors=@[(id)PUR().CGColor,(id)PINK().CGColor];
    g.startPoint=CGPointMake(0,0); g.endPoint=CGPointMake(1,1);
    [b.layer insertSublayer:g atIndex:0];
    [b setTitle:@"🎲" forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont systemFontOfSize:26];
    b.layer.shadowColor=PUR().CGColor; b.layer.shadowRadius=10; b.layer.shadowOpacity=0.8; b.layer.shadowOffset=CGSizeZero;
    [b addTarget:self action:@selector(togglePanel) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragFab:)];
    [b addGestureRecognizer:pan];
    [self.win.rootViewController.view addSubview:b]; self.fab = b;
}
- (void)dragFab:(UIPanGestureRecognizer *)p {
    CGPoint t=[p translationInView:self.win]; UIView *v=p.view;
    v.center=CGPointMake(v.center.x+t.x, v.center.y+t.y);
    [p setTranslation:CGPointZero inView:self.win];
}

- (void)buildPanel {
    CGFloat W=306, rowH=66, headH=70;
    NSArray *list = cheats();
    NSUInteger maxVisible = 7;                       // これ以上はスクロール
    CGFloat rowsH = rowH * list.count;               // 全行の高さ
    CGFloat viewRowsH = rowH * MIN((NSUInteger)list.count, maxVisible);
    CGFloat H = headH + viewRowsH + 10;
    UIView *root = self.win.rootViewController.view;
    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake((root.bounds.size.width-W)/2, 120, W, H)];
    panel.layer.cornerRadius = 24; panel.clipsToBounds = YES;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterialDark];
    UIVisualEffectView *bg = [[UIVisualEffectView alloc] initWithEffect:blur];
    bg.frame = panel.bounds; bg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [panel addSubview:bg];
    panel.layer.borderWidth = 1.2; panel.layer.borderColor = [PUR() colorWithAlphaComponent:0.5].CGColor;

    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0,0,W,headH)];
    CAGradientLayer *hg=[CAGradientLayer layer]; hg.frame=head.bounds;
    hg.colors=@[(id)[PUR2() colorWithAlphaComponent:0.95].CGColor,(id)[PINK() colorWithAlphaComponent:0.7].CGColor];
    hg.startPoint=CGPointMake(0,0); hg.endPoint=CGPointMake(1,0);
    [head.layer addSublayer:hg];
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(20,12,W-80,28)];
    title.text=@"🎲 Random Dice 2"; title.textColor=UIColor.whiteColor; title.font=[UIFont boldSystemFontOfSize:19];
    UILabel *sub=[[UILabel alloc] initWithFrame:CGRectMake(20,40,W-80,18)];
    sub.text=@"MOD MENU  •  かわいく改造"; sub.textColor=GOLD(); sub.font=[UIFont systemFontOfSize:11 weight:UIFontWeightSemibold];
    [head addSubview:title]; [head addSubview:sub];
    UIButton *close=[UIButton buttonWithType:UIButtonTypeCustom];
    close.frame=CGRectMake(W-48,18,34,34); [close setTitle:@"✕" forState:UIControlStateNormal];
    close.titleLabel.font=[UIFont boldSystemFontOfSize:19];
    [close addTarget:self action:@selector(togglePanel) forControlEvents:UIControlEventTouchUpInside];
    [head addSubview:close];
    UIPanGestureRecognizer *hp=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragPanel:)];
    [head addGestureRecognizer:hp];
    [panel addSubview:head];

    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, headH, W, viewRowsH)];
    sv.contentSize = CGSizeMake(W, rowsH);
    sv.showsVerticalScrollIndicator = YES;
    sv.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [panel addSubview:sv];

    for (NSUInteger i=0;i<list.count;i++){
        NSDictionary *c=list[i]; CGFloat y=rowH*i;
        UILabel *nm=[[UILabel alloc] initWithFrame:CGRectMake(20,y+13,W-96,22)];
        nm.text=c[@"name"]; nm.textColor=UIColor.whiteColor; nm.font=[UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        UILabel *sb=[[UILabel alloc] initWithFrame:CGRectMake(20,y+35,W-96,16)];
        sb.text=c[@"sub"]; sb.textColor=[UIColor colorWithWhite:1 alpha:0.55]; sb.font=[UIFont systemFontOfSize:11];
        UISwitch *sw=[[UISwitch alloc] init]; [sw sizeToFit];
        CGRect sf=sw.frame; sf.origin=CGPointMake(W-18-sf.size.width, y+(rowH-sf.size.height)/2); sw.frame=sf;
        sw.onTintColor=PUR(); sw.tag=i;
        [sw addTarget:self action:@selector(flip:) forControlEvents:UIControlEventValueChanged];
        [sv addSubview:nm]; [sv addSubview:sb]; [sv addSubview:sw];
        if (i<list.count-1){ UIView *ln=[[UIView alloc] initWithFrame:CGRectMake(18,y+rowH-0.5,W-36,0.5)]; ln.backgroundColor=[UIColor colorWithWhite:1 alpha:0.12]; [sv addSubview:ln]; }
    }
    panel.alpha=0; panel.transform=CGAffineTransformMakeScale(0.9,0.9);
    [root addSubview:panel]; self.panel=panel;
}
- (void)dragPanel:(UIPanGestureRecognizer *)p {
    CGPoint t=[p translationInView:self.win]; UIView *v=self.panel;
    v.center=CGPointMake(v.center.x+t.x, v.center.y+t.y);
    [p setTranslation:CGPointZero inView:self.win];
}
- (void)togglePanel {
    self.open = !self.open;
    if (self.open) {
        self.panel.hidden=NO;
        [UIView animateWithDuration:0.28 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.6 options:0 animations:^{
            self.panel.alpha=1; self.panel.transform=CGAffineTransformIdentity; self.fab.alpha=0.5;
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.panel.alpha=0; self.panel.transform=CGAffineTransformMakeScale(0.9,0.9); self.fab.alpha=1.0;
        } completion:^(BOOL f){ self.panel.hidden=YES; }];
    }
}
- (void)flip:(UISwitch *)sw {
    NSDictionary *c = cheats()[sw.tag];
    bool ok = setFlag([c[@"flag"] unsignedLongLongValue], sw.isOn);
    [self toast: ok ? [NSString stringWithFormat:@"%@ : %@", c[@"name"], sw.isOn?@"ON":@"OFF"]
                    : @"失敗: UnityFramework未検出"];
    if(!ok) sw.on=NO;
}
- (void)toast:(NSString *)msg {
    UIView *root=self.win.rootViewController.view;
    UILabel *t=[[UILabel alloc] initWithFrame:CGRectMake(0,0,270,40)];
    t.center=CGPointMake(root.bounds.size.width/2, root.bounds.size.height-90);
    t.text=msg; t.textAlignment=NSTextAlignmentCenter; t.textColor=UIColor.whiteColor;
    t.font=[UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    t.backgroundColor=[PUR2() colorWithAlphaComponent:0.92]; t.layer.cornerRadius=20; t.clipsToBounds=YES;
    t.alpha=0; [root addSubview:t];
    [UIView animateWithDuration:0.2 animations:^{ t.alpha=1; } completion:^(BOOL f){
        [UIView animateWithDuration:0.3 delay:1.0 options:0 animations:^{ t.alpha=0; } completion:^(BOOL g){ [t removeFromSuperview]; }];
    }];
}
@end

__attribute__((constructor))
static void RD2_init(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(4.0*NSEC_PER_SEC)),dispatch_get_main_queue(),^{
        resolveSlide();
        [[RD2Menu shared] boot];
        NSLog(@"[RD2Flag] booted. slide=0x%lx", (unsigned long)gSlide);
    });
}

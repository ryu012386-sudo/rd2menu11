// ============================================================
//  RD2 Flag Menu 窶・髱櫁┳迯・・阡ｵMOD繝｡繝九Η繝ｼ・医ョ繝ｼ繧ｿ繝輔Λ繧ｰ譁ｹ蠑擾ｼ・//  繝ｻUnityFramework縺ｯ髱咏噪繝医Λ繝ｳ繝昴Μ繝ｳ謾ｹ騾貂医∩・育ｽｲ蜷榊燕縺ｫ辟ｼ霎ｼ・・//  繝ｻ縺薙・dylib縺ｯ縲後ヵ繝ｩ繧ｰ(RW繝・・繧ｿ)繧・/0譖ｸ縺上□縺代阪〒繝医げ繝ｫ
//    竊・繧ｳ繝ｼ繝画隼螟峨§繧・↑縺・・縺ｧiOS18縺ｧ繧ゅけ繝ｩ繝・す繝･縺励↑縺・//  繝ｻ繝輔Ο繝ｼ繝・ぅ繝ｳ繧ｰ軸 竊・邏ｫ縺ｮ繧ｹ繝ｪ繝ｼ繧ｯ縺ｪ繝代ロ繝ｫ
// ============================================================
#import <UIKit/UIKit.h>
#include <mach-o/dyld.h>
#include <string.h>

#pragma mark - Flag Engine・医ョ繝ｼ繧ｿ譖ｸ霎ｼ縺ｮ縺ｿ・上さ繝ｼ繝画隼螟峨↑縺暦ｼ・
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
// 繝輔Λ繧ｰ(RW __data)縺ｸ 1/0 繧呈嶌縺上□縺代Ｗm_protect荳崎ｦ・ｼ亥・縺九ｉRW・峨・static bool setFlag(uint64_t vmoff, bool on) {
    if (!gResolved) resolveSlide();
    if (!gResolved) return false;
    volatile uint8_t *p = (volatile uint8_t *)(gSlide + (uintptr_t)vmoff);
    *p = on ? 1 : 0;
    return true;
}

#pragma mark - Cheat 螳夂ｾｩ・・ame, sub, flag vmoffset・・// 窶ｻ繝輔Λ繧ｰ縺ｮvmoffset縺ｯ UnityFramework 髱咏噪謾ｹ騾繝・・繝ｫ縺悟牡繧雁ｽ薙※縺溷､縲・//   Phase1 POC: SP辟｡髯舌・縺ｿ・・xCEEBB90・峨ゆｻ･髯阪％縺薙↓霑ｽ險倥＠縺ｦ蠅励ｄ縺吶・static NSArray *cheats(void) {
    return @[
      @{ @"name":@"蜊ｳ豁ｻ",              @"sub":@"謨ｵ繧偵Ρ繝ｳ繝代Φ縺ｧ謦・ｴ",         @"flag":@(0xCEEBB90) },
      @{ @"name":@"繝懊せ雜・↓蜉・,         @"sub":@"蟇ｾ繝懊せ繝繝｡繝ｼ繧ｸ蟾ｨ螟ｧ蛹・,        @"flag":@(0xCEEBB91) },
      @{ @"name":@"辟｡謨ｵ",              @"sub":@"閾ｪ蛻・・HP縺梧ｸ帙ｉ縺ｪ縺・,         @"flag":@(0xCEEBB92) },
      @{ @"name":@"SP 辟｡髯・,           @"sub":@"蜿ｬ蝟壹・蠑ｷ蛹悶′繧ｿ繝",           @"flag":@(0xCEEBB93) },
      @{ @"name":@"SP迯ｲ蠕・+30000",     @"sub":@"謦・ｴ/繧ｦ繧ｧ繝ｼ繝・蛻晄悄SP",       @"flag":@(0xCEEBB94) },
      @{ @"name":@"閾ｪ逕ｱ蜷域・ 笘・,         @"sub":@"蜷域・蜿ｯ蜷ｦ繧貞ｸｸ譎０K",          @"flag":@(0xCEEBB95) },
      @{ @"name":@"閾ｪ逕ｱ蜷域・ 竭｡",         @"sub":@"遞ｮ鬘槭メ繧ｧ繝・け隗｣髯､",          @"flag":@(0xCEEBB96) },
      @{ @"name":@"閾ｪ逕ｱ蜷域・ 竭｢",         @"sub":@"蜃ｺ逶ｮ繝√ぉ繝・け隗｣髯､",          @"flag":@(0xCEEBB97) },
      @{ @"name":@"蛟埼・2蛟・,           @"sub":@"VIP騾溷ｺｦ縺ｨ蜷檎ｵ瑚ｷｯ",           @"flag":@(0xCEEBB98) },
      @{ @"name":@"蟶ｸ縺ｫ豁ｻ莠｡",           @"sub":@"謨ｵ縺梧ｹｧ縺・◆迸ｬ髢薙↓豸医∴繧・螳滄ｨ鍋噪)", @"flag":@(0xCEEBB99) },
      @{ @"name":@"蜷域・繧ｹ繧ｳ繧｢ ﾃ・",       @"sub":@"蟇ｾ謌ｦ繝｢繝ｼ繝蛾剞螳・,            @"flag":@(0xCEEBB9A) },
      @{ @"name":@"謦・ｴ繧ｹ繧ｳ繧｢ ﾃ・ (1000)", @"sub":@"蜊泌鴨繝ｩ繝ｳ繧ｭ繝ｳ繧ｰ=BAN豕ｨ諢・,     @"flag":@(0xCEEBB9B) },
      @{ @"name":@"謦・ｴ繧ｹ繧ｳ繧｢ ﾃ・ (5000)", @"sub":@"蜊泌鴨繝ｩ繝ｳ繧ｭ繝ｳ繧ｰ=BAN豕ｨ諢・,     @"flag":@(0xCEEBB9C) },
      @{ @"name":@"謦・ｴ繧ｹ繧ｳ繧｢ ﾃ・ (50)",   @"sub":@"蜊泌鴨繝ｩ繝ｳ繧ｭ繝ｳ繧ｰ=BAN豕ｨ諢・,     @"flag":@(0xCEEBB9D) },
      @{ @"name":@"謦・ｴ繧ｹ繧ｳ繧｢ ﾃ・ (500)",  @"sub":@"蜊泌鴨繝ｩ繝ｳ繧ｭ繝ｳ繧ｰ=BAN豕ｨ諢・,     @"flag":@(0xCEEBB9E) },
    ];
}

#pragma mark - 驟崎牡・・andom Dice 2 繝・・繝橸ｼ・static UIColor *PUR(void){ return [UIColor colorWithRed:0.78 green:0.49 blue:1.00 alpha:1]; } // accent邏ｫ
static UIColor *PUR2(void){return [UIColor colorWithRed:0.55 green:0.31 blue:0.85 alpha:1]; }
static UIColor *PINK(void){return [UIColor colorWithRed:1.00 green:0.43 blue:0.78 alpha:1]; }
static UIColor *GOLD(void){return [UIColor colorWithRed:1.00 green:0.84 blue:0.29 alpha:1]; }

// 繝代せ繧ｹ繝ｫ繝ｼWindow・郁レ譎ｯ繧ｿ繝・メ縺ｯ繧ｲ繝ｼ繝縺ｸ・・@interface RD2Window : UIWindow @end
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
    [b setTitle:@"軸" forState:UIControlStateNormal];
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
    NSUInteger maxVisible = 7;                       // 縺薙ｌ莉･荳翫・繧ｹ繧ｯ繝ｭ繝ｼ繝ｫ
    CGFloat rowsH = rowH * list.count;               // 蜈ｨ陦後・鬮倥＆
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
    title.text=@"軸 Random Dice 2"; title.textColor=UIColor.whiteColor; title.font=[UIFont boldSystemFontOfSize:19];
    UILabel *sub=[[UILabel alloc] initWithFrame:CGRectMake(20,40,W-80,18)];
    sub.text=@"MOD MENU  窶｢  縺九ｏ縺・￥謾ｹ騾"; sub.textColor=GOLD(); sub.font=[UIFont systemFontOfSize:11 weight:UIFontWeightSemibold];
    [head addSubview:title]; [head addSubview:sub];
    UIButton *close=[UIButton buttonWithType:UIButtonTypeCustom];
    close.frame=CGRectMake(W-48,18,34,34); [close setTitle:@"笨・ forState:UIControlStateNormal];
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
                    : @"螟ｱ謨・ UnityFramework譛ｪ讀懷・"];
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

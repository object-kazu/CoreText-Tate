//
//  EDTextView.m
//  coretext
//
//  Created by kunii on 2013/11/30.
//  Copyright (c) 2013年 國居貴浩. All rights reserved.
//

//  Core Text Programming Guide
//  https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/CoreText_Programming/Introduction/Introduction.html
#import <CoreText/CoreText.h>
#import "EDTextView.h"

@implementation EDTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //  表示する文字列
    NSString* string = @"503 ご〜おぉまぁ〜り・さん…\nGo marry sun\nゴーマッサーン ご〜おぉまりぃ〜い さ〜ん。\n「エドウィンで検索すると鋼練がでたよ。」ご〜おぉまぁ〜り・さん\n　E○WIN";

    //  CoreTextを使ったテキスト描画

    //  縦書き対応の16ポイントフォント使用
    CTFontRef font = CTFontCreateWithName(CFSTR("HiraKakuProN-W3"), 16, NULL);
    
    //  文字に黄色指定
    UIColor* textColor = [UIColor yellowColor];

    //  段落設定
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;   //  センタリング
    paragraphStyle.minimumLineHeight = 20;              //  行間20ポイント
    
    //  NSAttributedString用の属性を用意
    NSDictionary *attributes = @{
                                 NSFontAttributeName:(__bridge_transfer id)font,
                                 NSForegroundColorAttributeName:textColor,
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 (__bridge id)kCTVerticalFormsAttributeName:@YES
                                 };

    //  属性指定でNSAttributedString作成
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string
                                                                           attributes:attributes];

    //  CTFramesetter用意
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(attributedString));
    
    //  CTFramesetterを使い、文字列を指定した領域（今回はビューの矩形）に配置させたCTFrameを作成する
    
    //  ハートの形のベジェ曲線でCTFrameの枠を指定する
    UIBezierPath* path = self.heart;
    [path applyTransform:CGAffineTransformMakeScale(self.bounds.size.width, self.bounds.size.height) ];
    [[UIColor blueColor] setFill];
    [path fill];
    [path applyTransform:CGAffineTransformMakeTranslation(0, -self.bounds.size.height)];
    [path applyTransform:CGAffineTransformMakeScale(1, -1)];
    //  CTFrameを縦書きに指定する
    NSDictionary* frameAttributes = @{
                                      @"CTFrameProgression": @(kCTFrameProgressionRightToLeft)
                                      };
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                                CFRangeMake(0, 0), path.CGPath, (__bridge CFDictionaryRef)frameAttributes);
    
    //  描画用コンテキスト取り出し
    CGContextRef context = UIGraphicsGetCurrentContext();
    //  座標系の調整　数学で使う上方向にyが増加する座標系にする
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    //  テキスト用のアフィン変換用行列を初期化する
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    //  描画
    CTFrameDraw(frame, context);
    
    //  作成したCTFramesetterとCTFrameの所有権を放棄する
    CFRelease(frame);
    CFRelease(framesetter);
}

//  ハートの形のベジェ曲線作成
- (UIBezierPath*)heart
{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0.25)];
    
    [path addCurveToPoint:CGPointMake(0.5, 0.3)
            controlPoint1:CGPointMake(0.1, 0)
            controlPoint2:CGPointMake(0.5, 0)];
    
    [path addCurveToPoint:CGPointMake(0.0, 0.9)
            controlPoint1:CGPointMake(0.5, 0.75)
            controlPoint2:CGPointMake(0.0, 0.9)];
    
    [path addCurveToPoint:CGPointMake(-0.5, 0.3)
            controlPoint1:CGPointMake(0, 0.9)
            controlPoint2:CGPointMake(-0.5, 0.75)];
    
    [path addCurveToPoint:CGPointMake(0, 0.25)
            controlPoint1:CGPointMake(-0.5, 0)
            controlPoint2:CGPointMake(-0.1, 0)];
    
    [path closePath];
    [path applyTransform:CGAffineTransformMakeTranslation(0.5, 0)];
    return path;
}

@end

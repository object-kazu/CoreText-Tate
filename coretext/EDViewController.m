//
//  EDViewController.m
//  coretext
//
//  Created by kunii on 2013/11/30.
//  Copyright (c) 2013年 國居貴浩. All rights reserved.
//

#import "EDViewController.h"
#import "EDTextView.h"

@interface EDViewController () {
    CGRect _baseFrame;
    CGPoint _center;
    CGSize _firstSize;
    EDTextView* _textview;
}

@end

@implementation EDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    EDTextView* textview = [[EDTextView alloc] initWithFrame:CGRectMake(40, 100, 240, 260)];
    [self.view addSubview:textview];
    
    _textview = textview;
    _baseFrame = textview.frame;
    _center = textview.center;
    UIPanGestureRecognizer* panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pan:(UIPanGestureRecognizer*)panGestureRecognizer
{
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint pt = [panGestureRecognizer locationInView:self.view];
        _firstSize.width = fabs(pt.x - _center.x);
        _firstSize.height = fabs(pt.y - _center.y);
    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint pt = [panGestureRecognizer locationInView:self.view];
        float width = fabs(pt.x - _center.x);
        float height = fabs(pt.y - _center.y);
        CGRect frame = CGRectInset(_baseFrame,
                                   - (width - _firstSize.width),
                                   - (height - _firstSize.height));
        if (frame.size.width < 20)
            return;
        if (frame.size.height < 20)
            return;
        _textview.frame = frame;
        [_textview setNeedsDisplay];        //  再配置
    }
}
@end

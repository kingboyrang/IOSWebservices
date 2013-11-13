//
//  AnimalErrorView.m
//  AnimalDemo
//
//  Created by rang on 13-9-5.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "AnimateErrorView.h"
#import <QuartzCore/QuartzCore.h>
@interface AnimateErrorView (){
    UIImageView *_imageView;
}
-(void)loadControls;
-(void)animalTitle:(NSString*)title;
-(CGSize)CalculateStringSize:(NSString*)text font:(UIFont*)font with:(CGFloat)w;
@end

@implementation AnimateErrorView
@synthesize labelTitle=_labelTitle;
-(void)dealloc{
    [super dealloc];
    [_imageView release],_imageView=nil;
    [_labelTitle removeObserver:self forKeyPath:@"text"];
    [_labelTitle release],_labelTitle=nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadControls];
    }
    return self;
}
-(void)loadControls{
    if (!_imageView) {
        _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 30, 30)];
        [_imageView setImage:[UIImage imageNamed:@"error.png"]];
        [self addSubview:_imageView];
    }
    if (!_labelTitle) {
        NSString *title=@"load failed...";
        CGSize size=[self CalculateStringSize:title font:[UIFont boldSystemFontOfSize:14] with:320.0];
        
        _labelTitle=[[UILabel alloc] initWithFrame:CGRectMake(40,(40-size.height)/2.0, size.width, size.height)];
        _labelTitle.backgroundColor=[UIColor clearColor];
        _labelTitle.textColor=[UIColor whiteColor];
        _labelTitle.font=[UIFont boldSystemFontOfSize:14];
        _labelTitle.text=title;
        
        
        
        [self addSubview:_labelTitle];
        //kvo模式判断内容是否发生改变
        [_labelTitle addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        self.backgroundColor=[UIColor blackColor];
        //self.alpha=0.5;
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=5.0;
    }

}
-(void)layoutSubviews{
    [super layoutSubviews];
    /***
    CGRect screnRect=self.window.bounds;
    CGFloat w=self.labelTitle.frame.size.width+self.labelTitle.frame.origin.x+8;
    CGRect frame=self.frame;
    frame.size.width=w;
    
    CGFloat screenW=screnRect.size.width,screenH=screnRect.size.height;
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)){
        screenW=screnRect.size.height;
        screenH=screnRect.size.width;
    }
    frame.origin.x=0;
    frame.origin.y=-frame.size.height;
    self.frame=frame;
     ***/
}
-(void)setErrorImage:(UIImage*)image{
    CGRect r=_imageView.frame;
    r.size=image.size;
    r.origin.y=(self.bounds.size.height-image.size.height)/2.0;
    _imageView.frame=r;
    [_imageView setImage:image];
    r=_labelTitle.frame;
    r.origin.x=_imageView.frame.origin.x+_imageView.frame.size.width+2;
    _labelTitle.frame=r;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"text"])
    {
        if (![[change objectForKey:@"new"] isEqualToString:[change objectForKey:@"old"]]) {
            [self animalTitle:[change objectForKey:@"new"]];
        }
        
    }
}
#pragma mark private
-(CGSize)CalculateStringSize:(NSString*)text font:(UIFont*)font with:(CGFloat)w{
    CGSize textSize = [text sizeWithFont:font
                       constrainedToSize:CGSizeMake(w, CGFLOAT_MAX)
                           lineBreakMode:NSLineBreakByWordWrapping];
    return textSize;
}
-(void)animalTitle:(NSString*)title{
    if (_labelTitle) {
        CGSize size=[self CalculateStringSize:title font:[UIFont boldSystemFontOfSize:14] with:320.0];
        CGRect frame=_labelTitle.frame;
        frame.size=size;
        _labelTitle.frame=frame;
        _labelTitle.text=title;
        
        //frame=self.frame;
        //frame.size.width=_labelTitle.frame.size.width+_labelTitle.frame.origin.x+8;
        //self.frame=frame;
        
    }
}
@end

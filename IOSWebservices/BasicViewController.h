//
//  BasicViewController.h
//  Wisdom
//
//  Created by aJia on 2013/10/29.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimateLoadView.h"
#import "AnimateErrorView.h"
@interface BasicViewController : UIViewController
//动画操作
-(AnimateErrorView*) errorView;
-(AnimateErrorView*) successView;
-(AnimateLoadView*) loadingView;
-(void) showLoadingAnimatedWithTitle:(NSString*)title;
-(void) showLoadingAnimated:(void (^)(AnimateLoadView *errorView))process;
-(void) hideLoadingViewAnimated:(void (^)(AnimateLoadView *hideView))complete;

-(void) showErrorViewAnimated:(void (^)(AnimateErrorView *errorView))process;
-(void) hideErrorViewAnimatedWithDuration:(NSTimeInterval)duration completed:(void (^)(AnimateErrorView *errorView))complete;
-(void) hideErrorViewAnimated:(void (^)(AnimateErrorView *errorView))complete;
-(void) showErrorViewWithHide:(void (^)(AnimateErrorView *errorView))process completed:(void (^)(AnimateErrorView *errorView))complete;
-(void) hideLoadingFailedWithTitle:(NSString*)title completed:(void (^)(AnimateErrorView *errorView))complete;

-(void) showSuccessViewAnimated:(void (^)(AnimateErrorView *errorView))process;
-(void) hideSuccessViewAnimated:(void (^)(AnimateErrorView *errorView))complete;
-(void) showSuccessViewWithHide:(void (^)(AnimateErrorView *errorView))process completed:(void (^)(AnimateErrorView *errorView))complete;
-(void) hideLoadingSuccessWithTitle:(NSString*)title completed:(void (^)(AnimateErrorView *errorView))complete;

@end

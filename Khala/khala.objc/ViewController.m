//
//  ViewController.m
//  khala.objc
//
//  Created by linhey on 2018/11/19.
//  Copyright © 2018 www.linhey.com. All rights reserved.
//

#import "ViewController.h"
#import <Khala/Khala.h>
#import <Khala-umbrella.h>

@implementation ViewController

- (IBAction)tapEvent:(NSClickGestureRecognizer *)sender {

  RewriteFilter * filter = [[RewriteFilter alloc] init:^URLValue * _Nonnull(URLValue * value) {
    return value;
  }];
  Rewrite.shared.filters = @[filter];
  
  Khala* khala = [[Khala alloc] initWithUrl: [NSURL URLWithString:@"kl://SwiftClass/double?test=666"] params:@{}];
  id value = [khala call];
  NSLog(@"%@",value);
  
  KhalaNotify* notify = [[KhalaNotify alloc] initWithStr:@"kl://double?test=666" params:@{}];
  value = [notify call];
  NSLog(@"%@",value);
}

@end

//
//  IGViewController.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import "IGViewController.h"

#import "IGHTMLQuery.h"

@interface IGViewController ()

@end

@implementation IGViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    IGHTMLDocument* doc = [[IGHTMLDocument alloc] initWithHTMLString:@"<html><p>Hello World</p></html>" error:nil];
    NSString* content = [[[doc queryWithXPath:@"//p"] firstObject] text];
    NSLog(@"content from Objective-C = %@", content);
    
    JSContext *context = [[JSContext alloc] init];
    context[@"doc"] = doc;
    JSValue* output = [context evaluateScript:@"doc.queryWithXPath('//p').firstObject().text()"];
    NSLog(@"content from JavaScript = %@", [output toString]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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

    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"begin loop");
        for (int i=0 ; i< 1000; i++) {
            @autoreleasepool {
                IGHTMLDocument* doc = [[IGHTMLDocument alloc] initWithHTMLString:@"<html><p>Hello World</p></html>" error:nil];
                NSString* content = [[[doc queryWithXPath:@"//p"] firstObject] text];
                NSLog(@"content from Objective-C = %@", content);
                
                JSVirtualMachine* vm = [[JSVirtualMachine alloc] init];
                JSContext *context = [[JSContext alloc] initWithVirtualMachine:vm];
                context[@"doc"] = doc;

                JSValue* output = [context evaluateScript:@"doc.queryWithXPath('//p').first"];
                NSLog(@"content from JavaScript = %@", [output toString]);
            }
        }
        NSLog(@"end loop");
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

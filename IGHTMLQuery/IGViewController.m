//
//  IGViewController.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "IGViewController.h"
#import "IGHTMLQuery.h"

@interface IGViewController ()

@end

@implementation IGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    for (int i=0; i < 10; i++) {
        @autoreleasepool {
            IGHTMLDocument* doc = [[IGHTMLDocument alloc] initWithHTMLString:@"<html><p>Hello World</p></html>" error:nil];
//
//            doc.query(@"p")
//                .firstObject
//                .append([NSString stringWithFormat:@"<div><span>%d</span></div>", i])
//                .before(@"<a>opps</a>");
//            doc.query(@"p")
//                .firstObject
//                .prepend([NSString stringWithFormat:@"<div><p>%d</p></div>", i])
//                .after(@"<a>woo</a>");
//            [doc.query(@"a") remove];
//            [doc.query(@"p").firstObject empty];
//            [doc.query(@"p").firstObject remove];
//            [doc.query(@"p").firstObject remove];
//            [doc.query(@"p").firstObject remove];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

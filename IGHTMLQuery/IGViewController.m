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
    
    IGHTMLDocument* doc = [[IGHTMLDocument alloc] initWithHTMLString:@"<html><p>Hello World</p></html>" error:nil];
    NSLog(@"doc = %@", doc.xml);
    for (int i=0; i < 100; i++) {
        doc.query(@"p")
            .firstObject
            .append([NSString stringWithFormat:@"<p>%d</p>", i])
            .before(@"<a>opps</a>");
    }
    NSLog(@"doc = %@", doc.xml);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

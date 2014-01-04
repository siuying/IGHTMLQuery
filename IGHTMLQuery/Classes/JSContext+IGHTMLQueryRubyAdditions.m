//
//  JSContext+IGHTMLQueryRubyAdditions.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 12/31/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "JSContext+IGHTMLQueryRubyAdditions.h"
#import "JSContext+OpalAdditions.h"
#import "IGXMLNode.h"
#import "IGHTMLDocument.h"

@implementation JSContext (IGHTMLQueryRubyAdditions)

-(void) configureIGHTMLQuery {
    [self loadOpal];

    NSString* filename = [[NSBundle bundleForClass:[IGXMLNode class]] pathForResource:@"html_query" ofType:@"js"];
    NSString* script = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
    NSAssert(script != nil, @"html_query.js not loaded");
    [self evaluateScript:script];
    
    self[@"IGHTMLDocument"] = ^IGHTMLDocument*(NSString* html) {
        NSError* error;
        IGHTMLDocument* doc = [[IGHTMLDocument alloc] initWithHTMLString:html error:&error];
        if (error) {
            NSLog(@"[IGHTMLQuery][Warning] failed create document: %@", error);
        }
        return doc;
    };
}

@end

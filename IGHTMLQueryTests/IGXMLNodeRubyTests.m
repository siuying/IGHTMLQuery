//
//  IGXMLNodeRubyTests.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 12/25/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IGHTMLQuery.h"

#import <JavaScriptCore/JavaScriptCore.h>
#import "JSContext+OpalAdditions.h"

@interface IGXMLNodeRubyTests : XCTestCase{
    IGXMLDocument* doc;
    JSContext* context;
    NSString* script;
}

@end

@implementation IGXMLNodeRubyTests

- (void)setUp
{
    [super setUp];

    doc = [[IGXMLDocument alloc] initWithXMLResource:@"catalog" ofType:@"xml" encoding:@"utf8" error:nil];
    context = [[JSContext alloc] init];
    context[@"doc"] = doc;
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testRubyScript
{
    NSString* scriptFilename = [[NSBundle bundleForClass:[self class]] pathForResource:@"xml_node" ofType:@"rb"];
    script = [NSString stringWithContentsOfFile:scriptFilename encoding:NSUTF8StringEncoding error:nil];
    [context evaluateRuby:script];
    XCTAssertNil(context.exception, @"should not return error");

    [[context evaluateRuby:@"node = XMLNode.new(%{doc})"] toString];
    NSString* output = [[context evaluateRuby:@"tag = node.tag"] toString];
    XCTAssertEqualObjects(@"catalog", output, @"should be catalog");

    output = [[context evaluateRuby:@"tag = XMLNode.new(%{doc}).tag"] toString];
    XCTAssertEqualObjects(@"catalog", output, @"should be catalog");
}

@end

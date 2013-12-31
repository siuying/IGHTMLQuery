//
//  IGRubyTests.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 12/26/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "IGHTMLQuery.h"
#import "IGHTMLQueryJavaScriptExport.h"
#import "JSContext+OpalAdditions.h"

@interface IGRubyTests : XCTestCase
{
    IGXMLDocument* doc;
    JSContext* context;
}
@end

@implementation IGRubyTests

- (void)setUp
{
    [super setUp];
    doc = [[IGXMLDocument alloc] initWithXMLResource:@"catalog" ofType:@"xml" encoding:@"utf8" error:nil];
    context = [[JSContext alloc] init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testNode
{
    NSString* filename = [[NSBundle bundleForClass:[self class]] pathForResource:@"xml_node" ofType:@"rb"];
    NSString* script = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
    JSValue* value = [context evaluateRuby:script];
    XCTAssertFalse([value isUndefined], @"should not be undefined");

    filename = [[NSBundle bundleForClass:[self class]] pathForResource:@"xml_node_set" ofType:@"rb"];
    script = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
    value = [context evaluateRuby:script];
    
    context[@"doc"] = doc;
    
    JSValue* block = [context evaluateRuby:@"lambda { |doc, script| XMLNode.new(doc).instance_eval(&eval(\"lambda { #{script} }\")) }"];
    JSValue* node = [block callWithArguments:@[doc, @"self.tag"]];
    XCTAssertEqualObjects(@"catalog", [node toString], @"should be catalog");
    
}

- (void)testNodeSet
{
    NSString* filename = [[NSBundle bundleForClass:[self class]] pathForResource:@"xml_node" ofType:@"rb"];
    NSString* script = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
    JSValue* value = [context evaluateRuby:script];
    XCTAssertFalse([value isUndefined], @"should not be undefined");
    
    filename = [[NSBundle bundleForClass:[self class]] pathForResource:@"xml_node_set" ofType:@"rb"];
    script = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
    value = [context evaluateRuby:script];
    
    context[@"doc"] = doc;
    JSValue* block = [context evaluateRuby:@"lambda { |doc, script| XMLNode.new(doc).instance_eval(&eval(\"lambda { #{script} }\")) }"];
    JSValue* node = [block callWithArguments:@[doc, @"first = self.children.all.first; first.tag"]];
    XCTAssertEqualObjects(@"cd", [node toString], @"should be cd");
    
}


@end

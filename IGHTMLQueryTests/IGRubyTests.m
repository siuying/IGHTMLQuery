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
    
    // Load scripts
    NSString* filename = [[NSBundle bundleForClass:[self class]] pathForResource:@"xml_node" ofType:@"rb"];
    NSString* script = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
    JSValue* value = [context evaluateRuby:script];
    filename = [[NSBundle bundleForClass:[self class]] pathForResource:@"xml_node_set" ofType:@"rb"];
    script = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
    value = [context evaluateRuby:script];
    
    // setup context
    context[@"doc"] = doc;
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testNodeCore
{
    JSValue* block = [context evaluateRuby:@"lambda { |doc, script| XMLNode.new(doc).instance_eval(&eval(\"lambda { #{script} }\")) }"];
    JSValue* node = [block callWithArguments:@[doc, @"self.tag"]];
    XCTAssertEqualObjects(@"catalog", [node toString], @"should be catalog");
}

- (void)testNodeAttribute
{
    JSValue* block = [context evaluateRuby:@"lambda { |doc, script| XMLNode.new(doc).instance_eval(&eval(\"lambda { #{script} }\")) }"];
    JSValue* node = [block callWithArguments:@[doc, @"self.children.first['country'] = 'Hong Kong'; self.children.first['country'] "]];\
    XCTAssertEqualObjects(@"Hong Kong", [node toString], @"should be Hong Kong");
}

- (void)testNodeQuery
{
    JSValue* block = [context evaluateRuby:@"lambda { |doc, script| XMLNode.new(doc).instance_eval(&eval(\"lambda { #{script} }\")) }"];
    JSValue* node = [block callWithArguments:@[doc, @"self.xpath('//cd/price').first.text.to_f"]];
    XCTAssertEqualWithAccuracy(10.9, [[node toNumber] doubleValue], 0.001, @"should find first price");
}

- (void)testNodeManipulationRemove
{
    JSValue* block = [context evaluateRuby:@"lambda { |doc, script| XMLNode.new(doc).instance_eval(&eval(\"lambda { #{script} }\")) }"];
    JSValue* node = [block callWithArguments:@[doc, @"self.xpath('//cd').each {|n| n.remove }; self.xpath('//cd').nodes "]];
    XCTAssertEqual(0U, [[node toArray] count], @"should remove cds");
}

- (void)testNodeManipulationEmpty
{
    JSValue* block = [context evaluateRuby:@"lambda { |doc, script| XMLNode.new(doc).instance_eval(&eval(\"lambda { #{script} }\")) }"];
    JSValue* node = [block callWithArguments:@[doc, @"self.empty; self.xml"]];
    XCTAssertEqualObjects(@"<catalog/>", [node toString], @"should empty xml");
}

- (void)testNodeSet
{
    JSValue* block = [context evaluateRuby:@"lambda { |doc, script| XMLNode.new(doc).instance_eval(&eval(\"lambda { #{script} }\")) }"];
    JSValue* node = [block callWithArguments:@[doc, @"first = self.children.all.first; first.tag"]];
    XCTAssertEqualObjects(@"cd", [node toString], @"should be cd");
    
}

- (void)testNodeSetManipulation
{
    JSValue* block = [context evaluateRuby:@"lambda { |doc, script| XMLNode.new(doc).instance_eval(&eval(\"lambda { #{script} }\")) }"];
    JSValue* node = [block callWithArguments:@[doc, @"self.xpath('//cd').remove; self.xpath('//cd').nodes "]];
    XCTAssertEqual(0U, [[node toArray] count], @"should remove cds");
}

- (void)testNodeSetEnumerable
{
    JSValue* block = [context evaluateRuby:@"lambda { |doc, script| XMLNode.new(doc).instance_eval(&eval(\"lambda { #{script} }\")) }"];
    JSValue* node = [block callWithArguments:@[doc, @"self.xpath('//cd').find {|node| node.xpath('./price').text.to_f < 9.0 }.xpath('./title').text"]];
    NSString* title = [node toString];
    XCTAssertEqualObjects((@"Greatest Hits"), title, @"title should be nil");
}

@end

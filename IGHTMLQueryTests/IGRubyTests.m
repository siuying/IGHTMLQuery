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
#import "JSContext+IGHTMLQueryRubyAdditions.h"

@interface IGRubyTests : XCTestCase
{
    IGXMLDocument* doc;
    JSContext* context;
    JSValue* instanceEval;
}
@end

@implementation IGRubyTests

- (void)setUp
{
    [super setUp];
    doc = [[IGXMLDocument alloc] initWithXMLResource:@"catalog" ofType:@"xml" encoding:@"utf8" error:nil];
    context = [[JSContext alloc] init];
    [context configureIGHTMLQuery];

    // setup context
    context[@"doc"] = doc;
    
    // instance_eval on a doc
    instanceEval = [context evaluateRuby:@"lambda { |doc, script| XMLNode.new(doc).instance_eval(&eval(\"lambda { #{script} }\")) }"];
}

- (void)testNodeCore
{
    JSValue* node = [instanceEval callWithArguments:@[doc, @"self.tag"]];
    XCTAssertEqualObjects(@"catalog", [node toString], @"should be catalog");
}

- (void)testNodeAttribute
{
    JSValue* node = [instanceEval callWithArguments:@[doc, @"self.children.first['country'] = 'Hong Kong'; self.children.first['country'] "]];\
    XCTAssertEqualObjects(@"Hong Kong", [node toString], @"should be Hong Kong");

    node = [instanceEval callWithArguments:@[doc, @"self.children.first['abc'].nil?"]];\
    XCTAssertEqualObjects(@YES, [node toNumber], @"non existing attribute should return nil");
}

- (void)testNodeQuery
{
    JSValue* node = [instanceEval callWithArguments:@[doc, @"self.xpath('//cd/price').first.text.to_f"]];
    XCTAssertEqualWithAccuracy(10.9, [[node toNumber] doubleValue], 0.001, @"should find first price");
}

- (void)testNodeCSSQuery
{
    JSValue* node = [instanceEval callWithArguments:@[doc, @"self.css('cd > price').first.text.to_f"]];
    XCTAssertEqualWithAccuracy(10.9, [[node toNumber] doubleValue], 0.001, @"should find first price");
    
    node = [instanceEval callWithArguments:@[doc, @"self.css('cd[country=\"UK\"] price').text.to_f"]];
    XCTAssertEqualWithAccuracy(9.9, [[node toNumber] doubleValue], 0.001, @"should find first price");
}

- (void)testNodeManipulationRemove
{
    JSValue* node = [instanceEval callWithArguments:@[doc, @"self.xpath('//cd').each {|n| n.remove }; self.xpath('//cd').nodes "]];
    XCTAssertEqual(0U, [[node toArray] count], @"should remove cds");
}

- (void)testNodeManipulationEmpty
{
    JSValue* node = [instanceEval callWithArguments:@[doc, @"self.empty; self.xml"]];
    XCTAssertEqualObjects(@"<catalog/>", [node toString], @"should empty xml");
}

- (void)testNodeToNative
{
    JSValue* node = [instanceEval callWithArguments:@[doc, @"self.to_n"]];
    IGXMLNode* nodeNative = [node toObject];
    XCTAssertNotNil(nodeNative, @"should be a node");
    XCTAssertTrue([nodeNative isKindOfClass:[IGXMLNode class]], @"should be a node");
    XCTAssertEqualObjects(@"catalog", nodeNative.tag, @"should be a catalog");
}

#pragma mark - Node Set

- (void)testNodeSet
{
    JSValue* node = [instanceEval callWithArguments:@[doc, @"first = self.children.all.first; first.tag"]];
    XCTAssertEqualObjects(@"cd", [node toString], @"should be cd");
    
}

- (void)testNodeSetManipulation
{
    JSValue* node = [instanceEval callWithArguments:@[doc, @"self.xpath('//cd').remove; self.xpath('//cd').nodes "]];
    XCTAssertEqual(0U, [[node toArray] count], @"should remove cds");
}

- (void)testNodeSetEnumerable
{
    JSValue* node = [instanceEval callWithArguments:@[doc, @"self.xpath('//cd').find {|node| node.xpath('./price').text.to_f < 9.0 }.xpath('./title').text"]];
    NSString* title = [node toString];
    XCTAssertEqualObjects((@"Greatest Hits"), title, @"title should be Greatest Hits");
}

- (void)testNodeSetToNative
{
    JSValue* node = [instanceEval callWithArguments:@[doc, @"self.xpath('//cd').to_n"]];
    IGXMLNodeSet* titleNodeSet = [node toObject];
    XCTAssertNotNil(titleNodeSet, @"should be a node set");
    XCTAssertEqualObjects([titleNodeSet class], [IGXMLNodeSet class], @"should be a NodeSet");
    XCTAssertEqual(3U, [titleNodeSet count], @"should have 3 nodes in set");
}

#pragma mark - Traversal

- (void)testParent
{
    JSValue* node = [instanceEval callWithArguments:@[doc, @"self.xpath('//cd').first.parent.tag"]];
    NSString* tag = [node toString];
    XCTAssertEqualObjects(tag, @"catalog", @"should be catalog");
}

- (void)testNoParent
{
    JSValue* node = [instanceEval callWithArguments:@[doc, @"self.xpath('//catalog').first.parent.parent.nil?"]];
    XCTAssertEqualObjects(@YES, [node toNumber], @"non existing parent return nil");
}

- (void)testChildrenAndFirstChild
{
    JSValue* node = [instanceEval callWithArguments:@[doc, @"self.xpath('//cd').first.children.first.tag"]];
    XCTAssertEqualObjects(@"title", [node toString], @"should be title");
    
    node = [instanceEval callWithArguments:@[doc, @"self.xpath('//cd').first.first_child.tag"]];
    XCTAssertEqualObjects(@"title", [node toString], @"should be title");
}

- (void)testNoChildren
{
    JSValue* node = [instanceEval callWithArguments:@[doc, @"self.xpath('//cd').first.first_child.nil?"]];
    XCTAssertEqualObjects(@NO, [node toNumber], @"should not be nil");

    node = [instanceEval callWithArguments:@[doc, @"self.xpath('//cd').first.first_child.first_child.nil?"]];
    XCTAssertEqualObjects(@YES, [node toNumber], @"should be nil");
}

- (void)testNextAndPreviousSibling
{
    IGXMLNode* ukCd = [[doc queryWithXPath:@"cd[@country='UK']"] firstObject];
    
    XCTAssertEqualObjects([ukCd.previousSibling queryWithXPath:@"price"].firstObject.text, @"10.90");
    XCTAssertEqualObjects([ukCd.nextSibling queryWithXPath:@"price"].firstObject.text, @"8.90");
    
    JSValue* node = [instanceEval callWithArguments:@[doc, @"self.xpath('//cd[@country=\"UK\"]').first.previous_sibling.xpath('price').first.text"]];
    XCTAssertEqualObjects(@"10.90", [node toString], @"should not be nil");

    node = [instanceEval callWithArguments:@[doc, @"self.xpath('//cd[@country=\"UK\"]').first.next_sibling.xpath('price').first.text"]];
    XCTAssertEqualObjects(@"8.90", [node toString], @"should not be nil");
}

#pragma mark - Others

- (void) testHTMLDoc {
    JSValue* h1 = [context evaluateRuby:@"HTMLDoc.new('<html><body><h1>Header</h1><div id=\"content\"><span>Hello</span></div></body></html>').xpath('//h1').first.text"];
    XCTAssertEqualObjects(@"Header", [h1 toString], @"should return a doc based on input and can be queried");
    
    h1 = [context evaluateRuby:@"HTMLDoc.new('<html><body><h1>Header</h1><div id=\"content\"><span>Hello</span></div></body></html>').css('h1').first.text"];
    XCTAssertEqualObjects(@"Header", [h1 toString], @"should return a doc based on input and can be queried");
    
}

-(void) testHTTPGet {
    JSValue* oldGet = context[@"HTTPGet"];
    context[@"HTTPGet"] = ^NSString*(NSString* url){ return @"HELLO"; };
    NSString* wiki = [[context evaluateRuby:@"IGHTMLQuery::HTTP.get('http://www.wikipedia.org')"] toString];
    XCTAssertEqualObjects(wiki, @"HELLO", @"should return with HTTPGet method");
    context[@"HTTPGet"] = oldGet;
}

@end

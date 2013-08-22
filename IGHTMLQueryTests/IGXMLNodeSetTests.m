//
//  IGXMLNodeSet.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IGXMLNodeSet.h"
#import "IGXMLDocument.h"

@interface IGXMLNodeSetTests : XCTestCase {
    IGXMLDocument* doc;
}

@end

@implementation IGXMLNodeSetTests

- (void)setUp
{
    [super setUp];
    
    doc = [[IGXMLDocument alloc] initWithXMLResource:@"catalog" ofType:@"xml" encoding:@"utf8" error:nil];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testBasicNodeMethods
{
    IGXMLNodeSet* nodeSet = [doc children];
    IGXMLNode* firstChild = [nodeSet firstObject];
    XCTAssertEqualObjects(firstChild.tag, @"cd");
    
    XCTAssertTrue([nodeSet count] == 3, @"should have 3 nodes");
    
    NSArray* nodes = [nodeSet allObjects];
    XCTAssertTrue([nodes isKindOfClass:[NSArray class]], @"should be an array");
    XCTAssertTrue([[nodes firstObject] isKindOfClass:[IGXMLNode class]], @"should be a node");
    XCTAssertTrue([nodes count] == 3, @"should have 3 objects");
    XCTAssertEqualObjects(nodes[0], [nodeSet firstObject]);
    XCTAssertEqualObjects(nodes[0], nodeSet[0]);
}

- (void)testXPathQuery
{
    IGXMLNodeSet* cds = [doc queryWithXPath:@"//cd"];
    IGXMLNodeSet* titles = [cds queryWithXPath:@"./title"];
    IGXMLNode* title = titles[0];
    XCTAssertEqualObjects(title.text, @"Empire Burlesque");

    NSArray* artists = @[@"Bob Dylan", @"Bonnie Tyler", @"Dolly Parton"];
    [[doc queryWithXPath:@"//title"] enumerateNodesUsingBlock:^(IGXMLNode *node, NSUInteger idx, BOOL *stop) {
        XCTAssertTrue((NSInteger)[artists indexOfObject:node.text] > -1, @"should be valid artist");
    }];
}

- (void)testXPathShorthand
{
    XCTAssertEqualObjects(doc.query(@"//cd/title").firstObject.text, @"Empire Burlesque");

    NSArray* artists = @[@"Bob Dylan", @"Bonnie Tyler", @"Dolly Parton"];
    doc.query(@"//cd/artist").each(^(IGXMLNode* node){
        XCTAssertTrue((NSInteger)[artists indexOfObject:node.text] > -1, @"should be valid artist");
    });
}

- (void)testRemove {
    [doc.query(@"//cd") remove];
    XCTAssertEqualObjects(@"<catalog/>", doc.xml);
}

- (void)testEmpty {
    [doc.query(@"//cd") empty];
    XCTAssertEqualObjects(@"<catalog><cd country=\"USA\"/><cd country=\"UK\"/><cd country=\"USA\"/></catalog>", doc.xml);
}

- (void)testAppend {
    IGXMLNode* node = [[IGXMLDocument alloc] initWithXMLString:@"<test/>" error:nil];
    [doc.query(@"//cd/title") appendWithNode:node];
    XCTAssertEqualObjects(doc.query(@"//cd/title").firstObject.innerXml, @"Empire Burlesque<test/>");
}

- (void)testAppendShorthand {
    doc.query(@"//cd/title").append(@"<test/>");
    XCTAssertEqualObjects(doc.query(@"//cd/title").firstObject.innerXml, @"Empire Burlesque<test/>");
}

- (void)testPrepend {
    [doc.query(@"//cd/title") prependWithNode:[[IGXMLDocument alloc] initWithXMLString:@"<test/>" error:nil]];
    XCTAssertEqualObjects(doc.query(@"//cd/title").firstObject.innerXml, @"<test/>Empire Burlesque");
}

- (void)testPrependShorthand {
    doc.query(@"//cd/title").prepend(@"<test/>");
    XCTAssertEqualObjects(doc.query(@"//cd/title").firstObject.innerXml, @"<test/>Empire Burlesque");
}

- (void)testAddNextSibling {
    doc = [[IGXMLDocument alloc] initWithXMLString:@"<div><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>" error:nil];
    
    [doc.query(@"//*[@class='inner']") addNextSiblingWithNode:[[IGXMLDocument alloc] initWithXMLString:@"<p>Test</p>" error:nil]];
    XCTAssertEqualObjects(doc.innerXml,
                          @"<h2>Greetings</h2><div class=\"inner\">Hello</div><p>Test</p><div class=\"inner\">World</div><p>Test</p>");
}

- (void)testAfter {
    doc = [[IGXMLDocument alloc] initWithXMLString:@"<div><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>" error:nil];
    
    doc.query(@"//*[@class='inner']").after(@"<p>Test</p>");
    
    XCTAssertEqualObjects(doc.innerXml,
                          @"<h2>Greetings</h2><div class=\"inner\">Hello</div><p>Test</p><div class=\"inner\">World</div><p>Test</p>");
}

- (void)testPreviousNextSibling {
    doc = [[IGXMLDocument alloc] initWithXMLString:@"<div><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>" error:nil];
    
    [doc.query(@"//*[@class='inner']") addPreviousSiblingWithNode:[[IGXMLDocument alloc] initWithXMLString:@"<p>Test</p>" error:nil]];
    XCTAssertEqualObjects(doc.innerXml,
                          @"<h2>Greetings</h2><p>Test</p><div class=\"inner\">Hello</div><p>Test</p><div class=\"inner\">World</div>");
}

- (void)testBefore {
    doc = [[IGXMLDocument alloc] initWithXMLString:@"<div><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>" error:nil];
    
    doc.query(@"//*[@class='inner']").before(@"<p>Test</p>");
    XCTAssertEqualObjects(doc.innerXml,
                          @"<h2>Greetings</h2><p>Test</p><div class=\"inner\">Hello</div><p>Test</p><div class=\"inner\">World</div>");
}

- (void)testIsEuqal {
    IGXMLNodeSet* node1a = doc.query(@"cd");
    IGXMLNodeSet* node1b = doc.query(@"cd");
    XCTAssertEqualObjects(node1a, node1b);
    XCTAssertEqual([node1a hash], [node1b hash]);
}

@end

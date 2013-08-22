//
//  IGHTMLDocumentTests.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 21/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IGHTMLDocument.h"

@interface IGHTMLDocumentTests : XCTestCase {
    IGHTMLDocument* doc;
}

@end

@implementation IGHTMLDocumentTests

- (void)setUp
{
    [super setUp];
    doc = [[IGHTMLDocument alloc] initWithHTMLResource:@"sample" ofType:@"html" encoding:@"utf8" error:nil];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testHtmlDocumentXPathQuery
{
    XCTAssertNotNil(doc);

    NSString* title = [doc queryWithXPath:@"//title"].firstObject.text;
    XCTAssertEqualObjects(title, @"Sample \"Hello, World\" Application");
    
    NSArray* validLinks = @[@"about.html", @"hello.html"];
    [[doc queryWithXPath:@"//ul/li/a"] enumerateNodesUsingBlock:^(IGXMLNode *link, NSUInteger idx, BOOL *stop) {
        XCTAssertTrue((NSInteger)[validLinks indexOfObject:link[@"href"]] > -1, @"should be valid link");
    }];
}

- (void) testInnerHtml {
    IGHTMLDocument* myDoc = [[IGHTMLDocument alloc] initWithXMLString:@"<html><body><h1>Header</h1><div id=\"content\"><span>Hello</span></div></body></html>" error:nil];
    IGXMLNode* content = [myDoc queryWithXPath:@"//div[@id='content']"].firstObject;
    XCTAssertEqualObjects(content.innerXml, @"<span>Hello</span>");
    XCTAssertEqualObjects(content.xml, @"<div id=\"content\"><span>Hello</span></div>");
}

- (void)testAppendShorthand {
    doc = [[IGHTMLDocument alloc] initWithHTMLString:@"<div><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>" error:nil];
    
    doc.query(@"//div[@class='inner']").each(^(IGXMLNode* cd){
        cd.append(@"<img/>");
    });
    XCTAssertEqualObjects(doc.query(@"//div[@class='inner']").firstObject.innerXml, @"Hello<img/>");
}

- (void)testPrependShorthand {
    doc = [[IGHTMLDocument alloc] initWithHTMLString:@"<div><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>" error:nil];
    
    doc.query(@"//div[@class='inner']").each(^(IGXMLNode* cd){
        cd.prepend(@"<img/>");
    });
    XCTAssertEqualObjects(doc.query(@"//div[@class='inner']").firstObject.innerXml, @"<img/>Hello");
}

- (void)testAfter {
    doc = [[IGHTMLDocument alloc] initWithHTMLString:@"<div><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>" error:nil];
    
    doc.query(@"//*[@class='inner']").each(^(IGXMLNode* node){
        node.after(@"<p>Test</p>");
    });
    
    XCTAssertEqualObjects(doc.innerXml,
                          @"<h2>Greetings</h2><div class=\"inner\">Hello</div><p>Test</p><div class=\"inner\">World</div><p>Test</p>");
}

- (void)testBefore {
    doc = [[IGHTMLDocument alloc] initWithHTMLString:@"<div><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>"  error:nil];

    doc.query(@"//*[@class='inner']").each(^(IGXMLNode* node){
        node.before(@"<p>Test</p>");
    });
    
    XCTAssertEqualObjects(doc.innerXml,
                          @"<h2>Greetings</h2><p>Test</p><div class=\"inner\">Hello</div><p>Test</p><div class=\"inner\">World</div>");
}

- (void)testAfterShorthand {
    doc = [[IGHTMLDocument alloc] initWithHTMLString:@"<div><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>" error:nil];
    
    doc.query(@"//*[@class='inner']").after(@"<p>Test</p>");
    XCTAssertEqualObjects(doc.innerXml,
                          @"<h2>Greetings</h2><div class=\"inner\">Hello</div><p>Test</p><div class=\"inner\">World</div><p>Test</p>");
}

- (void)testBeforeShorthand {
    doc = [[IGHTMLDocument alloc] initWithHTMLString:@"<div><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>" error:nil];
    
    doc.query(@"//*[@class='inner']").before(@"<p>Test</p>");    
    XCTAssertEqualObjects(doc.innerXml,
                          @"<h2>Greetings</h2><p>Test</p><div class=\"inner\">Hello</div><p>Test</p><div class=\"inner\">World</div>");
}

- (void)testHtmlFragment
{
    doc = [[IGHTMLDocument alloc] initWithHTMLString:@"<div>Hello</div>" error:nil];
    XCTAssertNotNil(doc);
    XCTAssertEqualObjects(@"<div>Hello</div>", doc.xml);
    XCTAssertNil(doc.parent.parent);
    XCTAssertNil(doc.firstChild);
}

@end

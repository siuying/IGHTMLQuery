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

- (void)testAppend {
    doc = [[IGHTMLDocument alloc] initWithHTMLString:@"<div><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>" error:nil];
    [[doc queryWithXPath:@"//div[@class='inner']"] enumerateNodesUsingBlock:^(IGXMLNode *node, NSUInteger idx, BOOL *stop) {
        [node appendWithXMLString:@"<img/>"];
    }];
    XCTAssertEqualObjects([doc queryWithXPath:@"//div[@class='inner']"].firstObject.innerXml, @"Hello<img/>");
}

- (void)testPrepend {
    doc = [[IGHTMLDocument alloc] initWithHTMLString:@"<div><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>" error:nil];
    [[doc queryWithXPath:@"//div[@class='inner']"] enumerateNodesUsingBlock:^(IGXMLNode *node, NSUInteger idx, BOOL *stop) {
        [node prependWithXMLString:@"<img/>"];
    }];
    XCTAssertEqualObjects([doc queryWithXPath:@"//div[@class='inner']"].firstObject.innerXml, @"<img/>Hello");
}

- (void)testAfterShorthand {
    doc = [[IGHTMLDocument alloc] initWithHTMLString:@"<div id=\"root\"><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>" error:nil];
    [[doc queryWithCSS:@".inner"] addNextSiblingWithXMLString:@"<p>Test</p>"];
    XCTAssertEqualObjects([[[doc queryWithCSS:@"#root"] firstObject] innerXml], @"<h2>Greetings</h2><div class=\"inner\">Hello</div><p>Test</p><div class=\"inner\">World</div><p>Test</p>");
}

- (void)testBeforeShorthand {
    doc = [[IGHTMLDocument alloc] initWithHTMLString:@"<div id=\"root\"><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>" error:nil];
    [[doc queryWithCSS:@".inner"] addPreviousSiblingWithXMLString:@"<p>Test</p>"];
    XCTAssertEqualObjects([[[doc queryWithCSS:@"#root"] firstObject] innerXml], @"<h2>Greetings</h2><p>Test</p><div class=\"inner\">Hello</div><p>Test</p><div class=\"inner\">World</div>");
}

- (void)testHtmlFragment
{
    doc = [[IGHTMLDocument alloc] initWithHTMLFragmentString:@"<div>Hello</div>" error:nil];
    XCTAssertNotNil(doc);
    XCTAssertEqualObjects(@"<div>Hello</div>", [doc xml]);
    
    doc = [[IGHTMLDocument alloc] initWithHTMLString:@"<div>Hello</div>" error:nil];
    XCTAssertNotNil(doc);
    XCTAssertEqualObjects(@"<html><body><div>Hello</div></body></html>", [doc xml]);    
}

- (void)testHtmlFragment2
{
    NSError* error;
    doc = [[IGHTMLDocument alloc] initWithHTMLResource:@"cleaned_news" ofType:@"html" encoding:@"utf8" error:&error];
    XCTAssertNotNil(doc);
    if (error) {
        NSLog(@"error = %@", error);
    }
    
    IGXMLNode *h1 = [[doc queryWithXPath:@"//h1"] firstObject];
    NSString* h1Text = [h1 text];
    XCTAssertEqualObjects(h1Text, @"為迎習近平 南鑼鼓巷商舖拆招牌", @"should found the h1");
}


- (void)testHtmlAndInnerHTML
{
    NSError* error;
    doc = [[IGHTMLDocument alloc] initWithHTMLString:@"<html><body><p></p><div>Hi!<a></a></div></body></html>" error:&error];
    XCTAssertNotNil(doc);
    if (error) {
        NSLog(@"error = %@", error);
    }
    
    NSString* html = [[[doc queryWithXPath:@"//p"] firstObject] html];
    XCTAssertEqualObjects([html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], @"<p></p>", @"should keep empty tag");
    
    html = [[[doc queryWithXPath:@"//div"] firstObject] innerHtml];
    XCTAssertEqualObjects([html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], @"Hi!<a></a>", @"should keep empty tag");
}

- (void)testCopyDoc {
    IGHTMLDocument* docCopy1;
    IGHTMLDocument* docCopy2;
    
    // get copies of the doc.
    docCopy1 = [doc copy];
    docCopy2 = [docCopy1 copy];
    doc = nil;
    
    XCTAssertEqualObjects([docCopy1 xml], [docCopy2 xml]);
}

@end

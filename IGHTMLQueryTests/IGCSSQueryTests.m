//
//  IGCSSQueryTests.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 9/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IGHTMLDocument.h"

@interface IGCSSQueryTests : XCTestCase {
    IGHTMLDocument* doc;
}

@end

@implementation IGCSSQueryTests

- (void)setUp
{
    [super setUp];
    NSError* error;
    NSString* content = [[NSString alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"sample" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
    doc = [[IGHTMLDocument alloc] initWithHTMLString:content error:nil];
    NSAssert(!error, [error description]);
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}


- (void)testHtmlDocumentXPathQuery
{
    XCTAssertNotNil(doc);
    
    NSString* title = [doc queryWithCSS:@"title"].firstObject.text;
    XCTAssertEqualObjects(title, @"Sample \"Hello, World\" Application");
    
    NSArray* validLinks = @[@"about.html", @"hello.html"];
    [[doc queryWithXPath:@"ul > li > a"] enumerateNodesUsingBlock:^(IGXMLNode *link, NSUInteger idx, BOOL *stop) {
        XCTAssertTrue((NSInteger)[validLinks indexOfObject:link[@"href"]] > -1, @"should be valid link");
    }];
}

- (void) testInnerHtml {
    IGHTMLDocument* myDoc = [[IGHTMLDocument alloc] initWithXMLString:@"<html><body><h1>Header</h1><div id=\"content\"><span>Hello</span></div></body></html>" error:nil];
    IGXMLNode* content = [myDoc queryWithCSS:@"div#content"].firstObject;
    XCTAssertEqualObjects(content.innerXml, @"<span>Hello</span>");
    XCTAssertEqualObjects(content.xml, @"<div id=\"content\"><span>Hello</span></div>");
}

- (void)testAppend {
    doc = [[IGHTMLDocument alloc] initWithHTMLString:@"<div><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>" error:nil];
    [[doc queryWithCSS:@"div.inner"] enumerateNodesUsingBlock:^(IGXMLNode *node, NSUInteger idx, BOOL *stop) {
        [node appendWithXMLString:@"<img/>"];
    }];
    XCTAssertEqualObjects([doc queryWithCSS:@"div.inner"].firstObject.innerXml, @"Hello<img/>");
}

- (void)testPrepend {
    doc = [[IGHTMLDocument alloc] initWithHTMLString:@"<div><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>" error:nil];
    [[doc queryWithCSS:@"div.inner"] enumerateNodesUsingBlock:^(IGXMLNode *node, NSUInteger idx, BOOL *stop) {
        [node prependWithXMLString:@"<img/>"];
    }];
    XCTAssertEqualObjects([doc queryWithCSS:@"div.inner"].firstObject.innerXml, @"<img/>Hello");
}

- (void)testNestedContext {
    NSString* content = [[NSString alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"catalog" ofType:@"xml"] encoding:NSUTF8StringEncoding error:nil];
    IGXMLDocument* xml = [[IGXMLDocument alloc] initWithXMLString:content error:nil];
   
    NSMutableArray* data = [NSMutableArray array];
    [[xml queryWithCSS:@"cd"] enumerateNodesUsingBlock:^(IGXMLNode *node, NSUInteger idx, BOOL *stop) {
        [data addObject:[[[node queryWithCSS:@"title"] firstObject] text]];
    }];
    XCTAssertEqualObjects(([data copy]), (@[@"Empire Burlesque", @"Hide your heart", @"Greatest Hits"]));
}

@end

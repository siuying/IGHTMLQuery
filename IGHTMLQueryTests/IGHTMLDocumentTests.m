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

    doc = [[IGHTMLDocument alloc] initWithHTMLFile:@"sample" fileExtension:@"html" error:nil];
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
    IGHTMLDocument* myDoc = [[IGHTMLDocument alloc] initWithXMLString:@"<html><body><h1>Header</h1><div id=\"content\"><span>Hello</span></div></body></html>" encoding:NSUTF8StringEncoding error:nil];
    IGXMLNode* content = [myDoc queryWithXPath:@"//div[@id='content']"].firstObject;
    XCTAssertEqualObjects(content.innerXml, @"<span>Hello</span>");
    XCTAssertEqualObjects(content.xml, @"<div id=\"content\"><span>Hello</span></div>");
}

@end

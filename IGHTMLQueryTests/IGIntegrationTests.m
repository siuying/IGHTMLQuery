//
//  IGIntegrationTests.m
//  IGHTMLQuery
//
//  Created by Chong Francis on 13年8月24日.
//  Copyright (c) 2013年 Ignition Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IGHTMLQuery.h"
@interface IGIntegrationTests : XCTestCase {
    IGXMLNode* doc;
}

@end

#define igh_regexp(value) ([NSRegularExpression regularExpressionWithPattern:value options:NSRegularExpressionCaseInsensitive error:nil])

@implementation IGIntegrationTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testNYTimes
{
    doc = [[IGHTMLDocument alloc] initWithHTMLResource:@"nytimes" ofType:@"html" encoding:@"utf8" error:nil];
    XCTAssertNotNil(doc);

    // Because we are removing nodes while enumerating them, we have to reverse them first to prevent crash
    [[[[doc queryWithXPath:@"//script|//style|//select|//meta"] nodes] reversedOrderedSet] enumerateObjectsUsingBlock:^(IGXMLNode *elem, NSUInteger idx, BOOL *stop) {
        [elem remove];
    }];
    XCTAssertEqual(0U, [[doc queryWithXPath:@"//script|//style|//select"] count]);

    // change some elements
    NSRegularExpression* blockElementsRegexp = igh_regexp(@"<(a|blockquote|dl|div|img|ol|p|pre|table|ul)");
    [[doc queryWithXPath:@"//div"] enumerateNodesUsingBlock:^(IGXMLNode *elem, NSUInteger idx, BOOL *stop) {
        NSString* innerHtml = elem.innerXml;
        if ([blockElementsRegexp numberOfMatchesInString:innerHtml options:0 range:NSMakeRange(0, innerHtml.length)] == 0) {
            elem.tag = @"p";
        }
    }];
    
    // Because we are removing nodes while enumerating them, we have to reverse them first to prevent crash
    [[[[doc queryWithXPath:@"//table | //ul | //div"] nodes] reversedOrderedSet] enumerateObjectsUsingBlock:^(IGXMLNode *element, NSUInteger idx, BOOL *stop) {
        if (idx % 2 == 0) {
            [element remove];
        }
    }];
}

@end

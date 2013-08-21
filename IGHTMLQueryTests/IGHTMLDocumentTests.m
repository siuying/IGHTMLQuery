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

    doc = [[IGHTMLDocument alloc] initFromHTMLFile:@"sample" fileExtension:@"html"];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testHtmlDocumentTest
{
    XCTAssertNotNil(doc);
}

@end

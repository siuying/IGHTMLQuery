//
//  IGHTMLQueryTests.m
//  IGHTMLQueryTests
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IGXMLDocument.h"

@interface IGXMLDocumentTests : XCTestCase {
    NSString* catelogXml;
}

@end

@implementation IGXMLDocumentTests

- (void)setUp
{
    [super setUp];

    catelogXml = @"<?xml version=\"1.0\" ?>\
<catalog>\
    <cd country=\"USA\">\
        <title>Empire Burlesque</title>\
        <artist>Bob Dylan</artist>\
        <price>10.90</price>\
    </cd>\
    <cd country=\"UK\">\
        <title>Hide your heart</title>\
        <artist>Bonnie Tyler</artist>\
        <price>9.90</price>\
    </cd>\
    <cd country=\"USA\">\
        <title>Greatest Hits</title>\
        <artist>Dolly Parton</artist>\
        <price>9.90</price>\
    </cd>\
</catalog>";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testXmlString {
    IGXMLDocument* node = [[IGXMLDocument alloc] initFromXMLString:catelogXml encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(node.tag, @"catalog");
    XCTAssert([[node children] count] == 3);
}

@end

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

- (void)testXmlNode {
    IGXMLDocument* node = [[IGXMLDocument alloc] initFromXMLString:catelogXml encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(node.tag, @"catalog");

    IGXMLNodeSet* children = node.children;
    NSLog(@"children class: %@", [children class]);
    XCTAssertNotNil(children);
    XCTAssertTrue([children isKindOfClass:[IGXMLNodeSet class]]);

    IGXMLNode* firstChild = [node firstChild];
    XCTAssertEqualObjects(firstChild[@"country"], @"USA");
    XCTAssertEqualObjects(firstChild.firstChild.text, @"Empire Burlesque");
}

- (void)testXPath {
    IGXMLDocument* node = [[IGXMLDocument alloc] initFromXMLString:catelogXml encoding:NSUTF8StringEncoding];
    IGXMLNodeSet* cds = [node queryWithXPath:@"//cd"];
    XCTAssertNotNil(cds);
    XCTAssertTrue(cds.count == 3, @"should have 3 cd");
    
    IGXMLNodeSet* usaCds = [node queryWithXPath:@"//cd[@country='USA']"];
    XCTAssertNotNil(usaCds);
    XCTAssertTrue(usaCds.count == 2, @"should have 2 cd from USA");
    
    IGXMLNodeSet* ukCds = [node queryWithXPath:@"//cd[@country='UK']"];
    XCTAssertNotNil(ukCds);
    XCTAssertTrue(ukCds.count == 1, @"should have 1 cd from UK");
}

- (void)testXPathOnChild {
    IGXMLDocument* node = [[IGXMLDocument alloc] initFromXMLString:catelogXml encoding:NSUTF8StringEncoding];
    IGXMLNodeSet* usaCds = [node queryWithXPath:@"//cd[@country='USA']"];
    IGXMLNode* price = [[usaCds[0] queryWithXPath:@"price"] firstObject];
    XCTAssertEqualObjects(price.text, @"10.90");
}

- (void)testXPathShorthand {
    IGXMLDocument* node = [[IGXMLDocument alloc] initFromXMLString:catelogXml encoding:NSUTF8StringEncoding];
    IGXMLNodeSet* cds = node.query(@"//cd");
    XCTAssertNotNil(cds);
    XCTAssertTrue(cds.count == 3, @"should have 3 cd");

}

@end

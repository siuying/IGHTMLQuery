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
    NSString* catelogXml;
}

@end

@implementation IGXMLNodeSetTests

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
    [super tearDown];
}

- (void)testBasicNodeMethods
{
    IGXMLDocument* node = [[IGXMLDocument alloc] initFromXMLString:catelogXml encoding:NSUTF8StringEncoding];
    IGXMLNodeSet* nodeSet = [node children];
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
    IGXMLDocument* node = [[IGXMLDocument alloc] initFromXMLString:catelogXml encoding:NSUTF8StringEncoding];
    IGXMLNodeSet* cds = [node queryWithXPath:@"//cd"];
    IGXMLNodeSet* titles = [cds queryWithXPath:@"./title"];
    IGXMLNode* title = titles[0];
    XCTAssertEqualObjects(title.text, @"Empire Burlesque");
}

- (void)testXPathShorthand
{
    IGXMLDocument* node = [[IGXMLDocument alloc] initFromXMLString:catelogXml encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(node.query(@"//cd/title").firstObject.text, @"Empire Burlesque");
}

@end

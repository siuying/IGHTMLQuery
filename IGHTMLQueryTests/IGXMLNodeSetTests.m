//
//  IGXMLNodeSet.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IGXMLNodeSet.h"
#import "IGXMLNode.h"

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

- (void)testExample
{
//    IGXMLNode* node = [[IGXMLNode alloc] initFromXMLString:catelogXml encoding:NSUTF8StringEncoding];
//    IGXMLNodeSet* nodeSet = [node children];
//    for (IGXMLNode* n in nodeSet) {
//        XCTAssert(n);
//    }
}

@end

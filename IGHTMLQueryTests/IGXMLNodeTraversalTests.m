//
//  IGXMLNodeTraversalTests.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 21/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IGHTMLQuery.h"

@interface IGXMLNodeTraversalTests : XCTestCase {
    IGXMLDocument* doc;
}

@end

@implementation IGXMLNodeTraversalTests


- (void)setUp
{
    [super setUp];
    
    doc = [[IGXMLDocument alloc] initWithXMLResource:@"catalog" ofType:@"xml" encoding:@"utf8" error:nil];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testParent
{
    IGXMLNodeSet* cd = [doc queryWithXPath:@"//cd"];
    XCTAssertEqualObjects(cd.firstObject.parent.tag, @"catalog");
}

- (void)testNoParent
{
    IGXMLNode* catalog = [[doc queryWithXPath:@"//catalog"] firstObject];
    XCTAssertNotNil(catalog);
    XCTAssertNil(catalog.parent.parent);
}

- (void)testChildrenAndFirstChild
{
    IGXMLNodeSet* cd = [doc queryWithXPath:@"//cd"];
    XCTAssertEqualObjects(cd.firstObject.children.firstObject.tag, @"title");
    XCTAssertEqualObjects(cd.firstObject.firstChild.tag, @"title");
}

- (void)testNoChildren
{
    IGXMLNode* cd = [[doc queryWithXPath:@"//cd"] firstObject];
    XCTAssertNotNil(cd.firstChild);
    
    IGXMLNode* firstChild = cd.firstChild;
    XCTAssertEqualObjects(@"title", firstChild.tag);
    XCTAssertNil(firstChild.firstChild);
}

- (void)testNextAndPreviousSibling
{
    IGXMLNode* ukCd = [[doc queryWithXPath:@"cd[@country='UK']"] firstObject];
    
    XCTAssertEqualObjects([ukCd.previousSibling queryWithXPath:@"price"].firstObject.text, @"10.90");
    XCTAssertEqualObjects([ukCd.nextSibling queryWithXPath:@"price"].firstObject.text, @"8.90");
}

@end

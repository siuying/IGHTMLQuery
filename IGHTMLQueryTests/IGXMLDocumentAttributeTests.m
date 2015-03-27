//
//  IGXMLDocumentAttributeTests.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 21/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IGHTMLQuery.h"

@interface IGXMLDocumentAttributeTests : XCTestCase {
    IGXMLDocument* doc;
}

@end

@implementation IGXMLDocumentAttributeTests

- (void)setUp
{
    [super setUp];
    
    NSString* content = [[NSString alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"catalog" ofType:@"xml"] encoding:NSUTF8StringEncoding error:nil];
    doc = [[IGXMLDocument alloc] initWithXMLString:content error:nil];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testGetSetAttribute
{
    XCTAssertEqualObjects(doc.firstChild[@"country"], @"USA");
    doc.firstChild[@"country"] = @"France";
    XCTAssertEqualObjects(doc.firstChild[@"country"], @"France");
}

- (void)testAttributes
{
    XCTAssertEqualObjects(doc.firstChild.attributeNames, @[@"country"]);
}

@end

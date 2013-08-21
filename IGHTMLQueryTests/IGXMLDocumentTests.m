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
    IGXMLDocument* doc;
}

@end

@implementation IGXMLDocumentTests

- (void)setUp
{
    [super setUp];
    
    doc = [[IGXMLDocument alloc] initWithXMLFile:@"catalog" fileExtension:@"xml" error:nil];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testXmlNode {
    XCTAssertEqualObjects(doc.tag, @"catalog");

    IGXMLNodeSet* children = doc.children;
    NSLog(@"children class: %@", [children class]);
    XCTAssertNotNil(children);
    XCTAssertTrue([children isKindOfClass:[IGXMLNodeSet class]]);

    IGXMLNode* firstChild = [doc firstChild];
    XCTAssertEqualObjects(firstChild[@"country"], @"USA");
    XCTAssertEqualObjects(firstChild.firstChild.text, @"Empire Burlesque");
}

- (void)testXPath {
    IGXMLNodeSet* cds = [doc queryWithXPath:@"//cd"];
    XCTAssertNotNil(cds);
    XCTAssertTrue(cds.count == 3, @"should have 3 cd");
    
    IGXMLNodeSet* usaCds = [doc queryWithXPath:@"//cd[@country='USA']"];
    XCTAssertNotNil(usaCds);
    XCTAssertTrue(usaCds.count == 2, @"should have 2 cd from USA");
    
    IGXMLNodeSet* ukCds = [doc queryWithXPath:@"//cd[@country='UK']"];
    XCTAssertNotNil(ukCds);
    XCTAssertTrue(ukCds.count == 1, @"should have 1 cd from UK");
}

- (void)testXPathOnChild {
    IGXMLNodeSet* usaCds = [doc queryWithXPath:@"//cd[@country='USA']"];
    IGXMLNode* price = [[usaCds[0] queryWithXPath:@"price"] firstObject];
    XCTAssertEqualObjects(price.text, @"10.90");
}

- (void)testXPathShorthand {
    IGXMLNodeSet* cds = doc.query(@"//cd");
    XCTAssertNotNil(cds);
    XCTAssertTrue(cds.count == 3, @"should have 3 cd");

}

- (void)testParseError {
    NSError* error = nil;
    doc = [[IGXMLDocument alloc] initWithXMLData:[@"Hi" dataUsingEncoding:NSUTF8StringEncoding] error:&error];
    XCTAssertNil(doc);
    XCTAssertNotNil(error);
    NSLog(@"error -> %@", error);
}

@end

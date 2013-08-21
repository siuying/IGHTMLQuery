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
    IGXMLDocument* doc;
}

@end

@implementation IGXMLNodeSetTests

- (void)setUp
{
    [super setUp];
    
    doc = [[IGXMLDocument alloc] initWithXMLFile:@"catalog" fileExtension:@"xml" error:nil];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testBasicNodeMethods
{
    IGXMLNodeSet* nodeSet = [doc children];
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
    IGXMLNodeSet* cds = [doc queryWithXPath:@"//cd"];
    IGXMLNodeSet* titles = [cds queryWithXPath:@"./title"];
    IGXMLNode* title = titles[0];
    XCTAssertEqualObjects(title.text, @"Empire Burlesque");

    NSArray* artists = @[@"Bob Dylan", @"Bonnie Tyler", @"Dolly Parton"];
    [[doc queryWithXPath:@"//title"] enumerateNodesUsingBlock:^(IGXMLNode *node, NSUInteger idx, BOOL *stop) {
        XCTAssertTrue((NSInteger)[artists indexOfObject:node.text] > -1, @"should be valid artist");
    }];
}

- (void)testXPathShorthand
{
    XCTAssertEqualObjects(doc.query(@"//cd/title").firstObject.text, @"Empire Burlesque");

    NSArray* artists = @[@"Bob Dylan", @"Bonnie Tyler", @"Dolly Parton"];
    doc.query(@"//cd/artist").each(^(IGXMLNode* node){
        XCTAssertTrue((NSInteger)[artists indexOfObject:node.text] > -1, @"should be valid artist");
    });
}

@end

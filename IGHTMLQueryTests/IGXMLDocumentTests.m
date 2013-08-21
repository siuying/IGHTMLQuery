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
    
    IGXMLDocument* myDoc = [[IGXMLDocument alloc] initWithXMLString:@"<?xml version=\"1.0\" ?><catalog><cd country=\"USA\"><title>Empire Burlesque</title><artist>Bob Dylan</artist><price>10.90</price></cd></catalog>" encoding:NSUTF8StringEncoding error:nil];
    IGXMLNode* catalog = [myDoc queryWithXPath:@"//catalog"].firstObject;
    XCTAssertEqualObjects(catalog.innerXml, @"<cd country=\"USA\"><title>Empire Burlesque</title><artist>Bob Dylan</artist><price>10.90</price></cd>");
    XCTAssertEqualObjects(catalog.xml, @"<catalog><cd country=\"USA\"><title>Empire Burlesque</title><artist>Bob Dylan</artist><price>10.90</price></cd></catalog>");
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
    
    error = nil;
    doc = [[IGXMLDocument alloc] initWithXMLData:[@"<xml></xml>" dataUsingEncoding:NSUTF8StringEncoding] error:&error];
    XCTAssertNotNil(doc);
    XCTAssertNil(error);
}

- (void)testRemove {
    doc.query(@"//cd").each(^(IGXMLNode* cd){
        NSString* title = cd.query(@"./title").firstObject.text;
        NSLog(@"cd: %@", title);
        if (![title isEqualToString:@"Empire Burlesque"]) {
            [cd remove];
        }
    });
    
    IGXMLNodeSet* nodes = doc.query(@"//cd");
    XCTAssertTrue(nodes.count == 1, @"should have 1 node");
    XCTAssertEqualObjects(nodes.query(@"title").firstObject.text, @"Empire Burlesque");
    
}

- (void)testEmpty {
    doc.query(@"//cd").each(^(IGXMLNode* cd){
        NSString* title = cd.query(@"./title").firstObject.text;
        NSLog(@"cd: %@", title);
        if ([title isEqualToString:@"Empire Burlesque"]) {
            [cd empty];
        }
    });
    
    IGXMLNodeSet* nodes = doc.query(@"//cd");
    XCTAssertTrue(nodes.count == 3, @"should have 3 node");
    XCTAssertEqualObjects([nodes[0] innerXml], @"");
    XCTAssertEqualObjects(doc.query(@"//cd[@country='USA']//title").firstObject.text, @"Greatest Hits");
    XCTAssertEqualObjects(doc.query(@"//cd[@country='UK']//title").firstObject.text, @"Hide your heart");
}

- (void)testAppend {
    doc.query(@"//cd/title").each(^(IGXMLNode* cd){
        IGXMLNode* newNode = [[IGXMLDocument alloc] initWithXMLString:@"<test/>" encoding:NSUTF8StringEncoding error:nil];
        [cd appendWithNode:newNode];
    });
    XCTAssertEqualObjects(doc.query(@"//cd/title").firstObject.innerXml, @"Empire Burlesque<test/>");
}

- (void)testAppendShorthand {
    doc.query(@"//cd/title").each(^(IGXMLNode* cd){
        cd.append(@"<test/>");
    });
    XCTAssertEqualObjects(doc.query(@"//cd/title").firstObject.innerXml, @"Empire Burlesque<test/>");
}

- (void)testPrepend {
    doc.query(@"//cd/title").each(^(IGXMLNode* cd){
        IGXMLNode* newNode = [[IGXMLDocument alloc] initWithXMLString:@"<test/>" encoding:NSUTF8StringEncoding error:nil];
        [cd prependWithNode:newNode];
    });
    XCTAssertEqualObjects(doc.query(@"//cd/title").firstObject.innerXml, @"<test/>Empire Burlesque");
}

- (void)testPrependShorthand {
    doc.query(@"//cd/title").each(^(IGXMLNode* cd){
        cd.prepend(@"<test/>");
    });
    XCTAssertEqualObjects(doc.query(@"//cd/title").firstObject.innerXml, @"<test/>Empire Burlesque");
}

- (void)testAddNextSibling {
    doc = [[IGXMLDocument alloc] initWithXMLData:[@"<div><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>" dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    
    doc.query(@"//*[@class='inner']").each(^(IGXMLNode* node){
        [node addNextSiblingWithNode:[[IGXMLDocument alloc] initWithXMLString:@"<p>Test</p>" encoding:NSUTF8StringEncoding error:nil]];
    });
    
    XCTAssertEqualObjects(doc.innerXml,
                          @"<h2>Greetings</h2><div class=\"inner\">Hello</div><p>Test</p><div class=\"inner\">World</div><p>Test</p>");
}

- (void)testAfter {
    doc = [[IGXMLDocument alloc] initWithXMLData:[@"<div><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>" dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    
    doc.query(@"//*[@class='inner']").each(^(IGXMLNode* node){
        node.after(@"<p>Test</p>");
    });
    
    XCTAssertEqualObjects(doc.innerXml,
                          @"<h2>Greetings</h2><div class=\"inner\">Hello</div><p>Test</p><div class=\"inner\">World</div><p>Test</p>");
}

- (void)testPreviousNextSibling {
    doc = [[IGXMLDocument alloc] initWithXMLData:[@"<div><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>" dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    
    doc.query(@"//*[@class='inner']").each(^(IGXMLNode* node){
        [node addPreviousSiblingWithNode:[[IGXMLDocument alloc] initWithXMLString:@"<p>Test</p>" encoding:NSUTF8StringEncoding error:nil]];
    });
    
    XCTAssertEqualObjects(doc.innerXml,
                          @"<h2>Greetings</h2><p>Test</p><div class=\"inner\">Hello</div><p>Test</p><div class=\"inner\">World</div>");
}

- (void)testBefore {
    doc = [[IGXMLDocument alloc] initWithXMLData:[@"<div><h2>Greetings</h2><div class=\"inner\">Hello</div><div class=\"inner\">World</div></div>" dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    
    doc.query(@"//*[@class='inner']").each(^(IGXMLNode* node){
        node.before(@"<p>Test</p>");
    });
    
    XCTAssertEqualObjects(doc.innerXml,
                          @"<h2>Greetings</h2><p>Test</p><div class=\"inner\">Hello</div><p>Test</p><div class=\"inner\">World</div>");
}

@end

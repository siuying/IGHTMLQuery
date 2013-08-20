
# IGHTMLQuery

IGHTMLQuery is a lightweight XML/HTML parser for iOS, built on top of libxml.

## Features

- XPath support for document searching.
- jQuery style chainable syntax.

## Why do we need yet another XML library?

I need a clean, simple, familiar and powerful library to query and manipulate HTML documents. 

Consider following snippets:

```objective-c
IGXMLDocument* node = [[IGXMLDocument alloc] initFromXMLString:catelogXml encoding:NSUTF8StringEncoding];
NSString* title = [[[node queryWithXPath:@"//cd/title"] firstObject] text];
[[node queryWithXPath:@"//title"] enumerateNodesUsingBlock:^(IGXMLNode *node, NSUInteger idx, BOOL *stop) {
    XCTAssertTrue((NSInteger)[artists indexOfObject:node.text] > -1, @"should be valid artist");
}];

// or using jquery style shortcut
NSString* title = node.query(@"//cd/title").firstObject.text;
node.query(@"//cd/title").each(^(IGXMLNode* node){ 
  NSLog(@"%@", node.text);
})

```

## State

- -Basic XML document-
- -Basic XML query-
- HTML support
- Document manipulation

## Usage

TBA

## License

MIT License.
# IGHTMLQuery

IGHTMLQuery is a lightweight XML/HTML library for iOS to provide XML processing easy.

## Why do we need yet another XML library?

I need a clean, simple, familiar and powerful query and manipulate HTML documents. 

Consider following snippets:

```objective-c
IGXMLDocument* node = [[IGXMLDocument alloc] initFromXMLString:catelogXml encoding:NSUTF8StringEncoding];
NSString* title = [[[node queryWithXPath:@"//cd/title"] firstObject] text];

// or simply
NSString* title = node.query(@"//cd/title").firstObject.text;
```

## Usage

TBA

## License

MIT License.
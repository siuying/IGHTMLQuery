//
//  IGXMLNode.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IGXMLNodeSet;

@interface IGXMLNode : NSObject

- (id)initFromXMLString:(NSString *)xmlString encoding:(NSStringEncoding)encoding;
- (id)initFromXMLFilePath:(NSString *)fullPath;
- (id)initFromXMLFile:(NSString *)filename;
- (id)initFromXMLFile:(NSString *)filename fileExtension:(NSString *)extension;
- (id)initFromURL:(NSURL *)url;
- (id)initFromXMLData:(NSData *)data;

@end

@interface IGXMLNode (Query)

-(IGXMLNode*) firstChild;

-(IGXMLNodeSet*) children;

-(IGXMLNodeSet*) queryWithXPath:(NSString*)xpath;

@end
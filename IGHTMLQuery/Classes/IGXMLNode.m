//
//  IGXMLNode.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "IGXMLNode.h"
#import "IGXMLDocument.h"

NSString* const IGXMLQueryErrorDomain = @"IGHTMLQueryError";

@interface IGXMLNode ()
@property (nonatomic, strong, readwrite) IGXMLDocument* root;
@end

@implementation IGXMLNode

- (id)initFromRoot:(IGXMLDocument*)root node:(xmlNodePtr)node {
    if ((self = [super init])) {
        _root = root;
        _node = node;
    }
    return self;
}

-(void) dealloc {
    _root = nil;
    _node = nil;
}

#pragma mark - 

- (NSString *)tag {
    if (_node->name) {
        return [NSString stringWithUTF8String:(const char *)_node->name];
    } else {
        return nil;
    }
}

- (NSString *)text {
    xmlChar *key = xmlNodeGetContent(_node);
    NSString *text = (key ? [NSString stringWithUTF8String:(const char *)key] : @"");
    xmlFree(key);
    return text;
}

-(IGXMLNode*) firstChild {
    xmlNodePtr cur = _node->children;

    while (cur != nil) {
        if (cur->type == XML_ELEMENT_NODE) {
            return [[IGXMLNode alloc] initFromRoot:self.root node:cur];
        }
        cur = cur->next;
    }

    return nil;
}

- (IGXMLNodeSet *)children {
    NSMutableArray* children = [NSMutableArray array];
    xmlNodePtr cur = _node->children;
    
    while (cur != nil) {
        if (cur->type == XML_ELEMENT_NODE) {
            [children addObject:[[IGXMLNode alloc] initFromRoot:self.root node:cur]];
        }
        cur = cur->next;
    }
    
    return [[IGXMLNodeSet alloc] initWithNodes:children];
}

- (NSError*) lastError {
    xmlErrorPtr error = xmlGetLastError();
    if (error) {
        NSDictionary* userInfo = @{
                                   @"domain": [NSString stringWithFormat:@"%i", error->domain],
                                   @"code": [NSString stringWithFormat:@"%i", error->code],
                                   @"message": error->message ? [NSString stringWithCString:error->message encoding:NSUTF8StringEncoding] : @"",
                                   @"file": error->file ? [NSString stringWithCString:error->file encoding:NSUTF8StringEncoding] : @"",
                                   @"line": [NSString stringWithFormat:@"%i", error->line],
                                   @"column": [NSString stringWithFormat:@"%i", error->int2]
                                };
        return [NSError errorWithDomain:IGXMLQueryErrorDomain code:error->code userInfo:userInfo];
    } else {
        return nil;
    }
}

@end

@implementation IGXMLNode (Query)

-(IGXMLNodeSet*) queryWithXPath:(NSString*)xpath {
    if (!xpath) {
        return [[IGXMLNodeSet alloc] initWithNodes:@[]];
    }

    xmlXPathContextPtr context = xmlXPathNewContext(self.root.doc);
    if (context == NULL) {
		return nil;
    }
    
    context->node = self.node;

    xmlXPathObjectPtr object = xmlXPathEvalExpression((xmlChar *)[xpath cStringUsingEncoding:NSUTF8StringEncoding], context);
    if (object == NULL) {
		return nil;
    }
    
	xmlNodeSetPtr nodes = object->nodesetval;
	if (nodes == NULL) {
		return nil;
	}
    
	NSMutableArray *resultNodes = [NSMutableArray array];
    for (NSInteger i = 0; i < nodes->nodeNr; i++) {
        [resultNodes addObject:[[IGXMLNode alloc] initFromRoot:self.root node:nodes->nodeTab[i]]];
	}
    
    xmlXPathFreeObject(object);
    xmlXPathFreeContext(context);

    return [[IGXMLNodeSet alloc] initWithNodes:resultNodes];
}

-(IGXMLNodeSet* (^)(NSString*)) query {
    return ^IGXMLNodeSet* (NSString* query) {
        return [self queryWithXPath:query];
    };
}

@end

@implementation IGXMLNode (Attributes)

- (id)objectForKeyedSubscript:(id)key {
    return [self attribute:key];
}

- (NSString *)attribute:(NSString *)attName {
    return [self attribute:attName inNamespace:nil];
}

- (NSString *)attribute:(NSString *)attName inNamespace:(NSString *)ns {
    const unsigned char *attCStr = ns ?
        xmlGetNsProp(_node, (const xmlChar *)[attName cStringUsingEncoding:NSUTF8StringEncoding], (const xmlChar *)[ns cStringUsingEncoding:NSUTF8StringEncoding]) :
        xmlGetProp(_node, (const xmlChar *)[attName cStringUsingEncoding:NSUTF8StringEncoding]) ;

    if (attCStr) {
        return [NSString stringWithUTF8String:(const char *)attCStr];
    }
    
    return nil;
}

@end

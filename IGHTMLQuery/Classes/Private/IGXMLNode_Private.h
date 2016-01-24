//
//  IGXMLNode_Private.h
//  IGHTMLQuery
//
//  Created by Chan Fai Chong on 24/1/2016.
//  Copyright © 2016 Ignition Soft. All rights reserved.
//

#ifndef IGXMLNode_Private_h
#define IGXMLNode_Private_h

#import <libxml2/libxml/HTMLtree.h>
@interface IGXMLNode (Private)
@property (nonatomic, readwrite, unsafe_unretained) xmlNodePtr node;
@end

#endif /* IGXMLNode_Private_h */

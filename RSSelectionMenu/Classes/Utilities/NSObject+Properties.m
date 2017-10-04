//
// NSObject+Properties.m
// Copyright © 2016 Rushi Sangani All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSObject+Properties.h"
#import "objc/runtime.h"

@implementation NSObject (Properties)

+(NSArray *)getAllPropertiesForClass:(Class)className {
    return [self arrayOfPropertiesForClass:className];
}

+(NSDictionary *)getAllPropertyValuesWithNames:(id)object {
    
    NSArray *arrayOfpropertyNames = [NSObject arrayOfPropertiesForClass:[object class]];
    NSDictionary *propValueDictionary = [object dictionaryWithValuesForKeys:arrayOfpropertyNames];
    return propValueDictionary;
}

+(void)replaceAllPropertyValuesForClass:(id)destinationObject withClass:(id)sourceObject {
    
    NSAssert([sourceObject isKindOfClass:[destinationObject class]], @"Source and destination object must be of the same class type");
    
    if([sourceObject isKindOfClass:[destinationObject class]]) {
        
        NSArray *arrayOfpropertyNames = [NSObject arrayOfPropertiesForClass:[destinationObject class]];
        NSDictionary *propValueDictionary = [sourceObject dictionaryWithValuesForKeys:arrayOfpropertyNames];
        [destinationObject setValuesForKeysWithDictionary:propValueDictionary];
    }
}

#pragma mark- Private methods
+ (NSArray *)arrayOfPropertiesForClass:(Class)className
{
    if (className == NULL) {
        return nil;
    }
    
    NSMutableArray *results = [[NSMutableArray alloc] init] ;
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(className, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            
            //const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            //NSString *propertyType = [NSString stringWithUTF8String:propType];
            [results addObject:propertyName];
        }
    }
    free(properties);
    
    // returning a copy here to make sure the dictionary is immutable
    return results;
}

/*
 
#pragma mark- Get Property type
static const char * getPropertyType(objc_property_t property)
{
    const char *attributes = property_getAttributes(property);
    printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
 
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
 
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}

*/

@end

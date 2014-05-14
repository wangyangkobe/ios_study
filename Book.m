/*
    reference link: http://www.cocoachina.com/applenews/devnews/2014/0513/8405.html
*/



@interface Book : NSObject <NSCoding> 
    @property NSString *title; 
    @property NSString *author; 
    @property NSUInteger pageCount; 
    @property NSSet *categories; 
    @property (getter = isAvailable) BOOL available; 
@end 

@implementation Book 

#pragma mark - NSCoding 
- (id)initWithCoder:(NSCoder *)decoder { 
    self = [super init]; 
    if (!self) { 
        return nil; 
    } 

    self.title = [decoder decodeObjectForKey:@"title"]; 
    self.author = [decoder decodeObjectForKey:@"author"]; 
    self.pageCount = [decoder decodeIntegerForKey:@"pageCount"]; 
    self.categories = [decoder decodeObjectForKey:@"categories"]; 
    self.available = [decoder decodeBoolForKey:@"available"]; 

    return self; 
} 

- (void)encodeWithCoder:(NSCoder *)encoder { 
    [encoder encodeObject:self.title forKey:@"title"]; 
    [encoder encodeObject:self.author forKey:@"author"]; 
    [encoder encodeInteger:self.pageCount forKey:@"pageCount"]; 
    [encoder encodeObject:self.categories forKey:@"categories"]; 
    [encoder encodeBool:[self isAvailable] forKey:@"available"]; 
} 

@end 
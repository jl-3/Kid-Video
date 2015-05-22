

#import <UIKit/UIKit.h>

@interface NSURL (Parameters)

@property (nonatomic, strong) NSDictionary *parameters;


- (NSString *)parameterForKey:(NSString *)key;

- (id)objectForKeyedSubscript:(id)key NS_AVAILABLE(10_8, 6_0);


@end

//
//  AdKey.h
//  ballzcpp-mobile
//
//  Created by apple on 2018/5/2.
//

#import <Foundation/Foundation.h>

@interface EYAdKey : NSObject{

}

@property(nonatomic,copy)NSString *keyId;
@property(nonatomic,copy)NSString *network;
@property(nonatomic,copy)NSString *key;
@property(nonatomic,copy)NSString *placementid;

-(instancetype) initWithId : (NSString*) keyId network:(NSString*) network key:(NSString*) key placementid:(NSString *)placementid;

@end

//
//  Friends+CoreDataProperties.h
//  Efl
//
//  Created by vaskov on 27.10.16.
//  Copyright © 2016 ZNET. All rights reserved.
//

#import "Friends+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Friends (CoreDataProperties)

+ (NSFetchRequest<Friends *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, copy) NSString *imageURL;
@property (nullable, nonatomic, copy) NSNumber *isSignedUp;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSString *playerId;
@property (nullable, nonatomic, copy) NSString *facebookId;

@end

NS_ASSUME_NONNULL_END

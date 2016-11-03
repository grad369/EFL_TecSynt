//
//  Friends+CoreDataProperties.m
//  Efl
//
//  Created by vaskov on 27.10.16.
//  Copyright © 2016 ZNET. All rights reserved.
//

#import "Friends+CoreDataProperties.h"

@implementation Friends (CoreDataProperties)

+ (NSFetchRequest<Friends *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Friends"];
}

@dynamic firstName;
@dynamic image;
@dynamic imageURL;
@dynamic isSignedUp;
@dynamic lastName;
@dynamic playerId;
@dynamic facebookId;

@end

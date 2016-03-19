//
//  Rsa.h
//  Crypto
//
//  Created by Christophe Vichery on 3/9/16.
//  Copyright © 2016 NutsNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BigInt.h"

@interface Rsa : NSObject
{
    NSUInteger bitSize;
    NSString *publicKey, *privateKey;
}

- (void)createKeysWithBitsize:(NSUInteger)size;

@end

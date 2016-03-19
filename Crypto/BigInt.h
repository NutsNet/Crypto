//
//  BigInt.h
//  Crypto
//
//  Created by Christophe Vichery on 3/7/16.
//  Copyright © 2016 NutsNet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BigInt : NSObject
{
    NSMutableDictionary *listOfBigInt, *stackOfBigInt;
    
    BOOL isResetStack;
}

- (void)setNewBigInt:(NSString*)x withName:(NSString*)k;

- (NSString*)convertBinToDec:(NSString*)bin;

- (NSString*)subBigInt:(NSString*)x withBigInt:(NSString*)y inBase:(NSUInteger)b;
- (NSString*)addBigInt:(NSString*)x withBigInt:(NSString*)y inBase:(NSUInteger)b;
- (NSString*)mulBigInt:(NSString*)x withBigInt:(NSString*)y inBase:(NSUInteger)b;

@end

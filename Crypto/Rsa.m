//
//  Rsa.m
//  Crypto
//
//  Created by Christophe Vichery on 3/9/16.
//  Copyright © 2016 NutsNet. All rights reserved.
//

#import "Rsa.h"

@implementation Rsa

- (id)init
{
    if(!(self = [super init]))
        return nil;
    
    bitSize = 0;
    publicKey = @"";
    privateKey = @"";
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)createKeysWithBitsize:(NSUInteger)size
{
    bitSize = size;
    
    NSString *nb = [self generateOddNumber];
    
    
    if ([self testPrimeNumber:nb withAccuracy:10])
    {
        NSLog(@"PRIME");
    }
    else
    {
        NSLog(@"NOT PRIME");
    }
}

- (BOOL)testPrimeNumber:(NSString*)num withAccuracy:(NSUInteger)itr
{
    NSString *bin = num;
    
    BigInt *bigInt = [[BigInt alloc] init];
    NSLog(@"BIN: %@", num);
    num = [bigInt convertBinToDec:num];
    NSLog(@"DEC: %@", num);
    [bigInt release]; bigInt = nil;
    
    if ([num length] == 1) return YES;
    if ([[num substringFromIndex:[num length]-1] isEqualToString:@"5"]) return NO;
    
    NSString* y = @"1";
    
    bigInt = [[BigInt alloc] init];
    [bigInt setNewBigInt:num withName:@"num"];
    [bigInt setNewBigInt:@"1" withName:@"one"];
    NSString* m = [bigInt subBigInt:@"num" withBigInt:@"one" inBase:10];
    [bigInt release]; bigInt = nil;
    
    for (int t=0; t<itr; t++)
    {
        BigInt *bigInt = [[BigInt alloc] init];
        NSString *a = [self generateOddNumber];
        
        for (int j=0; j<[a length]; j++) {
            a = [a stringByReplacingCharactersInRange:NSMakeRange(j, 1) withString:@"0"];
            if ([[NSString stringWithFormat:@"%c", [bin characterAtIndex:j]] isEqualToString:@"1"])
                break;
        }
        
        a = [a stringByReplacingCharactersInRange:NSMakeRange([a length]-2, 1) withString:@"1"];
        //NSLog(@"a: %@", a);
        a = [bigInt convertBinToDec:a];
        NSLog(@"a  : %@", a);
        [bigInt release]; bigInt = nil;
        
        /*while (m != 0)
        {
            if (m%2) {
                y = (a*y)%n;
                m = m-1;
            }
            else
            {
                int b = a;
                
                a = (a*a)%n;
                
                if (a==1 && b!=1 && b!=n-1) return NO;
                
                m = m/2;
            }
        }
    
        if (y != 1) return NO;*/
    }
    
    return YES;
}

- (NSString*)generateOddNumber
{
    NSString *oddNum = @"";
    
    for (NSUInteger i=0; i<bitSize-1; i++)
    {
        oddNum = [oddNum stringByAppendingString:[NSString stringWithFormat:@"%u", arc4random() %(2)]];
    }
    
    oddNum = [oddNum stringByAppendingString:[NSString stringWithFormat:@"%u", 1]];
    
    return oddNum;
}

@end

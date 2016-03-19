//
//  main.m
//  Crypto
//
//  Created by Christophe Vichery on 3/5/16.
//  Copyright © 2016 NutsNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rsa.h"

#import "BigInt.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Rsa *rsa = [[Rsa alloc] init];
        [rsa createKeysWithBitsize:128];
        [rsa release]; rsa = nil;
        
        /*BigInt *bigInt = [[BigInt alloc] init];
        
        NSString *a = @"32";
        NSString *b = @"64";
        
        [bigInt setNewBigInt:a withName:@"a"];
        [bigInt setNewBigInt:b withName:@"b"];
        
        //NSString* resub = [bigInt subBigInt:@"a" withBigInt:@"b" inBase:2];
        
        NSString* res = [bigInt mulBigInt:@"a" withBigInt:@"b" inBase:10];
        
        [bigInt release]; bigInt = nil;*/
    }
    
    return 0;
}

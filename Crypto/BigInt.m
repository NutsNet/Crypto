//
//  BigInt.m
//  Crypto
//
//  Created by Christophe Vichery on 3/7/16.
//  Copyright © 2016 NutsNet. All rights reserved.
//

#import "BigInt.h"

@implementation BigInt

- (id)init
{
    if(!(self = [super init]))
        return nil;
    
    listOfBigInt = [[NSMutableDictionary alloc] init];
    stackOfBigInt = [[NSMutableDictionary alloc] init];
    
    isResetStack = YES;
    
    return self;
}

- (void)dealloc
{
    [stackOfBigInt release]; stackOfBigInt = nil;
    [listOfBigInt release]; listOfBigInt = nil;
    [super dealloc];
}

- (void)resetStackOfBigInt
{
    [stackOfBigInt release]; stackOfBigInt = nil;
    stackOfBigInt = [[NSMutableDictionary alloc] initWithDictionary:listOfBigInt];
}

- (void)setNewBigIntInStack:(NSString*)x withName:(NSString*)k
{
    if ([stackOfBigInt objectForKey:k])
        NSLog(@"These numbers already exist!!");
    else
    {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[x length]];
        
        for (NSInteger i=[x length]-1; i>=0; i--)
        {
            NSString *ichar  = [NSString stringWithFormat:@"%c", [x characterAtIndex:i]];
            [array addObject:ichar];
        }
        
        [stackOfBigInt setObject:array forKey:k];
        [array release]; array = nil;
    }
}

- (void)setNewBigInt:(NSString*)x withName:(NSString*)k
{
    if ([listOfBigInt objectForKey:k])
        NSLog(@"These numbers already exist!");
    else
    {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[x length]];
        
        for (NSInteger i=[x length]-1; i>=0; i--)
        {
            NSString *ichar  = [NSString stringWithFormat:@"%c", [x characterAtIndex:i]];
            [array addObject:ichar];
        }
        
        [listOfBigInt setObject:array forKey:k];
        [stackOfBigInt setObject:array forKey:k];
        [array release]; array = nil;
    }
}

- (NSString*)convertArrayOfCharToString:(NSArray*)arrayOfChar
{
    NSString* result = @"";
    
    for (NSInteger i=[arrayOfChar count]-1; i>=0; i--)
    {
        result = [result stringByAppendingString:arrayOfChar[i]];
    }
    
    return result;
}

- (NSString*)convertBin:(NSString*)bin toBase:(NSUInteger)b
{
    NSUInteger j = 0;
    NSString *dec=@"0";
    [self setNewBigInt:dec withName:@"dec"];
    
    for (NSInteger i=[bin length]-1; i>=0; i--)
    {
        if ([[NSString stringWithFormat:@"%c", [bin characterAtIndex:i]] isEqualToString:@"1"])
        {
            [self setNewBigInt:@"2" withName:@"bitbit"];
            
            NSString *pow = @"1";
            [listOfBigInt removeObjectForKey:@"pow"];
            [stackOfBigInt removeObjectForKey:@"pow"];
            [self setNewBigInt:pow withName:@"pow"];
            
            if (j != 0)
            {
                pow = @"2";
                [listOfBigInt removeObjectForKey:@"pow"];
                [stackOfBigInt removeObjectForKey:@"pow"];
                [self setNewBigInt:pow withName:@"pow"];
                
                for (NSUInteger k=0; k<j-1; k++) {
                    pow = [self mulBigInt:@"pow" withBigInt:@"bitbit" inBase:b];
                    [listOfBigInt removeObjectForKey:@"pow"];
                    [stackOfBigInt removeObjectForKey:@"pow"];
                    [self setNewBigInt:pow withName:@"pow"];
                }
            }
            
            [listOfBigInt removeObjectForKey:@"bitbit"];
            [stackOfBigInt removeObjectForKey:@"bitbit"];
            
            [listOfBigInt removeObjectForKey:@"dec"];
            [stackOfBigInt removeObjectForKey:@"dec"];
            [self setNewBigInt:dec withName:@"dec"];
            
            dec = [self addBigInt:@"dec" withBigInt:@"pow" inBase:b];
            
            [listOfBigInt removeObjectForKey:@"dec"];
            [stackOfBigInt removeObjectForKey:@"dec"];
            [self setNewBigInt:dec withName:@"dec"];
        }
        
        j++;
    }
    
    NSUInteger nbOfZero = 0;
    
    for (NSUInteger i=0; i<[dec length]; i++)
    {
        if([[NSString stringWithFormat:@"%c", [dec characterAtIndex:i]] isEqualToString:@"0"])
            nbOfZero++;
        else
        {
            if(i > 0)
                dec = [dec substringFromIndex:nbOfZero];
            
            break;
        }
    }
    
    return dec;
}

// X > Y
- (NSString*)subBigInt:(NSString*)x withBigInt:(NSString*)y inBase:(NSUInteger)b
{
    NSString* result = @"";
    
    if ([stackOfBigInt objectForKey:x] && [stackOfBigInt objectForKey:y])
    {
        NSMutableArray *topArr = [[stackOfBigInt objectForKey:x] mutableCopy];
        NSMutableArray *botArr = [[stackOfBigInt objectForKey:y] mutableCopy];
        NSMutableArray *resArr = [[NSMutableArray alloc] init];
        
        for (NSUInteger i=0; i<[topArr count]; i++)
        {
            if (i == [botArr count]) [botArr addObject:@"0"];
            
            if ([botArr[i] integerValue] > [topArr[i] integerValue])
            {
                [resArr addObject:[NSString stringWithFormat:@"%lu", b + [topArr[i] integerValue] - [botArr[i] integerValue]]];
                
                if (i+1 < [botArr count])
                    [botArr replaceObjectAtIndex:i+1 withObject:[NSString stringWithFormat:@"%lu", [botArr[i+1] integerValue] + 1]];
                else
                    [botArr addObject:@"1"];
            }
            else
                [resArr addObject:[NSString stringWithFormat:@"%lu", [topArr[i] integerValue] - [botArr[i] integerValue]]];
            
            result = [resArr[i] stringByAppendingString:result];
        }
        
        [topArr release]; topArr = nil;
        [botArr release]; botArr = nil;
        [resArr release]; resArr = nil;
        
        if (isResetStack) [self resetStackOfBigInt];
        
        return result;
    }
    else
    {
        NSLog(@"One or both of these numbers doesn't exist!");
        [self resetStackOfBigInt];
        return 0;
    }
}

- (NSString*)addBigInt:(NSString*)x withBigInt:(NSString*)y inBase:(NSUInteger)b
{
    NSString* result = @"";
    
    if ([stackOfBigInt objectForKey:x] && [stackOfBigInt objectForKey:y])
    {
        NSMutableArray *tArr;
        NSMutableArray *rArr;
        
        if ([[stackOfBigInt objectForKey:x] count] > [[stackOfBigInt objectForKey:y] count])
        {
            tArr = [[stackOfBigInt objectForKey:y] mutableCopy];
            rArr = [[stackOfBigInt objectForKey:x] mutableCopy];
        }
        else
        {
            tArr = [[stackOfBigInt objectForKey:x] mutableCopy];
            rArr = [[stackOfBigInt objectForKey:y] mutableCopy];
        }
        
        for (NSUInteger i=0; i<[rArr count]; i++)
        {
            if (i == [tArr count]) [tArr addObject:@"0"];
            
            if ([rArr[i] integerValue] + [tArr[i] integerValue] >= b)
            {
                [rArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%lu", [rArr[i] integerValue] + [tArr[i] integerValue] - b]];
                
                if (i+1 < [rArr count])
                    [rArr replaceObjectAtIndex:i+1 withObject:[NSString stringWithFormat:@"%lu", [rArr[i+1] integerValue] + 1]];
                else
                    [rArr addObject:@"1"];
            }
            else
                [rArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%lu", [rArr[i] integerValue] + [tArr[i] integerValue]]];
            
            result = [rArr[i] stringByAppendingString:result];
        }
        
        [tArr release]; tArr = nil;
        [rArr release]; rArr = nil;
        
        if (isResetStack) [self resetStackOfBigInt];
        
        return result;
    }
    else
    {
        NSLog(@"One or both of these numbers doesn't exist!");
        [self resetStackOfBigInt];
        return 0;
    }
}

- (NSString*)mulBigInt:(NSString*)x withBigInt:(NSString*)y inBase:(NSUInteger)b;
{
    NSString* result = @"";
    
    if ([stackOfBigInt objectForKey:x] && [stackOfBigInt objectForKey:y])
    {
        NSMutableArray *topArr;
        NSMutableArray *botArr;
        
        if ([[stackOfBigInt objectForKey:x] count] > [[stackOfBigInt objectForKey:y] count])
        {
            topArr = [[stackOfBigInt objectForKey:x] mutableCopy];
            botArr = [[stackOfBigInt objectForKey:y] mutableCopy];
        }
        else
        {
            topArr = [[stackOfBigInt objectForKey:y] mutableCopy];
            botArr = [[stackOfBigInt objectForKey:x] mutableCopy];
        }
        
        [stackOfBigInt removeAllObjects];
        
        for (NSUInteger i=0; i<[botArr count]; i++)
        {
            NSMutableArray *numArr = [[NSMutableArray alloc] init];
            [numArr addObject:@"0"];
            
            NSMutableArray *retArr = [[NSMutableArray alloc] init];
            
            for (NSUInteger j=0; j<[topArr count]; j++)
            {
                [numArr addObject:@"0"];
                
                NSUInteger num = [topArr[j] integerValue] * [botArr[i] integerValue];
                
                if (num >= b)
                {
                    NSUInteger num0 = num % b;
                    NSUInteger num1 = num / b;
                    
                    [numArr replaceObjectAtIndex:j withObject:[NSString stringWithFormat:@"%lu", [numArr[j] integerValue] + num0]];
                    
                    [retArr addObject:[NSString stringWithFormat:@"%lu", num1]];
                    
                    if ([retArr count] == 1)
                        for (NSUInteger k=0; k<j+i+1; k++) { [retArr insertObject:@"0" atIndex:0]; }
                }
                else
                {
                    [numArr replaceObjectAtIndex:j withObject:[NSString stringWithFormat:@"%lu", num]];
                    
                    if ([retArr count] > 0) [retArr addObject:@"0"];
                }
                
            }
            
            NSString *strArr = [self convertArrayOfCharToString:retArr];
            NSString *strKey = @"ret";
            
            strKey = [strKey stringByAppendingString:[NSString stringWithFormat:@"%lu", i]];
            strKey = [strKey stringByAppendingString:strArr];
            
            if ([retArr count] > 0) [self setNewBigIntInStack:strArr withName:strKey];
            
            [retArr release]; retArr = nil;
            
            if ([[numArr lastObject]  isEqual: @"0"]) [numArr removeLastObject];
            
            for (NSUInteger k=0; k<i; k++) { [numArr insertObject:@"0" atIndex:0]; }
            
            strArr = [self convertArrayOfCharToString:numArr];
            
            strKey = @"num";
            strKey = [strKey stringByAppendingString:[NSString stringWithFormat:@"%lu", i]];
            strKey = [strKey stringByAppendingString:strArr];
            
            [self setNewBigIntInStack:strArr withName:strKey];
            
            [numArr release]; numArr = nil;
        }
        
        [topArr release]; topArr = nil;
        [botArr release]; botArr = nil;
        
        NSArray *keys=[stackOfBigInt allKeys];
        NSUInteger j=0;
        
        if ([stackOfBigInt count] > 1)
        {
            do
            {
                NSString *strKey = [@"add" stringByAppendingString:[NSString stringWithFormat:@"%lu", j++]];
                
                isResetStack = NO;
                result = [self addBigInt:keys[0] withBigInt:keys[1] inBase:b];
                isResetStack = YES;
                
                [self setNewBigIntInStack:result withName:strKey];
                
                [stackOfBigInt removeObjectForKey:keys[0]];
                
                [stackOfBigInt removeObjectForKey:keys[1]];
                
                keys=[stackOfBigInt allKeys];
                
                if ([stackOfBigInt count] == 1) break;
            }
            while ([stackOfBigInt count] > 1);
        }
        else
        {
            for(NSInteger i=[[stackOfBigInt objectForKey:keys[0]] count]-1; i>=0; i--)
            {
                result = [result stringByAppendingString:[[stackOfBigInt objectForKey:keys[0]] objectAtIndex:i]];
            }
        }
        
        if (isResetStack) [self resetStackOfBigInt];
        
        return result;
    }
    else
    {
        NSLog(@"One or both of these numbers doesn't exist!");
        [self resetStackOfBigInt];
        return 0;
    }
}

@end

//
//  PlayingCard.m
//  Matchismo
//
//  Created by Teddy Wyly on 8/5/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)validSuits
{
    return @[@"♥", @"♦", @"♠", @"♣"];
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count] - 1;
}


- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}


- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        } else if (otherCard.rank == self.rank) {
            score = 4;
        }
    } else if ([otherCards count] == 2) {
        PlayingCard *firstCard = otherCards[0];
        PlayingCard *secondCard = otherCards[1];
        if ([firstCard.suit isEqualToString:secondCard.suit] && [firstCard.suit isEqualToString:self.suit]) {
            score = 4;
        } else if (firstCard.rank == secondCard.rank && firstCard.rank == self.rank) {
            score = 16;
        }
    }
    
    return score;
}

@end

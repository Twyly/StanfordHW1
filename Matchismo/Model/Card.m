//
//  Card.m
//  Matchismo
//
//  Created by Teddy Wyly on 8/5/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}

@end

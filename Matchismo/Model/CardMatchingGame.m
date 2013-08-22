//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Teddy Wyly on 8/6/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (strong, nonatomic) NSMutableArray *cards; // of cards
@property (nonatomic, readwrite) int score;
@property (nonatomic) BOOL isTwoCardGame;

@end

@implementation CardMatchingGame

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (FlipStatus *)flipStatus
{
    if (!_flipStatus) _flipStatus = [[FlipStatus alloc] init];
    return _flipStatus;
}

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    
    return self;
}

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck isTwoCardGame:(BOOL)isTwoCardGame
{
    self = [self initWithCardCount:cardCount usingDeck:deck];
    
    if (self) {
        _isTwoCardGame = isTwoCardGame;
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

//update this to check if self is a two or three card game and act accordingly

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    self.flipStatus = nil;
    [self.flipStatus.cardsInvolved addObject:card];
    
    NSMutableArray *otherCards = [@[] mutableCopy];
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            for (Card *otherCard in self.cards) {
                if (self.isTwoCardGame) {
                    if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                        [self.flipStatus.cardsInvolved addObject:otherCard];
                        int matchScore = [card match:@[otherCard]];
                        if (matchScore) {
                            otherCard.unplayable = YES;
                            card.unplayable = YES;
                            self.score += matchScore * MATCH_BONUS;
                            self.flipStatus.pointChange = matchScore * MATCH_BONUS;
                            self.flipStatus.successfulFlip = YES;
                        } else {
                            otherCard.faceUp = NO;
                            self.score -= MISMATCH_PENALTY;
                            self.flipStatus.pointChange = MISMATCH_PENALTY;
                            self.flipStatus.successfulFlip = NO;
                        }
                        break;
                    }
                } else {
                    if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                        [otherCards addObject:otherCard];
                        if ([otherCards count] == 2) {
                            [self.flipStatus.cardsInvolved addObjectsFromArray:otherCards];
                            int matchScore = [card match:otherCards];
                            if (matchScore) {
                                card.unplayable = YES;
                                for (Card *otherCard in otherCards) {
                                    otherCard.unplayable = YES;
                                }
                                self.score += matchScore * MATCH_BONUS;
                                self.flipStatus.pointChange = matchScore * MATCH_BONUS;
                                self.flipStatus.successfulFlip = YES;
                            } else {
                                for (Card *otherCard in otherCards) {
                                    otherCard.faceUp = NO;
                                }
                                self.score -= MISMATCH_PENALTY;
                                self.flipStatus.pointChange = MISMATCH_PENALTY;
                                self.flipStatus.successfulFlip = NO;
                            }
                            break;
                        }
                    }
                    
                }
                
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.faceUp;
    }
}


@end

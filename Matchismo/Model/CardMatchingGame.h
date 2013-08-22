//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Teddy Wyly on 8/6/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "FlipStatus.h"

@interface CardMatchingGame : NSObject

@property (nonatomic, readonly) int score;
@property (strong, nonatomic) FlipStatus *flipStatus;

// designated initializer
- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck;

// convenience initializer
- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck isTwoCardGame:(BOOL)isTwoCardGame;

- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@end

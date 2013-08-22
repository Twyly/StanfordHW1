//
//  FlipStatus.m
//  Matchismo
//
//  Created by Teddy Wyly on 8/6/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "FlipStatus.h"

@implementation FlipStatus

- (NSMutableArray *)cardsInvolved
{
    if (!_cardsInvolved) _cardsInvolved = [[NSMutableArray alloc] init];
    return _cardsInvolved;
}

@end

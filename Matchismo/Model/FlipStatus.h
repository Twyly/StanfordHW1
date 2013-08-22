//
//  FlipStatus.h
//  Matchismo
//
//  Created by Teddy Wyly on 8/6/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlipStatus : NSObject

@property (strong, nonatomic) NSMutableArray *cardsInvolved;
@property (nonatomic) BOOL successfulFlip;
@property (nonatomic) NSUInteger pointChange;

@end

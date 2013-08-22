//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Teddy Wyly on 8/5/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *history; // of strings

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[PlayingCardDeck alloc] init] isTwoCardGame:(self.segmentedControl.selectedSegmentIndex == 0)];
    return _game;
}

- (NSMutableArray *)history
{
    if (!_history) _history = [[NSMutableArray alloc] init];
    return _history;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)dealButtonPressed:(UIButton *)sender
{
    self.game = nil;
    self.history = nil;
    self.flipCount = 0;
    [self updateUI];
    self.segmentedControl.enabled = YES;
}
- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender
{
    // Only works since segmentedControl is disable.  Otherwise, deal cards should be called.
    self.game = nil;
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    float value = self.slider.value;
    int scaledValue = value * [self.history count];
    if ([self.history count] && scaledValue < [self.history count]) {
        self.lastFlipLabel.text = self.history[scaledValue];
    }
    self.lastFlipLabel.alpha = (scaledValue < [self.history count] - 1) ? 0.5 : 1.0;
    
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    if ([self lastFlipText]) [self.history addObject:[self lastFlipText]];
    [self updateUI];
    self.segmentedControl.enabled = NO;
    
    //slider management
    [self.slider setValue:[self.slider maximumValue]];
    [self sliderValueChanged:nil];
    
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected | UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        UIImage *cardback = [UIImage imageNamed:@"cardbackimage.jpeg"];
        [cardButton setBackgroundImage:(!cardButton.selected ? cardback : nil) forState:UIControlStateNormal];
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.lastFlipLabel.text = [self.history lastObject];
    
    
}

- (NSString *)lastFlipText
{
    NSString *string = nil;
    if ([self.game.flipStatus.cardsInvolved count] == 1) {
        Card *flippedCard = [self.game.flipStatus.cardsInvolved lastObject];
        if (flippedCard.isFaceUp) {
            string = [NSString stringWithFormat:@"Flipped up %@", flippedCard.contents];
        }
    } else if ([self.game.flipStatus.cardsInvolved count] == 2 && self.segmentedControl.selectedSegmentIndex == 0) {
        Card *flippedCard = self.game.flipStatus.cardsInvolved[0];
        Card *otherCard = self.game.flipStatus.cardsInvolved[1];
        if (self.game.flipStatus.successfulFlip) {
            string = [NSString stringWithFormat:@"%@ and %@ match for %i points!", flippedCard.contents, otherCard.contents, self.game.flipStatus.pointChange];
        } else {
            string = [NSString stringWithFormat:@"%@ and %@ don't match! %i point penalty!", flippedCard.contents, otherCard.contents, self.game.flipStatus.pointChange];
        }
    } else if ([self.game.flipStatus.cardsInvolved count] == 3 && self.segmentedControl.selectedSegmentIndex == 1) {
        Card *flippedCard = self.game.flipStatus.cardsInvolved[0];
        Card *secondCard = self.game.flipStatus.cardsInvolved[1];
        Card *thirdCard = self.game.flipStatus.cardsInvolved[2];
        if (self.game.flipStatus.successfulFlip) {
            string = [NSString stringWithFormat:@"%@, %@, and %@ match for %i points!", flippedCard.contents, secondCard.contents, thirdCard.contents, self.game.flipStatus.pointChange];
        } else {
            string = [NSString stringWithFormat:@"%@, %@, and %@ don't match! %i point penalty!", flippedCard.contents, secondCard.contents, thirdCard.contents, self.game.flipStatus.pointChange];
        }
    }
    return string;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

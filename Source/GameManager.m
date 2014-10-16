//
//  GameManager.m
//  Invoke
//
//  Created by James Thompson on 10/14/14.
//  Copyright (c) 2014 IntelligentSprite. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameManager.h"

@interface GameManager ()

@property (nonatomic, strong) NSArray *invokeData;
@property (nonatomic, strong) NSMutableArray *selectedSpells;

@end

@implementation GameManager

- (instancetype)init
{
    if (self = [super init])
    {
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"spells" ofType:@"json"];
        
        NSData *json = [NSData dataWithContentsOfFile:jsonPath];
        
        _invokeData = [NSJSONSerialization JSONObjectWithData:json
                                                      options:0
                                                        error:nil];
        
        _selectedSpells = [NSMutableArray arrayWithCapacity:3];
        
        [self randomizeInvokeSpell];
    }
    
    return self;
}

- (void)progressGameState
{
    if (self.currentState.tag == GameStateThirdSelection)
    {
        // Win/Loss handling.
        GameState *winState = nil;
        GameState *loseState = nil;
        
        for (GameState *state in self.gameStates)
        {
            if (state.tag == GameStateWon)
            {
                winState = state;
            }
            else if (state.tag == GameStateLost)
            {
                loseState = state;
            }
        }
        NSArray *correctCombo = [[self.invokeSpell allValues] firstObject];
        
        if ([self.selectedSpells containsObject:correctCombo[0]] &&
            [self.selectedSpells containsObject:correctCombo[1]] &&
            [self.selectedSpells containsObject:correctCombo[2]])
        {
            self.currentState = winState;
        }
        else
        {
            self.currentState = loseState;
        }
    }
    else
    {
        NSUInteger nextIndex = [self.gameStates indexOfObject:self.currentState] + 1;
                
        self.currentState = self.gameStates[nextIndex];
    }
}

- (void)randomizeInvokeSpell
{
    NSUInteger invokeIndex = arc4random_uniform((u_int32_t)[_invokeData count]);
    
    _invokeSpell = _invokeData[invokeIndex];
}

- (void)reset
{    
    [_selectedSpells removeAllObjects];
    [self randomizeInvokeSpell];
    
    GameState *firstState = [self.gameStates firstObject];
    
    [self.currentState transitionToState:firstState];
    _currentState = firstState;
}

- (void)selectedSpell:(NSString *)spell
{
    NSAssert(spell, @"spell was nil!");
    [_selectedSpells addObject:spell];
    _currentState.contextObject = [UIImage imageNamed:spell];
}

- (void)setCurrentState:(GameState *)currentState
{
    if (_currentState)
    {
        GameState *oldState = _currentState;
        _currentState = currentState;
        
        [oldState transitionToState:currentState];
        return;
    }
    
    // If there was no previous state, start anew.
    _currentState = currentState;
    
    currentState.onEnterBlock(currentState.contextObject);
}

@end

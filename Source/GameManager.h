//
//  GameManager.h
//  Invoke
//
//  Created by James Thompson on 10/14/14.
//  Copyright (c) 2014 IntelligentSprite. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GameState.h"

typedef NS_ENUM(NSInteger, GameStateTag)
{
    GameStateFirstSelection,
    GameStateSecondSelection,
    GameStateThirdSelection,
    GameStateWon,
    GameStateLost
};

@interface GameManager : NSObject

@property (nonatomic, strong) GameState *currentState;
@property (nonatomic, strong) NSArray *gameStates;

@property (nonatomic, readonly) NSDictionary *invokeSpell;

- (void)progressGameState;
- (void)selectedSpell:(NSString *)spell;
- (void)reset;

@end

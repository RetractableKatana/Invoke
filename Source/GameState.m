//
//  GameState.m
//  Invoke
//
//  Created by James Thompson on 10/14/14.
//  Copyright (c) 2014 IntelligentSprite. All rights reserved.
//

#import "GameState.h"

@interface GameState ()

@end

@implementation GameState

- (instancetype)initWithOnEnterBlock:(GameStateBlock)onEnter
                         onExitBlock:(GameStateBlock)onExit
                             context:(id)context
{
    if (self = [super init])
    {
        _onEnterBlock = onEnter;
        _onExitBlock = onExit;
        _contextObject = context;
    } return self;
}

- (void)transitionToState:(GameState *)state
{
    if (self.onExitBlock)
    {
        self.onExitBlock(self.contextObject);
    }
    
    if (state.onEnterBlock)
    {
        state.onEnterBlock(self.contextObject);
    }
}

@end

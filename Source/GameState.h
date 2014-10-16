//
//  GameState.h
//  Invoke
//
//  Created by James Thompson on 10/14/14.
//  Copyright (c) 2014 IntelligentSprite. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GameStateBlock)(id context);

@interface GameState : NSObject

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) id contextObject;
@property (nonatomic, readonly) GameStateBlock onEnterBlock;
@property (nonatomic, readonly) GameStateBlock onExitBlock;


- (instancetype)initWithOnEnterBlock:(GameStateBlock)onEnter
                         onExitBlock:(GameStateBlock)onExit
                             context:(id)context;

- (void)transitionToState:(GameState *)state;

@end

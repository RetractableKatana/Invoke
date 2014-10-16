//
//  ViewController.m
//  Invoke
//
//  Created by James Thompson on 10/14/14.
//  Copyright (c) 2014 IntelligentSprite. All rights reserved.
//

#import "ViewController.h"

#import "GameManager.h"

static NSString * const kHighScoreKey = @"High Score";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *firstSelection;
@property (weak, nonatomic) IBOutlet UIImageView *secondSelection;
@property (weak, nonatomic) IBOutlet UIImageView *thirdSelection;
@property (weak, nonatomic) IBOutlet UIImageView *invokeSpell;
@property (weak, nonatomic) IBOutlet UIButton *quasButton;
@property (weak, nonatomic) IBOutlet UIButton *wexButton;
@property (weak, nonatomic) IBOutlet UIButton *exortButton;
@property (weak, nonatomic) IBOutlet UILabel *livesLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *winStreakLabel;
@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;

@property (nonatomic, strong) NSArray *gameStates;
@property (nonatomic, strong) NSArray *invokeData;

@property (nonatomic) NSInteger winStreak;
@property (nonatomic) NSInteger livesLeft;

@property (nonatomic, strong) GameManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _winStreak = 0;
    _livesLeft = 3;
    
    NSInteger highScore = [[[NSUserDefaults standardUserDefaults] objectForKey:kHighScoreKey] integerValue];
    self.highScoreLabel.text = [NSString stringWithFormat:@"High Score: %ld", (long)highScore];
    
    _manager = [GameManager new];
    
    __weak ViewController *weakSelf = self;
    
    GameState *first =
    [[GameState alloc] initWithOnEnterBlock:^(id context)
     {
         NSDictionary *invokeSpell = _manager.invokeSpell;
         
         weakSelf.firstSelection.image = nil;
         weakSelf.secondSelection.image = nil;
         weakSelf.thirdSelection.image = nil;
         
         weakSelf.invokeSpell.image = [UIImage imageNamed:[[invokeSpell allKeys] firstObject]];
     }
                                onExitBlock:^(UIImage *context)
     {
         weakSelf.firstSelection.image = context;
     }
                                    context:nil];
    
    first.tag = GameStateFirstSelection;
    
    GameState *second =
    [[GameState alloc] initWithOnEnterBlock:nil
                                onExitBlock:^(id context)
     {
         weakSelf.secondSelection.image = context;
     }
                                    context:nil];
    second.tag = GameStateSecondSelection;
    
    GameState *third =
    [[GameState alloc] initWithOnEnterBlock:nil
                                onExitBlock:^(id context)
     {
         weakSelf.thirdSelection.image = context;
     }
                                    context:nil];
    third.tag = GameStateThirdSelection;
    
    GameState *win =
    [[GameState alloc] initWithOnEnterBlock:^(id context)
     {
         self.winStreakLabel.text = [NSString stringWithFormat:@"Win Streak: %ld", ++weakSelf.winStreak];
         
         NSString *winText = [weakSelf.manager killStreakForKills:weakSelf.winStreak];
         
         if (winText == nil)
         {
             winText = @"Correct";
         }
         
         if (weakSelf.winStreak > [[[NSUserDefaults standardUserDefaults] objectForKey:kHighScoreKey] integerValue])
         {
            [[NSUserDefaults standardUserDefaults] setObject:@(weakSelf.winStreak)
                                                      forKey:kHighScoreKey];
             weakSelf.highScoreLabel.text = [NSString stringWithFormat:@"High Score: %ld", (long)weakSelf.winStreak];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
         
         // Animate the Win label.
         UILabel *winLabel = [[UILabel alloc] initWithFrame:CGRectZero];
         winLabel.text = winText;
         [weakSelf.view addSubview:winLabel];
         [winLabel sizeToFit];
         winLabel.center = weakSelf.view.center;
         winLabel.textColor = [UIColor greenColor];
         winLabel.alpha = 0.0;
         
         [UIView animateWithDuration:1.0
                               delay:0.0
              usingSpringWithDamping:0.25
               initialSpringVelocity:0.5
                             options:UIViewAnimationOptionCurveEaseInOut
                          animations:^{
                              winLabel.alpha = 1.0;
                              winLabel.transform = CGAffineTransformScale(winLabel.transform, 2.0, 2.0);
                          }
                          completion:^(BOOL finished) {
                              
                              [UIView animateWithDuration:0.25
                                               animations:^{
                                                   winLabel.alpha = 0.0;
                                               }
                                               completion:^(BOOL finished) {
                                                   [winLabel removeFromSuperview];
                                                   [_manager reset];
                                               }];
                          }];
     }
                                onExitBlock:nil
                                    context:nil];
    win.tag = GameStateWon;
    
    GameState *lose =
    [[GameState alloc] initWithOnEnterBlock:^(id context)
     {
         weakSelf.winStreak = 0;
         [weakSelf.manager resetKillStreak];
         
         NSString *loseString = @"Wrong";
         NSTimeInterval animDur = 1.0;
         
         BOOL gameOver = MAX(--weakSelf.livesLeft, 0) == 0;
         
         if (gameOver)
         {
             loseString = @"Game Over!";
             animDur = 3.0;
         }
        
         weakSelf.livesLeftLabel.text = [NSString stringWithFormat:@"Lives Left:   %ld", (gameOver) ? 0 :(long)weakSelf.livesLeft];
         weakSelf.winStreakLabel.text = [NSString stringWithFormat:@"Win Streak: %ld", (long)weakSelf.winStreak];
         
         UILabel *loseLabel = [[UILabel alloc] initWithFrame:CGRectZero];
         loseLabel.text = loseString;
         [weakSelf.view addSubview:loseLabel];
         [loseLabel sizeToFit];
         loseLabel.center = weakSelf.view.center;
         loseLabel.textColor = [UIColor redColor];
         loseLabel.alpha = 0.0;
         
         [UIView animateWithDuration:animDur
                               delay:0.0
              usingSpringWithDamping:0.25
               initialSpringVelocity:0.5
                             options:UIViewAnimationOptionCurveEaseInOut
                          animations:^{
                              loseLabel.alpha = 1.0;
                              loseLabel.transform = CGAffineTransformScale(loseLabel.transform, 2.0, 2.0);
                          }
                          completion:^(BOOL finished) {
                              
                              [UIView animateWithDuration:0.25
                                               animations:^{
                                                   loseLabel.alpha = 0.0;
                                               }
                                               completion:^(BOOL finished) {
                                                   [loseLabel removeFromSuperview];
                                                   if (gameOver)
                                                   {
                                                       weakSelf.livesLeft = 3;
                                                       weakSelf.livesLeftLabel.text = [NSString stringWithFormat:@"Lives Left:   %ld",(long)weakSelf.livesLeft];

                                                   }
                                                   [weakSelf.manager reset];
                                               }];
                          }];
     }
                                onExitBlock:nil
                                    context:nil];
    lose.tag = GameStateLost;
    
    _manager.currentState = first;
    
    _manager.gameStates = @[first, second, third, win, lose];
}

- (IBAction)quasTapped:(UIButton *)sender
{
    [self.manager selectedSpell:@"Quas"];
    [self.manager progressGameState];
}

- (IBAction)wexTapped:(UIButton *)sender
{
    [self.manager selectedSpell:@"Wex"];
    [self.manager progressGameState];
}

- (IBAction)exortTapped:(UIButton *)sender
{
    [self.manager selectedSpell:@"Exort"];
    [self.manager progressGameState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  GameDelegate.h
//  iReversi
//
//  Created by Vivek on 19/09/16.
//  Copyright © 2016 Vivek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"

@protocol GameDelegate <NSObject>

-(CellState) getPlayerState;
-(void) notifyUpdateFor:(NSIndexPath *) indexPath andState:(CellState) state;
-(CellState) getStateFor:(NSIndexPath *) indexPath;
-(void) recalculateScore;
-(void) setPlayerState:(CellState) state;
-(void) setGameState:(GameState) state;
-(BOOL) isPlayerTurn;
-(void) startSharingGame:(UIImage *)shareableImage;
-(ResultState) getMatchStateForPlayer;
-(BOOL) isGameOver;
-(void) startNewGame;
-(void) continueGame;
@end

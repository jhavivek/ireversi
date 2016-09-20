//
//  Game.h
//  iReversi
//
//  Created by Vivek on 18/09/16.
//  Copyright © 2016 Vivek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, GameState) {
    GameStateInit,
    GameStateInProgress,
    GameStateComplete
};

typedef NS_ENUM(NSInteger, CellState) {
    CellStateNone,
    CellStateBlack,
    CellStateWhite
};

typedef NS_ENUM(NSInteger, ResultState) {
    ResultStateTie,
    ResultStateWin,
    ResultStateLoss
};

@interface Game : NSObject

@property GameState currentState;
@property NSInteger whiteScore;
@property NSInteger blackScore;
@property CellState currentPlayer;
@property NSUUID* whitePlayerId;

-(void) clearBoard;
-(void) setBoardValueFor:(NSIndexPath *) indexPath withState:(CellState) state;
-(CellState) getBoardValueFor:(NSIndexPath *) indexPath;
-(NSArray<NSURLQueryItem *> *) getQueryItems;
-(void) setWithQueryItems:(NSArray<NSURLQueryItem *> *) queryItems;

-(void) recalculateScore;

@end

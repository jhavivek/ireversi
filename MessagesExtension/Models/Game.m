//
//  Game.m
//  iReversi
//
//  Created by Vivek on 18/09/16.
//  Copyright © 2016 Vivek. All rights reserved.
//

#import "Game.h"

@implementation Game

static const NSString * boardValKey = @"boardValKey";
static const NSString * gameStateKey = @"gameStateKey";
static const NSString * currentPlayerKey = @"currentPlayerKey";
static const NSString * whitePlayerKey = @"whitePlayerKey";


int board[8][8];
//assign as board[i][j]

-(void) clearBoard{
    for(int i =0; i < 8; i++){
        for(int j = 0; j < 8; j++){
            board[i][j] = 0;//White-1, Black 2
        }
    }
    //center 4 tiles
    board[3][3] = board[4][4] = 1;
    board[3][4] = board[4][3] = 2;
    
}

-(void) setBoardValueFor:(NSIndexPath *) indexPath withState:(CellState) state{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch(state){
        case CellStateNone:
            board[section][row] = 0;
            break;
        case CellStateWhite:
            board[section][row] = 1;
            break;
        case CellStateBlack:
            board[section][row] = 2;
            break;
    }
}

-(CellState) getBoardValueFor:(NSIndexPath *) indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    int value = board[section][row];
    switch(value){
        case 0:
            return CellStateNone;
        case 1:
            return CellStateWhite;
        case 2:
            return CellStateBlack;
    }
    return CellStateNone;
}

-(NSArray<NSURLQueryItem *> *) getQueryItems{
    NSURLQueryItem * boardValItem = [NSURLQueryItem queryItemWithName:boardValKey value:[self encodedBoardValues]];
    NSURLQueryItem * gameStateItem = [NSURLQueryItem queryItemWithName:gameStateKey value:[self stringForGameState]];
    NSURLQueryItem * playerStateItem = [NSURLQueryItem queryItemWithName:currentPlayerKey value:[self stringForPlayerState]];
    NSURLQueryItem * playerItem = [NSURLQueryItem queryItemWithName:whitePlayerKey value:[self.whitePlayerId UUIDString]];
    return [NSArray arrayWithObjects:boardValItem, gameStateItem, playerStateItem, playerItem, nil];
}

-(void) setWithQueryItems:(NSArray<NSURLQueryItem *> *) queryItems{
    for(NSURLQueryItem * item in queryItems){
        NSString * name = item.name;
        NSString * value = item.value;
        
        if([name isEqualToString:boardValKey]){
            [self decodeBoardValues:value];
        } else if([name isEqualToString:gameStateKey]){
            [self updateGameState:value];
        } else if([name isEqualToString:currentPlayerKey]){
            [self updateUserState:value];
        } else if([name isEqualToString:whitePlayerKey]){
            self.whitePlayerId = [[NSUUID alloc] initWithUUIDString:value];
        }
    }
}

-(void) recalculateScore{
    self.whiteScore = 0;
    self.blackScore = 0;
    for(int i =0; i < 8; i++){
        for(int j = 0; j < 8; j++){
            if(board[i][j] == 1){
                self.whiteScore++;
            } else if(board[i][j] == 2){
                self.blackScore++;
            }
        }
    }
}

#pragma mark Private Helper methods
-(NSString *) encodedBoardValues{
    //[NSArray componentsJoinedByString:]. works with 1d NSArray
    NSMutableString * stringVal = [NSMutableString new];
    for(int i =0; i < 8; i++){
        for(int j = 0; j < 8; j++){
            [stringVal appendFormat:@"%d:",board[i][j]];
        }
    }
    return [stringVal substringToIndex:stringVal.length - 1];
}

-(void) decodeBoardValues:(NSString *) value{
    NSArray<NSString *> * boardValues = [value componentsSeparatedByString:@":"];
    for(int i = 0; i < boardValues.count ; i++){
        board[i/8][i % 8] = [boardValues[i] intValue];
    }
}

-(NSString *) stringForGameState{
    switch(self.currentState){
        case GameStateInit:
            return @"GameStateInit";
        case GameStateInProgress:
            return @"GameStateInProgress";
        case GameStateComplete:
            return @"GameStateComplete";
    }
}

-(void) updateGameState:(NSString *) value{
    if([value isEqualToString:@"GameStateInit"]){
        self.currentState = GameStateInit;
    } else if([value isEqualToString:@"GameStateInProgress"]){
        self.currentState = GameStateInProgress;
    } else if([value isEqualToString:@"GameStateComplete"]){
        self.currentState = GameStateComplete;
    }
}

-(NSString *) stringForPlayerState{
    switch(self.currentPlayer){
        case CellStateWhite:
            return @"CellStateWhite";
        case CellStateBlack:
            return @"CellStateBlack";
        case CellStateNone:
            return @"CellStateNone";
    }
}

-(void) updateUserState:(NSString *) value{
    if([value isEqualToString:@"CellStateNone"]){
        self.currentPlayer = CellStateNone;
    } else if([value isEqualToString:@"CellStateWhite"]){
        self.currentPlayer = CellStateWhite;
    } else if([value isEqualToString:@"CellStateBlack"]){
        self.currentPlayer = CellStateBlack;
    }
}

@end

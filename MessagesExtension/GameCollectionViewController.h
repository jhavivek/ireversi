//
//  GameCollectionViewController.h
//  iReversi
//
//  Created by Vivek on 18/09/16.
//  Copyright © 2016 Vivek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "GameDelegate.h"

@interface GameCollectionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
//GameDelegate
@property (weak, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *boardBGImageView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *turnImage;
@property (weak, nonatomic) IBOutlet UIImageView *playerImage;

@property  CellState turnState;
@property  CellState playerState;

-(void) updateTurnState:(CellState) state;
-(void) updatePlayerState:(CellState) state;


@end

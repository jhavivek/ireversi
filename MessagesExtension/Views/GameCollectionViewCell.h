//
//  GameCollectionViewCell.h
//  iReversi
//
//  Created by Vivek on 18/09/16.
//  Copyright © 2016 Vivek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface GameCollectionViewCell : UICollectionViewCell

//initialize to none
@property CellState currentState;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

-(void) setCurrentState:(CellState)currentState;

@end

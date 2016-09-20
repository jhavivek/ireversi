//
//  GameCollectionViewCell.m
//  iReversi
//
//  Created by Vivek on 18/09/16.
//  Copyright © 2016 Vivek. All rights reserved.
//

#import "GameCollectionViewCell.h"

@implementation GameCollectionViewCell

-(void) awakeFromNib{
    [super awakeFromNib];
    [self layoutIfNeeded];
}

-(void) setCurrentState:(CellState)currentState{
    _currentState = currentState;
    //update Image
    switch (_currentState) {
        case CellStateNone:
            self.cellImageView.image = nil;
            self.cellImageView.hidden = YES;
            break;
        case CellStateBlack:
            self.cellImageView.image = [UIImage imageNamed:@"Black-tile"];
            self.cellImageView.hidden = NO;
            break;
        case CellStateWhite:
            self.cellImageView.image = [UIImage imageNamed:@"White-tile"];
            self.cellImageView.hidden = NO;
            break;
    }
}

@end

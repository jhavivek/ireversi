//
//  GameCollectionViewController.m
//  iReversi
//
//  Created by Vivek on 18/09/16.
//  Copyright © 2016 Vivek. All rights reserved.
//

#import "GameCollectionViewController.h"
#import "GameCollectionViewCell.h"

@interface GameCollectionViewController ()

@end

@implementation GameCollectionViewController

static NSString * const reuseIdentifier = @"gameCell";

static NSInteger const boardSize = 8; /// need to declare as extern game also uses this

UIImage * screenshot;
//TODO: Handle screenwidth based logic - later
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    float screenDimension = size.width;
    if(size.height < screenDimension){
        screenDimension = size.height;
    }
    screenDimension = screenDimension - 50; //32 is required for border rest just padding
    int cellSize = (screenDimension - 35)/8;
    
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flow.itemSize = CGSizeMake(cellSize, cellSize);
    flow.minimumInteritemSpacing = 5.0;
    flow.footerReferenceSize = CGSizeMake(screenDimension, 2.5);
    flow.headerReferenceSize = CGSizeMake(screenDimension, 2.5);
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.scrollEnabled = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //[self.collectionView setContentInset:UIEdgeInsetsMake(-87, 0, 0, 0)];//can anyone explain 87
    [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];//can anyone explain 87
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.heightConstraint.constant = screenDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return boardSize;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return boardSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GameCollectionViewCell *cell = (GameCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    CellState state = [self.delegate getStateFor:indexPath];
    if(state != CellStateNone){
        NSLog(@"");
    }
    cell.currentState = state;
    
    if(indexPath.section % 2 == indexPath.row % 2){
        cell.backgroundColor = [UIColor lightGrayColor];
    } else {
        cell.backgroundColor = [UIColor yellowColor];
    }
    
    return cell;
}

/*
#pragma mark <UICollectionViewFlowDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(35.0, 35.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(320.0, 2.5);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(320.0, 2.5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5.0;
}
*/

#pragma mark <UICollectionViewDelegate>

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self checkAndMove:indexPath];
}

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

#pragma mark Move Logic
//disable after one tap
-(void) checkAndMove:(NSIndexPath *) indexPath{
    //Add a game delegate and MVC will be set as that
    CellState currentState = [self.delegate getPlayerState];
    
    if(![self.delegate isPlayerTurn]){
        [self showAlertMessage:@"Invalid Move!" andText:@"It's not your turn now"];
        return;
    }
    
    //It can't come here if game is complete
    [self.delegate setGameState:GameStateInProgress];
    
    CellState opponentState = CellStateNone;
    switch (currentState) {
        case CellStateWhite:
            opponentState = CellStateBlack;
            break;
        case CellStateBlack:
            opponentState = CellStateWhite;
            break;
        default:
            break;
    }
    
    if([self isValidMove:indexPath forCellState:currentState]){
        
        //1. make moves/flips across board
        [self makeMovesWith:indexPath andState:currentState];
        //1.2 Get ScreenShot
        
        [self performSelectorOnMainThread:@selector(getScreenshot) withObject:nil waitUntilDone: YES];
        
        //2. recalculate score - Notify MVC
        [self.delegate recalculateScore];
        
        //3. check If move possible for opponent
        if([self isMovePossibleFor:opponentState]){
            //3.a Break if possible
            //I hate runtime errors :(
            [self.delegate setPlayerState:opponentState];
            [self.delegate startSharingGame:screenshot];
            return;
        }
        
        //3.b  check if move possible at all
        if([self isMovePossible]){
            //3.b.1 If yes - alert user to make another move
            [self showAlertMessage:@"Make Another Move!" andText:@"No more moves for your opponent!"];
        } else {
            //3.b.2 Alert that game has completed - show results and send to both players
            [self.delegate setPlayerState:CellStateNone];
            [self.delegate setGameState:GameStateComplete];
            ResultState state = [self.delegate getMatchStateForPlayer];
            switch(state){
                case ResultStateLoss:
                    [self showAlertMessage:@"Uh Oh!" andText:@"Better luck next time!"];
                    break;
                case ResultStateTie:
                    [self showAlertMessage:@"Match Tied" andText:@"Damn close!"];
                    break;
                case ResultStateWin:
                    [self showAlertMessage:@"Congratulations!" andText:@"You beat your opponent!"];
                    break;
            }
            
            //To show all moves - we have to move it out but since we are showing only 1 message that's not required
            [self.delegate startSharingGame:screenshot];
        }
        
        
        
        //We may need timeout later
    } else {
        //Alert invalid move - maybe multi check required
        [self showAlertMessage:@"Invalid Move!" andText:@"Please Make another move."];
    }
}

-(void) makeMovesWith:(NSIndexPath *) indexPath andState:(CellState) state{
    
    [self setCellStateFor:indexPath andCellState:state];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    for (NSInteger xinc=-1; xinc<=1; xinc++){
        for (NSInteger yinc=-1; yinc<=1; yinc++){
            if (xinc != 0 || yinc != 0)
            {
                NSInteger x, y;
                //I think I am using it in reverse --- maybe inequeality is enought
                for (x = section+xinc, y = row+yinc; x < boardSize && y< boardSize && [self cellOccupiedByOpponentFor:[NSIndexPath indexPathForRow:y inSection:x] forCellState:state];
                     x += xinc, y += yinc)
                    ;
                
                if ([self cellOccupiedByPlayerFor:[NSIndexPath indexPathForRow:y inSection:x] forCellState:state] &&
                    (x - xinc != section || y - yinc != row)){
                    
                    x -= xinc; y -=yinc;
                    while(x != section || y != row){
                        //flip cells
                        [self setCellStateFor:[NSIndexPath indexPathForRow:y inSection:x] andCellState:state];
                        x -= xinc; y -=yinc;
                    }
                }
            }
        }
    }
}

-(BOOL) isMovePossible{
    return [self isMovePossibleFor:CellStateWhite] || [self isMovePossibleFor:CellStateBlack];
}

-(BOOL) isMovePossibleFor:(CellState) cellState{
    for(NSInteger x = 0; x < boardSize; x++){
        for(NSInteger y = 0; y < boardSize; y++){
            if([self isValidMove:[NSIndexPath indexPathForRow:y inSection:x] forCellState:cellState])
                return YES;
        }
    }
    return NO;
}

-(BOOL) isValidMove:(NSIndexPath *) indexPath forCellState:(CellState) cellState{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    GameCollectionViewCell *currentCell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    if(currentCell.currentState == CellStateNone){
        for (NSInteger xinc=-1; xinc<=1; xinc++){
            for (NSInteger yinc=-1; yinc<=1; yinc++){
                if (xinc != 0 || yinc != 0)
                {
                    NSInteger x, y;
                    //I think I am using it in reverse --- maybe inequeality is enought
                    for (x = section+xinc, y = row+yinc; x < boardSize && y< boardSize && [self cellOccupiedByOpponentFor:[NSIndexPath indexPathForRow:y inSection:x] forCellState:cellState];
                         x += xinc, y += yinc)
                        ;
                    
                    if ([self cellOccupiedByPlayerFor:[NSIndexPath indexPathForRow:y inSection:x] forCellState:cellState] &&
                        (x - xinc != section || y - yinc != row)){
                        return YES;
                    }
                }
            }
        }
        
    }
    //else occupied cell
    return NO;
}

-(BOOL) cellOccupiedByPlayerFor:(NSIndexPath *) indexPath forCellState:(CellState) playerState{
    GameCollectionViewCell *currentCell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if(currentCell.currentState == CellStateNone)
        return NO;
    else
        return currentCell.currentState == playerState;
}

-(BOOL) cellOccupiedByOpponentFor:(NSIndexPath *) indexPath forCellState:(CellState) playerState{
    GameCollectionViewCell *currentCell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if(currentCell.currentState == CellStateNone)
        return NO;
    else
        return currentCell.currentState != playerState;
}

-(void) setCellStateFor:(NSIndexPath *) indexPath andCellState:(CellState) playerState {
    GameCollectionViewCell *currentCell = [self.collectionView cellForItemAtIndexPath:indexPath];
    currentCell.currentState = playerState;
    //notify deleagte to update board
    [self.delegate notifyUpdateFor:indexPath andState:playerState];
}

#pragma mark - Screenshot
-(void) getScreenshot{
    CGRect rect = [self.mainView bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    [self.mainView drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    screenshot = capturedImage;
}

#pragma mark - Alert
-(void) showAlertMessage:(NSString *)title andText:(NSString *) text{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:text
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok!"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [alert removeFromParentViewController];
                                    //Handle your yes please button action here
                                }];
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end

//
//  SummaryViewController.h
//  iReversi
//
//  Created by Vivek on 18/09/16.
//  Copyright © 2016 Vivek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameDelegate.h"

@interface SummaryViewController : UIViewController

- (IBAction)startNewGame:(id)sender;
- (IBAction)continueGame:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)sendAttachment:(id)sender;
- (IBAction)sendVideo:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *gameView;



@property (weak, nonatomic) id delegate;

@end

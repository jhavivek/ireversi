//
//  SummaryViewController.m
//  iReversi
//
//  Created by Vivek on 18/09/16.
//  Copyright © 2016 Vivek. All rights reserved.
//

#import "SummaryViewController.h"

@interface SummaryViewController ()

@end

@implementation SummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //get game state and hide/unhide buttons
    if([self.delegate isGameOver]){
        self.titleLabel.text = @"Start New Game!";
        self.continueButton.hidden = YES;
        self.startGameButton.hidden = NO;
    } else {
        self.titleLabel.text = @"Continue!";
        self.continueButton.hidden = NO;
        self.startGameButton.hidden = YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)startNewGame:(id)sender {
    [self.delegate startNewGame];
}

- (IBAction)continueGame:(id)sender {
    [self.delegate continueGame];
}
@end

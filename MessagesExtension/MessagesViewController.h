//
//  MessagesViewController.h
//  MessagesExtension
//
//  Created by Vivek on 18/09/16.
//  Copyright © 2016 Vivek. All rights reserved.
//

#import <Messages/Messages.h>
#import "Game.h"
#import "GameDelegate.h"

@interface MessagesViewController : MSMessagesAppViewController <GameDelegate>

@property Game * currentGame;

@end

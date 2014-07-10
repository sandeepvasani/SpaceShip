//
//  GameplayLayer.h
//  SpaceShip
//
//  Created by macuser2 on 3/18/14.
//  Copyright Sandeep 2014. All rights reserved.

#import "CCLayer.h"
#import "cocos2d.h"

@interface GameplayLayer : CCLayer
{
    CCSprite* ship;
	CCArray *_shipBullets;
	int _nextshipBullet;
	double startTime;
	CCSprite *bird;
    CCSprite *fallbird;
	NSMutableArray *flyAnimFrames;
	NSMutableArray *fallAnimFrames;
	CGSize size;
  //  CCAction *birdleftmoveAction;
  //  CCAction *birdrightmoveAction;
 
}
//@property (nonatomic, strong) CCAction *birdmoveAction;

@end

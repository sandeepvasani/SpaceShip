//
//  GameplayLayer.m
//  SpaceShip
//
//  Created by macuser2 on 3/18/14.
//  Copyright Sandeep 2014. All rights reserved.

#import "GameplayLayer.h"
#import "GameOverScene.h"

#define kNumBullets	5

@implementation GameplayLayer

-(id)init {
    self = [super init];
    if (self != nil) {
        ship = [CCSprite spriteWithFile:@"spaceship.png"];
        size = [[CCDirector sharedDirector] winSize];
		[ship setPosition:ccp(size.width/2,ship.contentSize.width/2)];
		[self addChild:ship];
        
		
		
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"flying.plist"];
	CCSpriteBatchNode *flyingspriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"flying.png"];
	[self addChild:flyingspriteSheet];
	
	flyAnimFrames = [NSMutableArray array];
	for (int i=0; i<=8; i++) {
    [flyAnimFrames addObject:
        [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
            [NSString stringWithFormat:@"flying_%d.png",i]]];
	}

	CCAnimation *flyAnim = [CCAnimation animationWithSpriteFrames:flyAnimFrames delay:0.1f];
	
	
bird = [CCSprite spriteWithSpriteFrameName:@"flying_0.png"];
bird.position = ccp(size.width/2, size.height*0.8);
CCAction *flyAction = [CCRepeatForever actionWithAction:
    [CCAnimate actionWithAnimation:flyAnim]];
[bird runAction:flyAction];
[flyingspriteSheet addChild:bird];


	//self.birdmoveAction=[CCMoveTo actionWithDuration:1.5 position:ccp(size.width,bird.position.y)];
//	[bird runAction:self.birdmoveAction];
        id flipX_YES = [CCFlipX actionWithFlipX:YES];
        id flipX_NO = [CCFlipX actionWithFlipX:NO];
        
            id   birdleftmoveAction=[CCMoveTo actionWithDuration:3 position:ccp(0,bird.position.y)];
            id birdrightmoveAction=[CCMoveTo actionWithDuration:3 position:ccp(size.width,bird.position.y)];
            id seq=[CCSequence actions:flipX_YES,birdleftmoveAction,flipX_NO,birdrightmoveAction,nil];
            id repeat =[CCRepeatForever actionWithAction:seq];
            [bird runAction:repeat];
        
        
        

                
	_shipBullets = [[CCArray alloc] initWithCapacity:kNumBullets];
	for(int i = 0; i < kNumBullets; ++i) 
	{
		CCSprite *shipBullet = [CCSprite spriteWithFile:@"bullet.png"];
		shipBullet.visible = NO;
		[self addChild:shipBullet];
		[_shipBullets addObject:shipBullet];
	}
	//	startTime=CACurrentMediaTime();	
        self.touchEnabled = YES;
        [self scheduleUpdate];

    }
    return self;
}


-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace: touch];
    CGPoint shiptop=ccp(ship.contentSize.width,ship.contentSize.height);
    CGPoint diff = ccpSub(location,shiptop);
    
	 CCSprite *shipBullet = [_shipBullets objectAtIndex:_nextshipBullet];
    _nextshipBullet++;
    if (_nextshipBullet >= _shipBullets.count) _nextshipBullet = 0;
	
	shipBullet.position = ccpAdd(ship.position, ccp(0,shipBullet.contentSize.height/2));
	shipBullet.visible = YES;
	[ship stopAllActions];
	[shipBullet stopAllActions];
		
    //CGPoint destination;
	
	CGSize winSize = [[CCDirector sharedDirector]winSize];
        
 //   float speed=50.0;
  //  float duration=ccpDistance(location, ship.position)/speed;
	
	
	    
    if(diff.x>0)
    {
        if(diff.y<=0)
        {
            //move to right code
            NSLog(@"right");
            shipBullet.visible = NO;
            id shipmoveAction = [CCMoveTo actionWithDuration:0.5 position:ccp(location.x,ship.position.y)];
            [ship runAction:shipmoveAction];
            
        }
        else
        {
           //fire code
		   [shipBullet runAction:[CCSequence actions:
                          [CCMoveBy actionWithDuration:4 position:ccp(0, winSize.height)],
                          [CCCallFuncN actionWithTarget:self selector:@selector(setInvisible:)],
                          nil]];
           
        }
    
    
    }
    else
    {
        if(diff.y<=0)
        {
            //move left
            shipBullet.visible = NO;
            id shipmoveAction = [CCMoveTo actionWithDuration:0.5 position:ccp(location.x,ship.position.y)];
            [ship runAction:shipmoveAction];
           
        
        }
        else
        {
           //fire
            [shipBullet runAction:[CCSequence actions:
                          [CCMoveBy actionWithDuration:4 position:ccp(0, winSize.height)],
                          [CCCallFuncN actionWithTarget:self selector:@selector(setInvisible:)],
                          nil]];

        }
    
    
    }

 
    
	
}

- (void)setInvisible:(CCNode *)node {
    node.visible = NO;
}

-(void) fall
{
      
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spinning.plist"];
	CCSpriteBatchNode *fallingspriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"spinning.png"];
	[self addChild:fallingspriteSheet];
	
	fallAnimFrames = [NSMutableArray array];
	for (int i=0; i<=14; i++) {
    [fallAnimFrames addObject:
        [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
            [NSString stringWithFormat:@"spinning_%d.png",i]]];
	}

	CCAnimation *fallAnim = [CCAnimation animationWithSpriteFrames:fallAnimFrames delay:0.1f];
	
	
fallbird = [CCSprite spriteWithSpriteFrameName:@"spinning_0.png"];
fallbird.position = bird.position;
CCAction *fallAction = [CCRepeatForever actionWithAction:
    [CCAnimate actionWithAnimation:fallAnim]];
[fallbird runAction:fallAction];
[fallingspriteSheet addChild:fallbird];


	id birdmoveAction=[CCMoveTo actionWithDuration:3 position:ccp(fallbird.position.x,0)];
    CCCallFunc *scenechange = [CCCallFunc actionWithTarget:self selector:@selector(repscene)];
    
    id seq =[CCSequence actions:birdmoveAction,scenechange, nil];
    [fallbird runAction:seq];
    
}

-(void)repscene
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameOverScene node] ]];

}

-(void)update:(ccTime)delta
{

  /* // NSLog(@"position:%f",bird.position.x);
	if(bird.position.x+bird.contentSize.width/2>=size.width)
	{
        NSLog(@"move left");
       // [bird stopAllActions];//self.birdmoveAction
       [bird stopAction:birdrightmoveAction];
		bird.flipX=YES;
		 birdleftmoveAction=[CCMoveTo actionWithDuration:3 position:ccp(0,bird.position.y)];
		[bird runAction:birdleftmoveAction];
        
        
	}
	
	if(bird.position.x+bird.contentSize.width/2<=0)
	{
        
        [bird stopAction:birdleftmoveAction];
        //[bird stopAllActions];
		bird.flipX=NO;
		 birdrightmoveAction=[CCMoveTo actionWithDuration:3 position:ccp(size.width,bird.position.y)];
		[bird runAction:birdrightmoveAction];
        
	}
    */
    
	
   for (CCSprite *shipBullet in _shipBullets) {                        
        if (!shipBullet.visible) continue;
 
        if (CGRectIntersectsRect(shipBullet.boundingBox, bird.boundingBox)) {
			bird.visible=NO;
			shipBullet.visible = NO;
           [self fall];
           // NSLog(@"collision");
        }
    }
	    
      
    
}

@end

//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene
{
    CCNode* _myGameLayer;
    CCNode* _gameContent;
    CCPhysicsNode* _physicsNode;
    CCNode* _levelNode;
    CCSprite* _spoon;
    NSTimer *_timer;
    int gamecount;
}
-(void)onEnter
{
    [super onEnter];

    _spoon = (CCSprite*)[CCBReader load:@"Spoon"];
    _spoon.position = ccp(100,-300);
    [_physicsNode addChild:_spoon];
    


}
-(void)update:(CCTime)delta{
    gamecount++;
    if(/*condition for going down*/gamecount<500)
    {
        if(gamecount%20==19)
        {
            CCSprite* ingredient = (CCSprite*)[CCBReader load:@"Object"];
            ingredient.position = ccp(arc4random()%400,_spoon.position.y-200);
            [_physicsNode addChild:ingredient];
            [[ingredient physicsBody] setVelocity:CGPointMake(-100, 0)];
        }
        self.position  = ccp(self.position.x,self.position.y+2.0);
        _spoon.position = ccp(_spoon.position.x,_spoon.position.y-2.0);
    }
    else
    {
        self.position  = ccp(self.position.x,self.position.y-2.0);
        _spoon.position = ccp(_spoon.position.x,_spoon.position.y+2.0);
    }
}

-(void)moveIngredientRight: (CCSprite *) ingredient{
    [[ingredient physicsBody] setVelocity:CGPointMake(-100, 0)];
}

-(void)moveIngredientLeft: (CCSprite *) ingredient{
    
    [[ingredient physicsBody] setVelocity:CGPointMake(-100, 0)];
}

@end

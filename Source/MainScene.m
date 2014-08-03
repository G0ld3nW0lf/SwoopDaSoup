//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Ingredient.h"
@implementation MainScene
{
    CCPhysicsNode* _physicsNode;
    CCSprite* _spoon;
    NSTimer *_timer;
    int _gamecount;
}
-(void)onEnter
{
    [super onEnter];

    _spoon = (CCSprite*)[CCBReader load:@"Spoon"];
    _spoon.position = ccp(100,-300);
    [_physicsNode addChild:_spoon];
    


}
-(void)update:(CCTime)delta{
    _gamecount++;
    if(/*condition for going down*/_gamecount<500)
    {
        if(_gamecount%20==19)
        {
            
            Ingredient* ingredient = (Ingredient*)[CCBReader load:@"Ingredient"];
            ingredient.physicsBody.sensor = YES;
            ingredient.position = ccp(arc4random()%400,_spoon.position.y-200);
            [_physicsNode addChild:ingredient];
            int rand = arc4random() % 2;
            if(rand == 0){
                [self moveIngredientRight:ingredient];
            }else{
                [self moveIngredientLeft:ingredient];
            }
            
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

-(void)moveIngredientRight: (Ingredient *) ingredient{
    [[ingredient physicsBody] setVelocity:CGPointMake(100, 0)];
    [self performSelector:@selector(moveIngredientLeft:) withObject:ingredient afterDelay
                         :2.0];
}

-(void)moveIngredientLeft: (Ingredient *) ingredient{
    
    [[ingredient physicsBody] setVelocity:CGPointMake(-100, 0)];
    [self performSelector:@selector(moveIngredientRight:) withObject:ingredient afterDelay
                         :2.0];
}

@end

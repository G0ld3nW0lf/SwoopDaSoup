//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Ingredient.h"
#import <CoreMotion/CoreMotion.h>
#import "CCPhysics+ObjectiveChipmunk.h"
@implementation MainScene
{
    CMMotionManager *_motionManager;
    CCPhysicsNode* _physicsNode;
    CCSprite* _spoon;
    NSTimer *_timer;
    int _gamecount;
    BOOL _goUp;
    CCLabelTTF* _depth;
    NSString* _mydepth;
    NSMutableArray* _collectedIngridients;
    BOOL _gameEnded;
    BOOL _atRightBound;
    BOOL _atLeftBound;
}

-(id)init{
    self = [super init];
    
    if(self){
        _motionManager = [[CMMotionManager alloc]init];
        
    }
    
    return self;
}
-(void)didLoadFromCCB{
    _collectedIngridients = [NSMutableArray array];
    _physicsNode.collisionDelegate = self;
}

-(void)onEnter
{
    [super onEnter];
    
    [_motionManager startAccelerometerUpdates];
    _spoon = (CCSprite*)[CCBReader load:@"Spoon"];
    _spoon.position = ccp(100,-300);
    [_physicsNode addChild:_spoon];
    
}

-(void)onExit{
    [super onExit];
    
    [_motionManager stopAccelerometerUpdates];
    
}
-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair food:(CCNode *)nodeA spoon:(CCNode *)nodeB
{
    
    if(!_goUp)
    {
        _goUp = true;
    }
    else
    {
        /*
         Code for what to do when collding with food objects on the way up
         */
        [_collectedIngridients addObject:nodeA];
        [nodeA removeFromParent];
    }
    return true;
}
-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair surface:(CCNode *)nodeA spoon:(CCNode *)nodeB
{
    if(_goUp&&!_gameEnded)
    {
        /*DO NOT REMOVE*/[NSObject cancelPreviousPerformRequestsWithTarget:self];
        _gameEnded = true;
        [_spoon.physicsBody setVelocity:ccp(0,0)];
        
        [self processCaughtIngridients];
        
        
    }
    
    return true;
}
-(void)update:(CCTime)delta{
    if(!_gameEnded)
    {
        
        
        [self updateSpoonWithAccelerometerData];
        
        _gamecount++;
        
        _depth.string = [NSString stringWithFormat:@"%d",_gamecount];
        
        if(!_goUp)
        {
            if(_gamecount%20==19)
            {
                
                [self spawnIngridient];
                
            }
            
        }
        [self moveSpoon];
        [self followCamera];
        [self limitMovement];
    }
}
-(void)processCaughtIngridients
{
    for(int i = 0;i<_collectedIngridients.count;i++)
    {
        NSLog(@"porcessed ingridient");
    }
}
-(void)updateSpoonWithAccelerometerData
{
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    NSLog(@"x: %f", acceleration.x);
    if(!_atRightBound&&acceleration.x > 0){
        [[_spoon physicsBody] setVelocity:CGPointMake(100, 0)];
        if(_atLeftBound)
        {
            _atLeftBound = false;
            _spoon.position = ccp(20.1,_spoon.position.y);
        }
    }else if(!_atLeftBound&&acceleration.x < 0){
        [[_spoon physicsBody] setVelocity:CGPointMake(-100, 0)];
        if(_atRightBound)
        {
            _atRightBound = false;
            _spoon.position = ccp(299.9,_spoon.position.y);
        }
    }
}
-(void)limitMovement
{
    if(_spoon.position.x<20.0)
    {
        [[_spoon physicsBody] setVelocity:CGPointMake(0, 0)];
        _atLeftBound = true;
    }
    if(_spoon.position.x>300.0)
    {
        [[_spoon physicsBody] setVelocity:CGPointMake(0, 0)];
        _atRightBound = true;
    }
    
}
-(void)moveSpoon
{
    if(!_goUp)
    {
        
        _spoon.position = ccp(_spoon.position.x,_spoon.position.y-2.0);
        
    }
    else
    {
        _spoon.position = ccp(_spoon.position.x,_spoon.position.y+2.0);
    }
}
-(void)followCamera
{
    if(!_goUp)
    {
        
        self.position  = ccp(self.position.x,self.position.y+2.0);
        
    }
    else
    {
        self.position  = ccp(self.position.x,self.position.y-2.0);
    }
}

-(void)spawnIngridient
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

//
//  GameScene.h
//  HexLib
//
//  Created by Peter Easdown on 9/6/17.
//  Copyright © 2017 PKCLsoft. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Hex.h"
#import "Layout.h"
#import "HexMap.h"

@interface GameScene : SKScene

@property (nonatomic, retain) SKSpriteNode *mapNode;
@property (nonatomic, retain) Layout *layout;
@property (nonatomic, retain) HexMap *hexMap;

@end

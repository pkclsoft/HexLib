//
//  GameScene.m
//  HexLib
//
//  Created by Peter Easdown on 9/6/17.
//

#import "GameScene.h"
#import "SKUtilities.h"
#import "HexCell.h"

@implementation GameScene {
}

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define MAP_RADIUS (8)
#define MAP_WIDTH_IN_HEXES ((MAP_RADIUS * 2) + 1)
#define RADIUS_OF_GAME_CELL (IS_IPAD ? 45.0 : 25.0)

- (void)didMoveToView:(SKView *)view {

    // I use pointy because the art asset is pointy.  If you want to use a flat layout, then you will either
    // need a new art asset, or you will need to rotate each cell.
    //
    self.layout = [Layout pointyLayoutWithSize:CGSizeMake(RADIUS_OF_GAME_CELL, RADIUS_OF_GAME_CELL) at:CGPointZero];

    // This is the node into which all of the cells will be inserted.
    //
    self.mapNode = [SKSpriteNode node];

    // Center the map on the screen.
    //
    self.mapNode.position = CGPointZero;

    // Compute the width of the map.
    //
    float mapWidth = MAP_WIDTH_IN_HEXES*self.layout.widthOfHex;

    // Now calculate the height based on that width.
    //
    self.mapNode.size = CGSizeMake(mapWidth, [Layout heightWithRadius:mapWidth/2.0 andOrientaton:kOrientationPointy]);

    // These four lines show how to get different shapes of hex maps.
    //
    self.hexMap = [HexMap hexagonWithMapRadius:MAP_RADIUS andLayout:self.layout];
//    self.hexMap = [HexMap rectangleWithDimensions:CGSizeMake(MAP_RADIUS, MAP_RADIUS) andLayout:self.layout];
//    self.hexMap = [HexMap triangleWithMapSize:MAP_RADIUS andLayout:self.layout];
//    self.hexMap = [HexMap parallelogramWithDimensions:CGSizeMake(MAP_RADIUS, MAP_RADIUS)];

    // Now add a visual node to represent each hex in the map.
    //
    for (Hex *hex in self.hexMap.hexes) {
        HexCell *cell = [HexCell hexCellForHex:hex inLayout:self.layout];

        cell.cellScale = self.layout.heightOfHex / cell.size.height;

        [self.mapNode addChild:cell];
    }

    [self addChild:self.mapNode];
}


- (void)touchDownAtPoint:(CGPoint)pos {
}

- (void)touchMovedToPoint:(CGPoint)pos {
}

- (void)touchUpAtPoint:(CGPoint)pos {
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end

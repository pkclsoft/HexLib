//
//  HexCell.h
//  HexLib
//
//  Created by Peter Easdown on 3/08/2016.
//

#import <SpriteKit/SpriteKit.h>
#import "Layout.h"

/*!
 * A HexCell object is the visual representation of a cell on the game board.
 */
@interface HexCell : SKSpriteNode

@property (nonatomic, assign) float cellScale;

+ (HexCell*) hexCellForHex:(Hex *)hex inLayout:(Layout *)layout;

- (BOOL) isPointInside:(CGPoint)point;

@end

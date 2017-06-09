//
//  HexCell.m
//  HexLib
//
//  Created by Peter Easdown on 3/08/2016.
//

#import "HexCell.h"
#import "SKUtilities.h"

@interface HexCell()

@end

@implementation HexCell {

    CGPoint points[6];
}

#pragma mark Initializers

- (void) buildPolygonPointsWithLayout:(Layout*)layout {
    for (int i = 0; i < 6; i++) {
        CGPoint hexPosition = [layout hexOffsetOfCorner:i];

        points[i] = CGPointMake(self.position.x + hexPosition.x, self.position.y + hexPosition.y);
    }
}

- (instancetype)initForHex:(Hex *)hex inLayout:(id)layout {
    self = [super initWithImageNamed:@"hexCell.png"];

    if (self) {
        self.position = [layout convertHexToPoint:hex];
//        self.colorBlendFactor = 1.0;
        self.name = @"hexCell";

        [self buildPolygonPointsWithLayout:layout];
    }

    return self;
}

+ (HexCell*) hexCellForHex:(Hex *)hex inLayout:(Layout *)layout {
    return [[HexCell alloc] initForHex:hex inLayout:layout];
}

- (void) dealloc {
}

- (void) setCellScale:(float)cellScale {
    _cellScale = cellScale;

    [super setScale:cellScale];
}

- (BOOL) isPointInside:(CGPoint)point {
    return [SKUtilities isPointInPolygon:points count:6 point:point];
}

@end

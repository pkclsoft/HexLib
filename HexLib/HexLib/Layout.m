//
//  Layout.m
//  HexLib
//
//  Created by Peter Easdown on 29/04/2016.
//  Inspired by the great work by Amit Patel at: http://www.redblobgames.com/grids/hexagons/

#import "Layout.h"
#import "Hex.h"
#import "FractionalHex.h"

@implementation Layout

- (id) initWithSize:(CGSize)size at:(CGPoint)origin andOrientation:(Orientation)orientation {
    self = [super init];
    
    if (self != nil) {
        self.origin = origin;
        self.size = size;
        self.orientation = orientation;
    }
    
    return self;
}

+ (Layout*) pointyLayoutWithSize:(CGSize)size at:(CGPoint)origin {
    return [[Layout alloc] initWithSize:size at:origin andOrientation:pointyOrientation];
}


+ (Layout*) flatLayoutWithSize:(CGSize)size at:(CGPoint)origin {
    return [[Layout alloc] initWithSize:size at:origin andOrientation:flatOrientation];
}

- (CGPoint) convertHexToPoint:(Hex*)hex {
    float x = (self.orientation.f0 * hex.q + self.orientation.f1 * hex.r) * self.size.width;
    float y = (self.orientation.f2 * hex.q + self.orientation.f3 * hex.r) * self.size.height;
    return CGPointMake(x + self.origin.x, y + self.origin.y);
}

- (FractionalHex*) convertPointToFractionalHex:(CGPoint)point {
    CGPoint pt = CGPointMake((point.x - self.origin.x) / self.size.width,
                             (point.y - self.origin.y) / self.size.height);
    float q = self.orientation.b0 * pt.x + self.orientation.b1 * pt.y;
    float r = self.orientation.b2 * pt.x + self.orientation.b3 * pt.y;
    return [FractionalHex fractionalHexWithQ:q andR:r];
}

- (CGPoint) hexOffsetOfCorner:(NSInteger)corner {
    double angle = 2.0 * M_PI * (corner + self.orientation.start_angle) / 6.0;
    
    return CGPointMake(self.size.width * cos(angle), self.size.height * sin(angle));
}

- (NSArray<NSValue*>*) corners:(Hex*)hex {
    NSMutableArray<NSValue*> *corners = [NSMutableArray arrayWithCapacity:6];
    
    CGPoint center = [self convertHexToPoint:hex];
    
    for (int i = 0; i < 6; i++) {
        CGPoint offset = [self hexOffsetOfCorner:i];
        
        [corners addObject:[NSValue valueWithCGPoint:CGPointMake(center.x + offset.x,
                                                                 center.y + offset.y)]];
    }
    
    return corners;
}

+ (float) widthWithRadius:(float)radius andOrientaton:(OrientationType)orientationType {
    if (orientationType == kOrientationPointy) {
        return (M_SQRT_3 / 2) * [Layout heightWithRadius:radius andOrientaton:orientationType];
    } else {
        return radius * 2.0;
    }
}

+ (float) heightWithRadius:(float)radius andOrientaton:(OrientationType)orientationType {
    if (orientationType == kOrientationPointy) {
        return radius * 2.0;
    } else {
        return (M_SQRT_3 / 2) * [Layout widthWithRadius:radius andOrientaton:orientationType];
    }
}

- (float) widthOfHex {
    return [Layout widthWithRadius:self.size.width andOrientaton:self.orientation.orientationType];
}

- (float) heightOfHex {
    return [Layout heightWithRadius:self.size.width andOrientaton:self.orientation.orientationType];
}

@end

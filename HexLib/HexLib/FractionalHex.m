//
//  FractionalHex.m
//  HexLib
//
//  Created by Peter Easdown on 29/04/2016.
//  Inspired by the great work by Amit Patel at: http://www.redblobgames.com/grids/hexagons/

#import "FractionalHex.h"
#import "Hex.h"

@implementation FractionalHex

- (id) initWithQ:(float)newQ r:(float)newR andS:(float)newS {
    self = [super init];
    
    if (self != nil) {
        NSAssert((newQ + newR + newS) == 0, @"Hex coordinates must total zero.");
        
        self.q = newQ;
        self.r = newR;
        self.s = newS;
    }
    
    return self;
}

+ (FractionalHex*) fractionalHexWithQ:(float)newQ r:(float)newR andS:(float)newS {
    return [[FractionalHex alloc] initWithQ:newQ r:newR andS:newS];
}

+ (FractionalHex*) fractionalHexWithQ:(float)newQ andR:(float)newR {
    return [[FractionalHex alloc] initWithQ:newQ r:newR andS:-newQ - newR];
}

+ (FractionalHex*) fractionalHexWithHexCoordinate:(HexCoordinate)other {
    return [FractionalHex fractionalHexWithQ:other.q andR:other.r];
}

+ (FractionalHex*) fractionalHexWithHex:(Hex*)other {
    return [FractionalHex fractionalHexWithQ:other.q andR:other.r];
}

+ (FractionalHex*) fractionalHexWithFractionalHex:(FractionalHex*)other {
    return [FractionalHex fractionalHexWithQ:other.q andR:other.r];
}

- (BOOL) isEqual:(FractionalHex*)other {
    return other.q == self.q && other.r == self.r && other.s == self.s;
}

- (void) add:(FractionalHex*)other {
    self.q += other.q;
    self.r += other.r;
    self.s += other.s;
}

- (void) subtract:(FractionalHex*)other {
    self.q -= other.q;
    self.r -= other.r;
    self.s -= other.s;
}

- (void) multiplyBy:(float)k {
    self.q *= k;
    self.r *= k;
    self.s *= k;
}

- (float) length {
    return ((fabs(self.q) + fabs(self.r) + fabs(self.s)) / 2);
}

- (float) distanceTo:(FractionalHex*)other {
    FractionalHex *tmp = [FractionalHex fractionalHexWithFractionalHex:self];
    [tmp subtract:other];
    return [tmp length];
}

- (FractionalHex*) neighborInDirection:(NSInteger)directionIndex {
    FractionalHex *result = [FractionalHex fractionalHexWithFractionalHex:self];
    [result add:[FractionalHex fractionalHexWithHexCoordinate:[Hex directionFor:directionIndex]]];
    return result;
}


@end

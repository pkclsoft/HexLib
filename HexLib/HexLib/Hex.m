//
//  Hex.m
//  HexLib
//
//  Created by Peter Easdown on 29/04/2016.
//  Inspired by the great work by Amit Patel at: http://www.redblobgames.com/grids/hexagons/

#import "Hex.h"

@implementation Hex

static const HexCoordinate static_hex_directions[] = {
    {1, 0, -1}, {1, -1, 0}, {0, -1, 1},
    {-1, 0, 1}, {-1, 1, 0}, {0, 1, -1}
};

- (id) initWithQ:(NSInteger)newQ r:(NSInteger)newR andS:(NSInteger)newS {
    self = [super init];
    
    if (self != nil) {
        NSAssert((newQ + newR + newS) == 0, @"Hex coordinates must total zero.");
        
        _coordinate.q = newQ;
        _coordinate.r = newR;
        _coordinate.s = newS;

        self.neighbors = nil;
    }
    
    return self;
}

+ (Hex*) hexWithQ:(NSInteger)newQ r:(NSInteger)newR andS:(NSInteger)newS {
    return [[Hex alloc] initWithQ:newQ r:newR andS:newS];
}

+ (Hex*) hexWithQ:(NSInteger)newQ andR:(NSInteger)newR {
    return [[Hex alloc] initWithQ:newQ r:newR andS:-newQ - newR];
}

+ (Hex*) hexWithHex:(Hex*)other {
    return [Hex hexWithQ:other.q andR:other.r];
}

+ (Hex*) hexWithFractionalHex:(FractionalHex*)fractionalHex {
    NSInteger q = round(fractionalHex.q);
    NSInteger r = round(fractionalHex.r);
    NSInteger s = round(fractionalHex.s);
    
    double q_diff = fabsf(q - fractionalHex.q);
    double r_diff = fabsf(r - fractionalHex.r);
    double s_diff = fabsf(s - fractionalHex.s);
    
    if ((q_diff > r_diff) && (q_diff > s_diff)) {
        q = -r - s;
    } else if (r_diff > s_diff) {
        r = -q - s;
    } else {
        s = -q - r;
    }
    
    return [Hex hexWithQ:q r:r andS:s];
}

+ (Hex*) hexWithHexCoordinate:(HexCoordinate)coordinate {
    return [Hex hexWithQ:coordinate.q andR:coordinate.r];
}

- (void) dealloc {
    self.neighbors = nil;
}

+ (NSUInteger) hashForQ:(NSUInteger)q andR:(NSUInteger)r {
    return (q << 16) + r;
}

- (NSUInteger) hash {
    // If we assume that a hex map doesn't exceed 2^16 cells per side, then we can just hash
    // the value of q and r by placing q in the high 16 bits, and r in the lowest 16 bits.
    //
    return [Hex hashForQ:_coordinate.q andR:_coordinate.r];
}

- (BOOL) isEqual:(Hex*)other {
    return (other.q == self.q) && (other.r == self.r);
}

- (void) add:(Hex*)other {
    self.q += other.q;
    self.r += other.r;
    self.s += other.s;
}

- (void) addHexCoordinate:(HexCoordinate)other {
    self.q += other.q;
    self.r += other.r;
    self.s += other.s;
}

- (void) subtract:(Hex*)other {
    self.q -= other.q;
    self.r -= other.r;
    self.s -= other.s;
}

- (void) multiplyBy:(NSInteger)k {
    self.q *= k;
    self.r *= k;
    self.s *= k;
}

- (NSInteger) length {
    return ((labs(self.q) + labs(self.r) + labs(self.s)) / 2);
}

- (NSInteger) distanceTo:(Hex*)other {
    Hex *tmp = [Hex hexWithHex:self];
    [tmp subtract:other];
    return [tmp length];
}

+ (HexCoordinate) directionFor:(NSInteger)directionIndex {
    return static_hex_directions[directionIndex];
}

- (Hex*) neighborInDirection:(NSInteger)directionIndex {
    Hex *result = [Hex hexWithHex:self];
    [result addHexCoordinate:[Hex directionFor:directionIndex]];
    return result;
}

- (NSArray<Hex*>*) neighbors {
    if (_neighbors == nil) {
        NSMutableArray<Hex*> *result = [NSMutableArray arrayWithCapacity:6];
        
        for (int i = 0; i < 6; i++) {
            Hex *neighbor = [self neighborInDirection:i];
            
            if (neighbor != nil) {
                [result addObject:neighbor];
            }
        }
        
        self.neighbors = [NSArray arrayWithArray:result];
    }
    
    return _neighbors;
}

- (FractionalHex*) lerpTo:(Hex*)other withDistance:(float)distance {
    return [FractionalHex fractionalHexWithQ:self.q + (other.q - self.q) * distance
                                           r:self.r + (other.r - self.r) * distance
                                        andS:self.s + (other.s - self.s) * distance];
}

- (NSArray<Hex*>*) hexLineTo:(Hex*)other {
    NSInteger distance = [self distanceTo:other];
    
    NSMutableArray<Hex*>* result = [NSMutableArray array];
    
    float step = 1.0 / MAX(distance, 1);
    
    for (NSInteger i = 0; i < distance; i++) {
        [result addObject:[Hex hexWithFractionalHex:[self lerpTo:other withDistance:step * i]]];
    }
    
    return result;
}

- (NSInteger) q {
    return _coordinate.q;
}

- (NSInteger) r {
    return _coordinate.r;
}

- (NSInteger) s {
    return _coordinate.s;
}

- (void) setQ:(NSInteger)q {
    _coordinate.q = q;
}

- (void) setR:(NSInteger)r {
    _coordinate.r = r;
}

- (void) setS:(NSInteger)s {
    _coordinate.s = s;
}

@end

//
//  FractionalHex.h
//  HexLib
//
//  Created by Peter Easdown on 29/04/2016.
//  Inspired by the great work by Amit Patel at: http://www.redblobgames.com/grids/hexagons/

#import <Foundation/Foundation.h>

typedef struct {
    SInt8 q;
    SInt8 r;
    SInt8 s;
} HexCoordinate;

NS_INLINE HexCoordinate MakeHexCoordinate(SInt8 q, SInt8 r, SInt8 s) {
    HexCoordinate hc;
    hc.q = q;
    hc.r = r;
    hc.s = s;
    return hc;
}

@interface FractionalHex : NSObject

@property (assign) float q;
@property (assign) float r;
@property (assign) float s;

+ (FractionalHex*) fractionalHexWithQ:(float)newQ r:(float)newR andS:(float)newS;
+ (FractionalHex*) fractionalHexWithQ:(float)newQ andR:(float)newR;
+ (FractionalHex*) fractionalHexWithHexCoordinate:(HexCoordinate)other;

@end

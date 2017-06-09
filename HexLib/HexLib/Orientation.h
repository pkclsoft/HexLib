//
//  Orientation.h
//  HexLib
//
//  Created by Peter Easdown on 29/04/2016.
//  Inspired by the great work by Amit Patel at: http://www.redblobgames.com/grids/hexagons/

#import <Foundation/Foundation.h>

#ifndef HEX_ORIENTATION_CLASS
#define HEX_ORIENTATION_CLASS 1

typedef enum NSUInteger {
    kOrientationPointy,
    kOrientationFlat
} OrientationType;

typedef struct {
    OrientationType orientationType;
    const double f0, f1, f2, f3;
    const double b0, b1, b2, b3;
    const double start_angle; // in multiples of 60°
} Orientation;

#define M_SQRT_3 1.732050807568877

static const Orientation pointyOrientation = {kOrientationPointy, M_SQRT_3, M_SQRT_3 / 2.0, 0.0, 3.0 / 2.0, M_SQRT_3 / 3.0, -1.0 / 3.0, 0.0, 2.0 / 3.0, 0.5};

static const Orientation flatOrientation = {kOrientationFlat, 3.0 / 2.0, 0.0, M_SQRT_3 / 2.0, M_SQRT_3, 2.0 / 3.0, 0.0, -1.0 / 3.0, M_SQRT_3 / 3.0, 0.0};

#endif

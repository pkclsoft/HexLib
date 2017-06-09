//
//  SKUtilities.m
//
//  Created by Peter Easdown on 10/02/2016.
//

#import "SKUtilities.h"
#import "AppDelegate.h"

@implementation SKUtilities

+ (BOOL) isiOS9orLater {
    NSString *reqSysVer = @"9.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];

    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
    {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL) isiOS10orLater {
    NSString *reqSysVer = @"10.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];

    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
    {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL) isiOS10Point3orLater {
    NSString *reqSysVer = @"10.3";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];

    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
    {
        return YES;
    } else {
        return NO;
    }
}

+ (void) initStaticConstants {
#if TARGET_OS_TV == 0
    [SKUtilities initStaticConstantsWithOrientation:[UIDevice currentDevice].orientation];
#else
    [SKUtilities initStaticConstantsWithOrientation:koLandscape];
#endif
}

#if (TARGET_OS_TV == 1)
+ (void) initStaticConstantsWithOrientation:(GameOrientation)newOrientation {
    skutil_orientation_ = newOrientation;
    
    float dim1 = [[UIScreen mainScreen] bounds].size.width / [UIScreen mainScreen].scale;
    float dim2 = [[UIScreen mainScreen] bounds].size.height / [UIScreen mainScreen].scale;
#else
+ (void) initStaticConstantsWithOrientation:(UIDeviceOrientation)newOrientation {
    // Default the orientation to landscape for this app.
    //
    skutil_orientation_ = koLandscape;
    
    switch(newOrientation)
    {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            //case UIDeviceOrientationPortraitUpsideDown:
            skutil_orientation_ = koPortrait;
            /* start special animation */
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            skutil_orientation_ = koLandscape;
            break;
            
        default:
            break;
    };
    
    float dim1 = [[UIScreen mainScreen] preferredMode].size.width / [UIScreen mainScreen].scale;
    float dim2 = [[UIScreen mainScreen] preferredMode].size.height / [UIScreen mainScreen].scale;
#endif
    
    if (skutil_orientation_ == koLandscape) {
        skutil_screenRect_.size.width = MAX(dim1, dim2);
        skutil_screenRect_.size.height = MIN(dim1, dim2);
    } else {
        skutil_screenRect_.size.width = MIN(dim1, dim2);
        skutil_screenRect_.size.height = MAX(dim1, dim2);
    }
    
    skutil_screenCentre_ = CGPointMake(skutil_screenRect_.size.width / 2.0f, skutil_screenRect_.size.height / 2.0f);
    
    skutil_longestEdge_ = MAX(skutil_screenRect_.size.width, skutil_screenRect_.size.height);
}


+ (CGPoint) centerOfRect:(CGRect)rect {
    return CGPointMake(rect.origin.x + (rect.size.width / 2.0f), rect.origin.y + (rect.size.height / 2.0f));
}

+ (CGPoint) centerWith:(float)x andY:(float)y andWidth:(float)width andHeight:(float)height {
    return CGPointMake(x + (width / 2.0f), y + (height / 2.0f));
}

static CGRect skutil_screenRect_ = {0.0, 0.0, 0.0, 0.0};
static float skutil_longestEdge_;

+ (CGRect) screenRect {
    if (skutil_screenRect_.size.width == 0.0) {
        [SKUtilities initStaticConstants];
    }
    
    return skutil_screenRect_;
}

+ (float) screenHeight {
    if (skutil_screenRect_.size.width == 0.0) {
        [SKUtilities initStaticConstants];
    }
    
    return skutil_screenRect_.size.height;
}

+ (float) screenWidth {
    if (skutil_screenRect_.size.width == 0.0) {
        [SKUtilities initStaticConstants];
    }
    
    return skutil_screenRect_.size.width;
}

static CGPoint skutil_screenCentre_;

+ (CGPoint) screenCentre {
    if (skutil_screenRect_.size.width == 0.0) {
        [SKUtilities initStaticConstants];
    }
    
    return skutil_screenCentre_;
}

static GameOrientation skutil_orientation_;

+ (GameOrientation) orientation {
    return skutil_orientation_;
}

static SKDeviceType skutil_deviceType = kSKDTUnknown;

+ (SKDeviceType) identifyDevice {
#if (TARGET_OS_TV == 1)
    skutil_deviceType = kSKDTAppleTV;
#else
    if (skutil_deviceType == kSKDTUnknown) {
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            if ([UIScreen mainScreen].scale == 2) {
                if (skutil_longestEdge_ == 1024) {
                    return kSKDTiPadHD;
                } else {
                    return kSKDTiPadPro;
                }
            } else {
                return kSKDTiPad;
            }
        }
        else if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
        {
            if (skutil_longestEdge_ == 480){
                return kSKDTiPhone4;
            } else if(skutil_longestEdge_ == 568){
                return kSKDTiPhone5;
            } else {
                return ([UIScreen mainScreen].scale == 2 ? kSKDTiPhone6 : kSKDTiPhone6Plus);
            }
        }
    }
#endif
    
    return skutil_deviceType;
}

+ (SKDeviceType) deviceType {
    return [SKUtilities identifyDevice];
}

+ (float) scaledWidth:(float)forWidth {
    return ((forWidth / 1024) * [SKUtilities screenWidth]);
}

+ (float) scaledHeight:(float)forHeight {
    return ((forHeight / 768) * [SKUtilities screenHeight]);
}

// Converts an angle in the world where 0 is north in a clockwise direction to a world
// where 0 is east in an anticlockwise direction.
//
+ (float) angleFromDegrees:(float)deg {
    return fmodf((450.0f - deg), 360.0);
}

+ (CGPoint) geographicalPositionFor:(SCNVector3)vector3 withRadius:(float)sphereRadius {
    float latitude = -((float)acosf(vector3.y / sphereRadius) - M_PI_2); //theta
    float longitude = M_PI - ((float)atan2f(vector3.z, vector3.x)); //phi
    
    if (longitude > M_PI) {
        longitude = longitude - (2.0 * M_PI);
    }

    return CGPointMake(longitude, latitude);
}

+ (NSUInteger) hashValueForGeographicalPosition:(CGPoint)position {
    return ((long)(roundf((position.y + (2*M_PI))*100.0)) * 1000000) +
    (long)(roundf((position.x + (2*M_PI))*100.0));
}

+ (BOOL)isPointInPolygon:(CGPoint*)vertices count:(NSInteger)nvert point:(CGPoint)test {
    NSInteger c = 0;
    
    for (NSInteger i = 0, j = nvert-1; i < nvert; j = i++) {
        if (((vertices[i].y > test.y) != (vertices[j].y > test.y)) &&
            (test.x < (vertices[j].x - vertices[i].x) *
             (test.y - vertices[i].y) /
             (vertices[j].y - vertices[i].y) +
             vertices[i].x)) {
                c = !c;
            }
    }
    
    return (c ? YES : NO);
}
    
+ (NSUInteger) randomValueWithin:(NSUInteger)maxValue {
    if (maxValue > 0) {
        if (maxValue == 1) {
            return ((arc4random() % 500) > 250) ? 1 : 0;
        }
        
        return (arc4random() % maxValue);
    } else {
        return 0;
    }
}

+ (NSString*) getVersion {
    // Get the application bundle version
    return [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

#pragma mark - Glow Effect

#define GLOW_DURATION (0.5)

/*!
 * Adds a brief glow effect to the specified node.
 */
+ (void) addGlowEffectToNode:(SKSpriteNode*)background {
    SKSpriteNode *glowRect = [SKSpriteNode spriteNodeWithImageNamed:@"glowrect.png"];
    glowRect.yScale = (background.size.height * 1.0) / glowRect.size.height;
    glowRect.position = CGPointMake(-background.size.width / 2.2, background.position.y);
    glowRect.blendMode = SKBlendModeAdd;
    glowRect.alpha = 0.2;
    glowRect.zPosition = 0.5;

    [background.parent addChild:glowRect];

    [glowRect runAction:[SKAction moveToX:background.size.width / 2.2 duration:GLOW_DURATION] completion:^{
        [glowRect removeFromParent];
    }];

    [glowRect runAction:[SKAction sequence:
                         @[[SKAction fadeAlphaTo:1.0 duration:GLOW_DURATION/2.0],
                           [SKAction fadeAlphaTo:0.2 duration:GLOW_DURATION/2.0]]]];
}

@end

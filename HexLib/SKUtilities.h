//
//  SKUtilities.h
//
//  Created by Peter Easdown on 10/02/2016.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <SceneKit/SceneKit.h>

@interface SKUtilities : NSObject


typedef enum {
    koLandscape,
    koPortrait
} GameOrientation;


+ (BOOL) isiOS9orLater;
+ (BOOL) isiOS10orLater;
+ (BOOL) isiOS10Point3orLater;

+ (void) initStaticConstants;
#if TARGET_OS_TV == 0
+ (void) initStaticConstantsWithOrientation:(UIDeviceOrientation)newOrientation;
#endif

+ (CGPoint) centerOfRect:(CGRect)rect;
+ (CGPoint) centerWith:(float)x andY:(float)y andWidth:(float)width andHeight:(float)height;
+ (CGRect) screenRect;
+ (float) screenHeight;
+ (float) screenWidth;
+ (CGPoint) screenCentre;
+ (GameOrientation) orientation;

+ (float) scaledWidth:(float)forWidth;
+ (float) scaledHeight:(float)forHeight;

/*!
 *  Returns YES if the point <code>test</code> is deemed to be within the polygon described by
 *  the specified vertices.
 *
 *  @param vertices An array of vertices describing a polygon.
 *  @param nvert the number of vertices in the array.
 *  @param test the coordinate to check (must be in the same coordinate space as the polygon).
 */
+ (BOOL)isPointInPolygon:(CGPoint*)vertices count:(NSInteger)nvert point:(CGPoint)test;

/*!
 * Returns the signed latitutde (y) and longitude (x) of the given vector3 position from the centre of
 * a sphere with the specified sphereRadius.
 */
+ (CGPoint) geographicalPositionFor:(SCNVector3)vector3 withRadius:(float)sphereRadius;

/*!
 * Returns a hash value for the given geographical position.
 */
+ (NSUInteger) hashValueForGeographicalPosition:(CGPoint)position;

+ (NSUInteger) randomValueWithin:(NSUInteger)maxValue;

typedef enum {
    kSKDTUnknown,
    kSKDTiPad,
    kSKDTiPadHD,
    kSKDTiPadPro,
    kSKDTiPhone,
    kSKDTiPhone4,
    kSKDTiPhone5,
    kSKDTiPhone6,
    kSKDTiPhone6Plus,
    kSKDTAppleTV
} SKDeviceType;

+ (SKDeviceType) deviceType;

/*!
 * Adds a brief glow effect to the specified node.
 */
+ (void) addGlowEffectToNode:(SKSpriteNode*)background;

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_IPHONE_5 ([SKUtilities deviceType] == kSKDTiPhone5)
#define IS_IPHONE_6 ([SKUtilities deviceType] == kSKDTiPhone6)
#define IS_IPHONE_6PLUS ([SKUtilities deviceType] == kSKDTiPhone6Plus)
#define IS_WIDESCREEN (IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6PLUS)
#define IS_IPHONE_4 ([SKUtilities deviceType] == kSKDTiPhone4)
#define IS_IPAD_PRO (IS_IPAD && ([SKUtilities deviceType] == kSKDTiPadPro))
#define IS_LANDSCAPE ([SKUtilities orientation] == koLandscape)
#define IS_PORTRAIT ([SKUtilities orientation] == koPortrait)

#define WeakSelf __weak typeof(self) weakSelf = self;
#define StrongSelf __typeof__(self) strongSelf = weakSelf;

#if defined(DEBUG_DEALLOC)
#define CCLOGDEALLOC SKLOG(@"%@.dealloc", [self debugDescription]);
#else
#define CCLOGDEALLOC
#endif

+ (NSString*) getVersion;

@end

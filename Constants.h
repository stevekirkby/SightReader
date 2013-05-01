//typedef enum {  kBass =1,
//                kTreble
//} Clef;

//typedef enum {  kCMajor=1,
//                kGMajor, kDMajor, kAMajor, kEMajor, kBMajor, kFSharpMajor, kGFlatMajor, kDFlatMajor, kAFlatMajor, kEFlatMajor, kFMajor, kBFlatMajor, kFFlatMajor, kCSharpMajor, kCFlatMajor} Key;


#define IMAGEREDUCTION 0.7

#define kBASSCLEFIMAGE @"bassClef.png"
#define kTREBLECLEFIMAGE @"trebleClef.png"
#define kSINGLESHARPIMAGE @"singleSharp.png"
#define kSINGLEFLATIMAGE @"singleFlat.png"
#define CUSTOMEXCEPTION(MESSAGE) {[NSException raise:@"Custom exception raised" format:@"%@", MESSAGE];}

// #define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}


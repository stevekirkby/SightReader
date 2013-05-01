// Generic
#ifdef DEBUG
#undef DEBUG
#endif
#define DEBUG // Commnent to remove console logging

#define NAVTITLE 1

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#ifdef DEBUG
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#   define DLog(...)
#endif

#ifdef NAVTITLE
#   define SHOW_NAV_TITLE {[self.navigationItem setTitle:[NSString stringWithFormat:@"%@",[self class]]]; [self.navigationItem.backBarButtonItem setTitle:@"Back"]; NSLog(@"Hello world");}
#endif

// App specific
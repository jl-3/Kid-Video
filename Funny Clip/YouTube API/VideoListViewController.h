#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "GTLYouTube.h"
#import "VideoData.h"
#import "YouTubeGetVideos.h"
#import "YouTubeUploadVideo.h"

@interface VideoListViewController : UITableViewController<YouTubeGetVideosDelegate,
                                                           UISearchBarDelegate,
                                                           UITableViewDataSource,
                                                           UITableViewDelegate,
                                                           UIImagePickerControllerDelegate,
                                                           UINavigationControllerDelegate,
                                                           UITabBarDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *videos;
@property(nonatomic, strong) YouTubeGetVideos *getVideos;
@property(nonatomic, retain) GTLServiceYouTube *youtubeService;

@end
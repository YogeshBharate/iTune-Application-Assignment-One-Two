
@interface  ApplicationData : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *iconURL;
@property (nonatomic, strong) NSString *detailViewImageURL;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *releaseDate;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *rights;
@property (nonatomic, strong) NSString *category;

- (instancetype)initWithJsonData:(NSDictionary *)jsonData;

@end
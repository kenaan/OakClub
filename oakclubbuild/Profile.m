//
//  Profile.m
//  oakclubbuild
//
//  Created by VanLuu on 4/1/13.
//  Copyright (c) 2013 VanLuu. All rights reserved.
//

#import "Profile.h"


@implementation Profile

@synthesize s_Name, s_Avatar, i_Points, s_ProfileStatus, s_FB_id, s_ID, dic_Roster,num_Photos, s_gender, num_points, num_unreadMessage, s_passwordXMPP, s_usenameXMPP, arr_photos, s_aboutMe, s_birthdayDate, s_interested,a_language, s_location,s_relationShip, s_ethnicity, s_age, s_meetType, s_popularity, s_interestedStatus, s_snapshotID, a_favorites, s_user_id,s_school,i_work, i_height,i_weight, numberMutualFriends;
@synthesize is_deleted;
@synthesize is_blocked;
@synthesize is_available;
@synthesize unread_message;


-(id)init {
    self = [super init];
    self.i_weight=0;
    self.i_height=0;
    return self;
}
-(Profile*) parseProfile:(NSString *)responeString{
    Profile *_profile = [[Profile alloc] init];
    NSData *jsonData = [responeString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e=nil;
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
    NSMutableArray * data= [dict valueForKey:key_data];
    if(data!= nil && [data count] > 0){
        NSMutableDictionary *objectData = [data objectAtIndex:0];
        _profile.s_Name = [objectData valueForKey:key_name];
        _profile.s_Avatar = [objectData valueForKey:key_avatar];
        _profile.s_FB_id = [objectData valueForKey:key_facebookID];
        _profile.s_ID = [objectData valueForKey:key_profileID];
        _profile.s_ProfileStatus = [objectData valueForKey:key_online];
        _profile.num_Photos =[objectData valueForKey:key_countPhotos];
    }
    return _profile;
}

+(void) getListPeople:(NSString*)service handler:(void(^)(NSMutableArray*,int))resultHandler
{
    AFHTTPClient *request = [[AFHTTPClient alloc] initWithOakClubAPI:DOMAIN];
    
    NSDictionary *params_checkedmeout = [[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"start",@"999",@"limit", nil];
    [request getPath:service parameters:params_checkedmeout success:^(__unused AFHTTPRequestOperation *operation, id JSON) {

        NSError *e=nil;
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:&e];
        NSMutableArray * data= [dict valueForKey:key_data];
        
        
        if(![data isKindOfClass:[NSNull class]])
        {
            int count = 0;
            NSMutableArray* list = [[NSMutableArray alloc] init];
            for (int i = 0; i < [data count]; i++)
            {
                NSMutableDictionary *objectData = [data objectAtIndex:i];
                Profile *_profile = [[Profile alloc] init];
                _profile.s_Name = [objectData valueForKey:key_name];
                _profile.s_Avatar = [objectData valueForKey:key_avatar];
                _profile.s_FB_id = [objectData valueForKey:key_facebookID];
                _profile.s_ID = [objectData valueForKey:key_profileID];
                _profile.s_ProfileStatus = [objectData valueForKey:key_online];
                _profile.num_Photos =[objectData valueForKey:key_countPhotos];
                int is_viewed = [[objectData valueForKey:@"is_viewed"] intValue];
                
                if( is_viewed == 0)
                {
                    count++;
                }
                
                [list addObject:_profile];
            }
            
            if(resultHandler != nil)
                resultHandler(list, count);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@ Error Code: %i - %@", service, [error code], [error localizedDescription]);
    }];

}


+(NSMutableArray*) parseProfileToArrayByJSON:(NSData *)jsonData{
    NSMutableArray *_arrProfile = [[NSMutableArray alloc] init];
//    NSData *jsonData = [responeString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e=nil;
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
    NSMutableArray * data= [dict valueForKey:key_data];
    if(![data isKindOfClass:[NSNull class]]){
        for (int i = 0; i < [data count]; i++) {
            Profile *_profile = [[Profile alloc] init];
            NSMutableDictionary *objectData = [data objectAtIndex:i];
            _profile.s_Name = [objectData valueForKey:key_name];
            _profile.s_Avatar = [objectData valueForKey:key_avatar];
            _profile.s_FB_id = [objectData valueForKey:key_facebookID];
            _profile.s_ID = [objectData valueForKey:key_profileID];
            _profile.s_ProfileStatus = [objectData valueForKey:key_online];
            _profile.num_Photos =[objectData valueForKey:key_countPhotos];
            
            [_arrProfile addObject:_profile];
            
        }
    }
    else{
        data = nil;
    }

    return _arrProfile;
}


+(NSMutableArray*) parseProfileToArray:(NSString *)responeString{
    NSMutableArray *_arrProfile = [[NSMutableArray alloc] init];
    
    
    NSData *jsonData = [responeString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e=nil;
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
    NSMutableArray * data= [dict valueForKey:key_data];
    
    for (int i = 0; i < [data count]; i++) {
        Profile *_profile = [[Profile alloc] init];
        NSMutableDictionary *objectData = [data objectAtIndex:i];
        _profile.s_Name = [objectData valueForKey:key_name];
        _profile.s_Avatar = [objectData valueForKey:key_avatar];
        _profile.s_FB_id = [objectData valueForKey:key_facebookID];
        _profile.s_ID = [objectData valueForKey:key_profileID];
        _profile.s_ProfileStatus = [objectData valueForKey:key_online];
        _profile.num_Photos =[objectData valueForKey:key_countPhotos];
        [_arrProfile addObject:_profile];
        
    }
    
    return _arrProfile;
}

-(NSMutableArray*) parseForGetFeatureList:(NSData *)jsonData{
//    if([responeString length] == 0)
//        return nil;
    NSMutableArray *_arrProfile = [[NSMutableArray alloc] init];
    
//    NSData *jsonData = [responeString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e=nil;
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
    NSMutableArray * data= [dict valueForKey:key_data];
    
    
    for (int i = 0; ![data isKindOfClass:[NSNull class]] && i < [data count]; i++)
    {
        Profile *_profile = [[Profile alloc] init];
        NSMutableDictionary *objectData = [data objectAtIndex:i];
        _profile.s_Name = [objectData valueForKey:key_name];
        _profile.s_Avatar = [objectData valueForKey:key_avatar];
        _profile.s_FB_id = [objectData valueForKey:key_facebookID];
        _profile.s_ID = [objectData valueForKey:key_profileID];
        _profile.num_Photos =[objectData valueForKey:key_countPhotos];
        [_arrProfile addObject:_profile];
        
    }
    
    return _arrProfile;
}

-(ProfileSetting*) parseForGetAccountSetting:(NSData *)jsonData{
//    NSData *jsonData = [responeString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e=nil;
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
    NSMutableDictionary * data= [dict valueForKey:key_data];
    self.s_Name = [data valueForKey:key_name];
    self.s_Avatar = [data valueForKey:key_avatar];
    self.num_points = [data valueForKey:key_points];
    self.s_ID = [data valueForKey:key_profileID];
    
    NSMutableDictionary* search_condition = [data valueForKey:@"search_condition"];
    
    ProfileSetting* setting = [[ProfileSetting alloc] init];
    setting.purpose_of_search = [search_condition valueForKey:@"purpose_of_search"];
    setting.gender_of_search = [search_condition valueForKey:@"gender_of_search"];
    setting.range = [[search_condition valueForKey:@"range"] intValue];
    setting.age_from = [[search_condition valueForKey:@"age_from"] intValue];
    setting.age_to = [[search_condition valueForKey:@"age_to"] intValue];
    
    NSMutableDictionary* dict_StatusInterestedIn = [search_condition valueForKey:@"status_interested_in"];
    setting.interested_new_people = [[dict_StatusInterestedIn valueForKey:@"new_people"] boolValue];
    setting.interested_friends = [[dict_StatusInterestedIn valueForKey:@"friends"] boolValue];
    setting.interested_friend_of_friends = [[dict_StatusInterestedIn valueForKey:@"status_fof"] boolValue];
    
    NSMutableDictionary* dict_Location = [search_condition valueForKey:@"location"];
    setting.location= [Location alloc];
    [setting.location setID:[dict_Location valueForKey:@"id"]];
    [setting.location setName:[dict_Location valueForKey:@"name"]];
    [setting.location setCountry:[dict_Location valueForKey:@"country"]];
    [setting.location setCountryCode:[dict_Location valueForKey:@"country_code"]];

//    setting.latitude = [[dict_Location valueForKey:@"latitude"] floatValue];
//    setting.longitude = [[dict_Location valueForKey:@"longitude"] floatValue];
    
    return setting;
    
}

+(NSMutableArray*) parseMutualFriends:(NSData *)jsonData
{
    NSError *e=nil;
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
    
    NSMutableArray * data= [dict valueForKey:key_data];
    
    NSMutableArray* friends = [[NSMutableArray alloc] init];
    
    for(int i = 0 ; i < [data count]; i++)
    {
        NSMutableDictionary* x = [data objectAtIndex:i];
        Profile* p = [[Profile alloc] init];
        
        p.s_Name = [x valueForKey:@"name"];
        if([p.s_Name isKindOfClass:[NSNull class]])
            p.s_Name = @"";
        p.s_Avatar = [x valueForKey:@"avatar"];
        p.s_user_id = [x valueForKey:@"user_id"];
        
        [friends addObject:p];
    }
    
    return friends;
}

+(NSMutableArray*) parseListPhotos:(NSData *)jsonData
{
    NSError *e=nil;
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
    
    NSMutableDictionary *data= [dict valueForKey:key_data];
    NSMutableArray* photos = [[NSMutableArray alloc] init];
    
    if(data != nil)
    {
        NSMutableArray *photosData = [data valueForKey:key_data];
        
        if(photosData != nil && ![photosData isKindOfClass:[NSNull class]])
        {
            for(int i = 0 ; i < [photosData count]; i++)
            {
                NSMutableDictionary* photo = [photosData objectAtIndex:i];
                NSString* photoLink = [photo valueForKey:@"tweet_image_link"];
                if(photoLink != nil)
                    [ photos addObject: photoLink];
            }
        }
    
    }

    
    return photos;
}

-(void) parseProfileWithDictionary:(NSMutableDictionary*)data
{
    self.s_Name = [data valueForKey:key_name];
    self.s_Avatar = [data valueForKey:key_avatar];

    self.s_ethnicity=[data valueForKey:key_ethnicity];
    self.s_birthdayDate =[data valueForKey:key_birthday];
    self.s_age = [self  pareAgeFromDateString:self.s_birthdayDate];
    self.s_meetType = [data valueForKey:key_meet_type];
    self.s_popularity = [self parsePopolarityFromInt:[[data valueForKey:key_popularity] integerValue]];
    self.s_interested = [Gender alloc];// [self parseGender:[data valueForKey:key_interested]] ;
    self.s_interested = [self parseGender:[data valueForKey:key_interested]] ;
    self.a_language = [data valueForKey:key_language];
    if(a_language == nil || [a_language count]==0)
        a_language = [[NSMutableArray alloc] initWithObjects:@"Vietnamese", nil];
    self.i_work = [WorkCate alloc];
    self.i_work.cate_id = [[data valueForKey:key_work] integerValue];
    self.i_weight =[[data valueForKey:key_weight] integerValue];
    self.i_height = [[data valueForKey:key_height] integerValue];
    
    NSMutableDictionary *dict_Location = [data valueForKey:key_location];
    self.s_location = [[Location alloc] initWithNSDictionary:dict_Location];
    self.s_relationShip = [RelationShip alloc];
    self.s_relationShip = [self parseRelationShip:[data valueForKey:key_relationship]] ;
    self.s_gender = [Gender alloc];
    self.s_gender = [self parseGender:[data valueForKey:key_gender]];
    self.s_aboutMe = [data valueForKey:key_aboutMe];
    if([self.s_aboutMe isKindOfClass:[NSNull class]]){
        self.s_aboutMe = @"";
    }

    
    NSMutableArray *dict_Fav = [data valueForKey:@"fav"];
    
    if (dict_Fav) {
        NSMutableArray* a = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < [dict_Fav count]; i++)
        {
            NSMutableDictionary* favourite = [dict_Fav objectAtIndex:i];
            
            [a addObject:[favourite objectForKey:@"fav_name"]];
        }
        
        self.a_favorites = [NSArray arrayWithArray:a];
    }
}

-(void) parseForGetHangOutProfile:(NSData *)jsonData{
//    NSData *jsonData = [responeString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e=nil;
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
    
    NSMutableDictionary * data= [dict valueForKey:key_data];
    
    self.s_ID = [data valueForKey:key_profileID];
    
    [self parseProfileWithDictionary:data];
    
    self.s_usenameXMPP = [data valueForKey:key_usernameXMPP];
    self.s_passwordXMPP = [data valueForKey:key_passwordXMPP];
    
    [self getRosterListIDSync];
}

- (void) parseRoster:(NSArray *)rosterList
{
    NSMutableDictionary *rosterDict = [[NSMutableDictionary alloc] init];

    self.unread_message = 0;
    
    for (int i = 0; rosterList!=nil && i < [rosterList count]; i++) {
        NSMutableDictionary *objectData = [rosterList objectAtIndex:i];
        
        NSLog(@"%@", objectData);
        
        if(objectData != nil)
        {
            NSString* profile_id = [objectData valueForKey:key_profileID];
            bool deleted = [[objectData valueForKey:@"is_deleted"] boolValue];
            bool blocked = [[objectData valueForKey:@"is_blocked"] boolValue];
            //bool deleted_by = [[objectData valueForKey:@"is_deleted_by_user"] boolValue];
            bool blocked_by = [[objectData valueForKey:@"is_blocked_by_user"] boolValue];
            // vanancyLuu : cheat for crash
            if(!deleted && !blocked && !blocked_by )
            {
                bool isMatch = [[objectData valueForKey:key_match] boolValue];
                [rosterDict setObject:[NSNumber numberWithBool:isMatch] forKey:profile_id];
                
                int unread_count = [[objectData valueForKey:@"unread_count"] intValue];
                
                NSLog(@"%d. unread message: %d", i, unread_count);
                
                self.unread_message += unread_count;
            }
        }
    }
    
    NSLog(@"unread message: %d", self.unread_message);
    
    self.dic_Roster = [NSDictionary dictionaryWithDictionary:rosterDict];
}

- (void) getRosterListIDSync
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithOakClubAPI:DOMAIN];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                                path:URL_getListChat
                                                          parameters:nil];
        
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err;
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        NSLog(@"%@", @"getRosterListIDSync");
        [self parseRoster:[dict valueForKey:key_data]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get list chat Error: %@", error);
    }];
    
    // sync
    [queue addOperation:operation];
    [queue waitUntilAllOperationsAreFinished];
    NSLog(@"Get chat list completed");
}

-(void) parseGetSnapshotToProfile:(NSData*)jsonData{
    NSMutableDictionary * data;
    if([jsonData isKindOfClass:[NSDictionary class]]){
        data=jsonData;
    }else{
        NSError *e=nil;
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
        data= [dict valueForKey:key_data];
    }
    
    self.s_interestedStatus = [data valueForKey:key_interestedStatus];
    // Vanancy --- check if answer or not 
//    if(s_interestedStatus != nil){
//        return;
//    }
    self.s_Name = [NSString stringWithFormat:@"%@ %@",[data valueForKey:key_last_name],[data valueForKey:key_first_name]] ;
    self.s_ID = [data valueForKey:key_profileID];
    self.s_Avatar = [data valueForKey:key_avatar];
    if(self.arr_photos == nil){
        self.arr_photos = [[NSMutableArray alloc] init];
    }
    
    self.s_snapshotID =[data valueForKey:key_snapshotID];
    
    NSMutableArray *_arrTemp = [[NSMutableArray alloc] init];
    _arrTemp = [data valueForKey:key_photos];
    for (int i = 0; i < [_arrTemp count]; i++) {
        NSMutableDictionary *photoItem = [_arrTemp objectAtIndex:i];
        [self.arr_photos addObject: [photoItem valueForKey:@"src"]];
    }
    if([_arrTemp count]==0 && ![self.s_Avatar isKindOfClass:[NSNull class]] )
        [self.arr_photos addObject:self.s_Avatar];
    self.s_age = [data valueForKey:key_age];
}

-(Gender*) parseGender:(NSNumber *)genderCode{
    Gender* gender = [Gender alloc];
    gender.ID = -1;
    gender.text = @"";
    if([genderCode isKindOfClass:[NSNull class]])
        return gender;
    switch ([genderCode intValue]) {
        case 0:
            gender.ID = 0;
            gender.text = @"Female";
            break;
        case 1:
            gender.ID = 1;
            gender.text = @"Male";
            break;
        case 2:
            gender.ID = 2;
            gender.text = @"Both";
            break;
        default:
            break;
    }
    return gender;
}
-(RelationShip *)parseRelationShip:(NSNumber *)relationShip{
    if([relationShip  isKindOfClass:[NSNull class]]){
        return nil;
    }
    RelationShip *rel = [RelationShip alloc];
    rel.rel_status_id = [relationShip integerValue];
    
//    NSString *relation=@"N/A";
    switch ([relationShip intValue]) {
        case single:
            rel.rel_text = RELATIOSHIP_SINGLE;
            break;
        case complicated:
            rel.rel_text = RELATIOSHIP_COMPLICATED;
            break;
        case married:
            rel.rel_text = RELATIOSHIP_MARRIED;
            break;
        case inRelationship:
            rel.rel_text = RELATIOSHIP_INRELATIONSHIP;
            break;
        case engaged:
            rel.rel_text = RELATIOSHIP_ENGAGED;
            break;
        case openRelationship:
            rel.rel_text = RELATIOSHIP_OPENRELATIONSHIP;
            break;
        case widowed:
            rel.rel_text = RELATIOSHIP_WIDOWED;
            break;
        case separated:
            rel.rel_text = RELATIOSHIP_SEPARATED;
            break;
        case divorced:
            rel.rel_text = RELATIOSHIP_DIVORCED;
            break;
        default:
            rel.rel_text = @"";
            break;
    }
    return rel;
}
-(NSString *)pareAgeFromDateString:(NSString *)s_dateOfBirth {
//    NSString *myString = 3-3-2011;
    if([s_dateOfBirth isKindOfClass:[NSNull class]])
        return @"";
    NSString *result=@"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/DD/YYYY"];
    NSDate *dateOfBirth = [dateFormatter dateFromString:s_dateOfBirth];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:dateOfBirth];
    
    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day])))
    {
        result =[@([dateComponentsNow year] - [dateComponentsBirth year] - 1) stringValue];
        
    } else {
        
        result = [@([dateComponentsNow year] - [dateComponentsBirth year]) stringValue];
    }
    return result;
}

-(NSString *)parsePopolarityFromInt:(int) popular{
    NSString * result=@"";
    switch (popular) {
        case verylow :
            result = POPULARITY_VERY_LOW_TEXT;
            break;
        case low:
            result = POPULARITY_LOW_TEXT;
            break;
        case average:
            result = POPULARITY_AVERAGE_TEXT;
            break;
        case high:
            result = POPULARITY_HIGHT_TEXT;
            break;
        case veryhigh:
            result = POPULARITY_VERY_HIGHT_TEXT;
            break;
        default:
            break;
    }
    return result;
}

+(AFHTTPRequestOperation*)getAvatarSync:(NSString*)url callback:(void(^)(UIImage*))handler
{
    AFHTTPClient *httpClient;
    
    if(!([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]))
    {       // check if this is a valid link
        httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:DOMAIN_DATA]];
    }
    else{
        httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    }
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:url
                                                      parameters:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         UIImage *avatar = [UIImage imageWithData:responseObject];
        
         if(handler != nil)
             handler(avatar);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Download image Error: %@", error);
     }];
    
    return operation;
}

+(void) countMutualFriends:(NSString*)profileID callback:(void(^)(NSString*))handler
{
    NSLog(@"profileID : %@",profileID);
    AFHTTPClient* httpClient = [[AFHTTPClient alloc]initWithOakClubAPI:DOMAIN];
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:profileID,key_profileID, nil];
    [httpClient getPath:URL_getDetailMutualFriends parameters:params success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
        NSError *e=nil;
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:&e];
        NSMutableArray * data= [dict valueForKey:key_data];
        
        if(data != nil)
        {
            NSString *mutualCount = [NSString stringWithFormat:@"%i",[data count]];
            handler(mutualCount);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error Code: %i - %@",[error code], [error localizedDescription]);
    }];
}

- (void) SaveSetting{
    NSString * name = self.s_Name;
    NSString *gender = [NSString stringWithFormat:@"%i",self.s_gender.ID];
    NSString *birthday = self.s_birthdayDate;
    NSString *interested = [NSString stringWithFormat:@"%i",self.s_interested.ID];
    NSString *relationship = [NSString stringWithFormat:@"%i",self.s_relationShip.rel_status_id];
    NSString *height = [NSString stringWithFormat:@"%i",self.i_height];
    NSString *weight= [NSString stringWithFormat:@"%i",self.i_weight];
    NSString *ethnicity = self.s_ethnicity;
    NSString *lang = [self.a_language componentsJoinedByString:@","];
    NSString *loc = [NSString stringWithFormat:@"%@",self.s_location.ID];
    NSString *work = [NSString stringWithFormat:@"%i",self.i_work.cate_id];
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc]initWithOakClubAPI:DOMAIN];
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys: name,@"name",// < 20 characters
                                                                        gender,@"gender",// 0/1
                                                                        birthday,@"birthday",// dd/mm/yyyy
                                                                        interested,@"interested_in",// 0/1
                                                                        relationship,@"relationship_status",//rel_status_id
                                                                        height,@"height",//100 < h <300
                                                                        weight,@"weight",//30 < w < 120
                                                                        self.s_school,@"school",
                                                                        ethnicity,@"ethnicity",// string value
                                                                        lang,@"language",
                                                                        loc,@"location",//location_id
                                                                        work,@"work",//cate_id
                                                                        /*self.s_aboutMe*/self.s_aboutMe,@"about_me",//< 256 characters
                                                                        nil];
    [httpClient getPath:URl_setHangoutProfile parameters:params success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
        NSError *e=nil;
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:&e];
        NSMutableArray * data= [dict valueForKey:key_data];
//        return YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@" SaveSetting Profile Error Code: %i - %@",[error code], [error localizedDescription]);
//        return NO;
    }];
//    return YES;
}
-(id) copyWithZone: (NSZone *) zone
{
    Profile *accountCopy = [[Profile allocWithZone: zone] init];
    accountCopy.s_ID = [s_ID copyWithZone:zone];
    accountCopy.s_school = [s_school copyWithZone:zone];
    accountCopy.s_Name = [s_Name copyWithZone:zone];
    accountCopy.s_Email = [s_Email copyWithZone:zone];
    accountCopy.s_Avatar = [s_Avatar copyWithZone:zone];
    accountCopy.s_ProfileStatus = [s_ProfileStatus copyWithZone:zone];
    accountCopy.i_Points = i_Points;
    accountCopy.s_FB_id = [s_FB_id copyWithZone:zone];
    accountCopy.num_Photos = [num_Photos copyWithZone:zone];
    accountCopy.arr_photos = [arr_photos copyWithZone:zone];
    accountCopy.num_points = [num_points copyWithZone:zone];
    accountCopy.s_gender = [s_gender copy];
    accountCopy.num_unreadMessage = [num_unreadMessage copyWithZone:zone];
    accountCopy.s_birthdayDate = [s_birthdayDate copyWithZone:zone];
    accountCopy.s_age = [s_age copyWithZone:zone];
    accountCopy.s_interested = s_interested;
    accountCopy.s_relationShip = [s_relationShip copy];
    accountCopy.i_work = [i_work copy];
    accountCopy.i_weight = i_weight;
    accountCopy.i_height = i_height;
    accountCopy.s_location = [s_location copy];
    accountCopy.a_language = [a_language mutableCopy];
    accountCopy.s_aboutMe = [s_aboutMe copyWithZone:zone];
    accountCopy.s_ethnicity = [s_ethnicity copyWithZone:zone];
    accountCopy.s_meetType = [s_meetType copyWithZone:zone];
    accountCopy.s_popularity = [s_popularity copyWithZone:zone];
    accountCopy.s_snapshotID = [s_snapshotID copyWithZone:zone];
    accountCopy.s_interestedStatus = [s_interestedStatus copyWithZone:zone];
    accountCopy.s_passwordXMPP = [s_passwordXMPP copyWithZone:zone];
    accountCopy.s_usenameXMPP = [s_usenameXMPP copyWithZone:zone];
    accountCopy.dic_Roster = [dic_Roster copyWithZone:zone];
    
    accountCopy.a_favorites = [a_favorites copyWithZone:zone];
    accountCopy.s_user_id = [s_user_id copyWithZone:zone];
    accountCopy.numberMutualFriends = numberMutualFriends ;
    accountCopy.is_deleted = is_deleted;
    accountCopy.is_blocked = is_blocked ;
    accountCopy.is_available = is_available ;
    return accountCopy;
}


-(int) countTotalNotifications
{
    return self.new_visitors + self.new_mutual_attractions + self.new_gifts + self.unread_message;
}


-(void)loadPhotosByProfile:(void(^)(NSMutableArray*))handler{
    AFHTTPClient* request;
    for (int proIndex=0; proIndex < [self.arr_photos count]; proIndex++) {
        if(![self.arr_photos[proIndex] isKindOfClass:[UIImageView class]]) {
            NSString *link = [self.arr_photos objectAtIndex:proIndex];
            if(![link isEqualToString:@""]){
                if(!([link hasPrefix:@"http://"] || [link hasPrefix:@"https://"]))
                {       // check if this is a valid link
                    request = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:DOMAIN_DATA]];
                    [request getPath:link parameters:nil success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
                        UIImage *image = [UIImage imageWithData:JSON];
                        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
//                        CGRect frame = self.sv_photos.frame;
//                        frame.origin.x = CGRectGetWidth(frame) * proIndex;
//                        frame.origin.y = 0;
//                        imageView.frame = frame;
                        [imageView setContentMode:UIViewContentModeScaleAspectFit];
                        [self.arr_photos replaceObjectAtIndex:proIndex withObject:imageView];
                        if((proIndex == [self.arr_photos count]-1) && handler != nil)
                            handler(self.arr_photos);
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error Code: %i - %@",[error code], [error localizedDescription]);
                    }];
                }
                else{
                    request = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
                    [request getPath:link parameters:nil success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
                        UIImage *image = [UIImage imageWithData:JSON];
                        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
//                        CGRect frame = self.sv_photos.frame;
//                        frame.origin.x = CGRectGetWidth(frame) * proIndex;
//                        frame.origin.y = 0;
//                        imageView.frame = frame;
                        [imageView setContentMode:UIViewContentModeScaleAspectFit];
                        [self.arr_photos replaceObjectAtIndex:proIndex withObject:imageView];
                        if((proIndex == [self.arr_photos count]-1) && handler != nil)
                            handler(self.arr_photos);

                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error Code: %i - %@",[error code], [error localizedDescription]);
                    }];
                }
            }
        }
    }
    
}

@end
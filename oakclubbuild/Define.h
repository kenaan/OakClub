//
//  Define.h
//  oakclubbuild
//
//  Created by VanLuu on 4/2/13.
//  Copyright (c) 2013 VanLuu. All rights reserved.
//

#ifndef oakclubbuild_Define_h
#define oakclubbuild_Define_h


//demo version FLAG
#define ENABLE_DEMO true
#define USE_STAGING false
#define USE_MAINHOST false
#define USE_STAGING_MB true
//Hangout
#define sOnline @"Online"

// Snapshot
#define answerYES @"YES"
#define answerNO @"NO"
#define answerMAYBE @"MAYBE"

//================ service API link ================
//#define DOMAIN @"http://staging.oakclub.com/app_dev.php"

#if USE_STAGING
#define HOSTNAME @"staging-mb.oakclub.com"
#define DOMAIN @"http://staging-mb.oakclub.com"
#define DOMAIN_DATA @"http://data1.oakclub.com/" //data2
#endif
#if USE_MAINHOST
#define HOSTNAME @"oakclub.com"
#define DOMAIN @"http://oakclub.com"
#define DOMAIN_DATA @"http://data1.oakclub.com/" //data2
#endif
#if USE_STAGING_MB
#define HOSTNAME @"staging-mb.oakclub.com"
#define DOMAIN @"http://staging-mb.oakclub.com"
#define DOMAIN_DATA @"http://data1.oakclub.com/"
#endif
//============== application key =============
#define key_appLanguage @"appLanguage"
#define key_ChosenLanguage @"appChosenLanguage"
//============== application value =============
#define value_appLanguage_VI @"vi"
#define value_appLanguage_EN @"en"
//============== APIs =============
#define DOMAIN_AT @"@oakclub.com"
#define DOMAIN_AT_FMT @"%@@oakclub.com"
#define URL_getHangoutProfile @"service/getHangoutProfile"
#define URl_setHangoutProfile @"service/setHangoutProfile"
#define URL_me @"service/me"
#define URL_searchByLocation @"service/searchByLocation"
#define URL_setBidFeature @"service/setBidFeature"
#define URL_getAccountSetting @"service/getAccountSetting"
#define URL_getListWhoFavoritedMe @"service/getListWhoFavoritedMe"
#define URL_getListWhoWantsToMeetMe @"service/getListWhoWantsToMeetMe"
#define URL_getListWhoCheckedMeOut @"service/getListWhoCheckedMeOut"
#define URL_getListMyFavorites @"service/getListMyFavorites"
#define URL_getListFeature @"service/getListFeature"
//#define URL_getListMutualMatch @"service/getListMutualAttractions"
#define URL_getListIWantToMeet @"service/getListIWantToMeet"
#define URL_getSnapShot @"service/getSnapshot"
#define URL_setFavorite @"service/setFavorite"
#define URL_getSnapshotSetting @"service/getSnapshotSetting"
#define URL_setSnapshotSetting @"service/setSnapshotSetting"
#define URL_chat_post @"service/chat/post"
#define URL_getHistoryMessages @"service/getHistoryMessages"
#define URL_deleteHangoutProfile @"service/deleteHangoutProfile"
#define URL_getDetailMutualFriends @"service/getDetailMutualFriends"
#define URL_getMutualInfo @"service/getMutualInfo"
#define URL_getListCountry @"service/getListCountry"
#define URL_getListPhotos @"service/getListPhotos"
#define URL_getListCityByCountry @"service/getListCityByCountry"
#define URL_getListLangRelWrkEth @"service/getListLangRelWrkEth"
#define URL_getListMaybeIWantToMeet @"service/getListMaybe"
#define URL_getMutualInfo @"service/getMutualInfo"
#define URL_addToMyFavorite @"service/addToMyFavorite"
#define URL_removeMyFavorite @"service/removeMyFavorite"
#define URL_unBlockHangoutProfile @"service/unBlockHangoutProfile"
#define URL_blockHangoutProfile @"service/blockHangoutProfile"
#define URL_setIWantToMeet @"service/setIWantToMeet"
#define URL_getListBlocking @"service/getListBlocking"
#define URL_getListChat @"service/getListChat"
#define URL_getListWhoLikeMe @"service/getListWhoLikeMe"
#define URL_getListMutualMatch @"service/getListMutualMatch"
#define URL_setLocationUser @"service/setLocationUser"
#define URL_sendRegister @"service/sendRegister"
#define URL_uploadPhoto @"service/uploadPhotoUser"
#define URL_deletePhoto @"service/deletePhoto"
#define URL_setReadMessages @"service/setReadMessages"
#define URL_setViewedMatchMutual @"service/setViewedMatchMutual"
#define URL_reportInvalid @"service/reportInvalid"
//================ service API keys ================
//root
#define key_status @"status"
#define key_data @"data"
//profile
#define key_msg @"msg"
#define key_aboutMe @"about_me"
#define key_birthday @"birthday_date"
#define key_avatar @"avatar"
#define key_name @"name"
#define key_profileID @"profile_id"
#define key_profileStatus @"profile_status"
#define key_gender @"gender"
#define key_interested @"interested"
#define key_language @"language"
#define key_points @"points"
#define key_facebookID @"fb_id"
#define key_online @"online"
#define key_relationship @"relationship_status"
#define key_snapshotID @"snapshot_id"
#define key_ethnicity @"ethnicity"
#define key_work @"work"
#define key_school @"school"
#define key_email @"email"
#define key_weight @"weight"
#define key_height @"height"
#define key_meet_type @"meet_type"
#define key_popularity @"popularity"
#define key_interestedStatus @"interested_status"
#define key_countPhotos @"count_photos"
#define key_passwordXMPP @"xmpp_password"
#define key_usernameXMPP @"xmpp_username"
//location of profile
#define key_location @"location"
//#define key_locationID @"id"
#define key_locationName @"name"
#define key_locationCountry @"country"
#define key_locationCountryCode @"country_code"
#define key_locationCoordinates @"coordinates"
#define key_coordinatesLatitude @"latitude"
#define key_coordinatesLongitude @"longitude"
#define key_purpose_of_search @"purpose_of_search"
#define key_gender_of_search @"gender_of_search"
#define key_age_from @"age_from"
#define key_age_to @"age_to"
#define key_is_interests @"is_interests"
#define key_is_likes @"is_likes"
#define key_is_work @"is_work"
#define key_is_school @"is_school"
#define key_show_fof @"show_fof"
#define key_status_interested_in @"status_interested_in"
#define key_new_people @"new_people"
#define key_friends @"friends"
#define key_status_fof @"status_fof"
#define key_range @"range"
#define key_new_people_status @"status_interested_in.new_people"
#define key_FOF_status @"status_interested_in.fof"
#define key_locationID @"id"
#define key_BlockList @"block_list"
#define key_PriorityList @"priority_list"
#define key_StrProfileID @"str_profile_id"
#define key_MutualFriends @"key_mutualFriends"
#define key_MutualLikes @"mutualLikes"
#define key_URL @"URL"
// list chat of profile
#define key_rosters @"rosters"
#define key_match @"matches"

#define key_reportContent @"content"
//================ service API values ================
#define value_online @"Online"
#define value_offline @"Offline"
//purpose_of_search
#define value_Date @"date"
#define value_MakeFriend @"make_friend"
#define value_Chat @"chat"
//gender_of_search
#define value_Male @"male"
#define value_Female @"female"
#define value_All @"all"
//
#define value_TRUE @"true"
#define value_FALSE @"false"
//================ Hangout View ==================
#define ZOOM_VIEW_TAG 100
#define ZOOM_STEP 1.5

#define THUMB_HEIGHT 75
#define THUMB_V_PADDING 2
#define THUMB_H_PADDING 2
#define CREDIT_LABEL_HEIGHT 20
#define START_X 77

#define AUTOSCROLL_THRESHOLD 30
#define NUMBER_COLUMN_HANGOUT 3
// ============= NearNow View===================
#define NearByCellWidth 104
#define NearByCellHeight 104
#define NearByPaddingTop 3.0
#define NearByPaddingLeft 3.0
#define NearByMargin 2.0
//================ MyLink/Visitors View ==================
#define NUMBER_OF_COLUMN 4 

//================ SnapShot ==================
#define key_first_name @"first_name"
#define key_last_name @"last_name"
#define key_age @"age"
#define key_avatar @"avatar"
#define key_photos @"photos"
#define MAX_FREE_SNAPSHOT 100

//============= Popularity =================
#define POPULARITY_VERY_LOW_TEXT  @"Very Low";
#define POPULARITY_LOW_TEXT  @"Low";
#define POPULARITY_AVERAGE_TEXT @"Average";
#define POPULARITY_HIGHT_TEXT @"High";
#define POPULARITY_VERY_HIGHT_TEXT @"Very High";

//=================Interested status==================
#define interestedStatusNO 3
#define interestedStatusYES 1
#define interestedStatusMAYBE 2

//=================Relationship status==================
#define RELATIOSHIP_SINGLE @"Single"
#define RELATIOSHIP_COMPLICATED @"Complicated"
#define RELATIOSHIP_MARRIED @"Married"
#define RELATIOSHIP_INRELATIONSHIP @"In RelationShip"
#define RELATIOSHIP_ENGAGED @"Engaged"
#define RELATIOSHIP_OPENRELATIONSHIP @"Open Relationship"
#define RELATIOSHIP_WIDOWED @"Widowed"
#define RELATIOSHIP_SEPARATED @"Separated"
#define RELATIOSHIP_DIVORCED @"Divorced"
// =================Type List=============================
#define LISTTYPE_RELATIONSHIP 0
#define LISTTYPE_LOCATION 1
#define LISTTYPE_CITY 2
#define LISTTYPE_COUNTRY 3
#define LISTTYPE_LANGUAGE 4
#define LISTTYPE_WORK 5
#define LISTTYPE_ETHNICITY 6
#define LISTTYPE_GENDER 7
#define LISTTYPE_HERETO 8
#define LISTTYPE_WANTTOSEE 9
#define LISTTYPE_WITHWHO 10
#define LISTTYPE_EMAILSETTING 11
#define LISTTYPE_INTERESTED 12 

#define key_WorkCate @"work_cate"



#define RelationshipList ([NSArray arrayWithObjects:RELATIOSHIP_SINGLE,RELATIOSHIP_COMPLICATED,RELATIOSHIP_MARRIED,RELATIOSHIP_INRELATIONSHIP,RELATIOSHIP_ENGAGED,RELATIOSHIP_OPENRELATIONSHIP,RELATIOSHIP_WIDOWED,RELATIOSHIP_SEPARATED,RELATIOSHIP_DIVORCED, nil])

#define LocationList  ([NSArray arrayWithObjects:@"Country", @"City", nil])

#define GenderList ([[NSArray alloc]initWithObjects:[[NSDictionary alloc] initWithObjectsAndKeys:@"Female",@"text",@"0",@"ID", nil],[[NSDictionary alloc] initWithObjectsAndKeys:@"Male",@"text",@"1",@"ID", nil], nil])
#define GenderList_vi ([[NSArray alloc]initWithObjects:[[NSDictionary alloc] initWithObjectsAndKeys:@"Nữ",@"text",@"0",@"ID", nil],[[NSDictionary alloc] initWithObjectsAndKeys:@"Nam",@"text",@"1",@"ID", nil], nil])
#define WithWhoOptionList  ([NSArray arrayWithObjects:value_Male, value_Female,@"Both", nil])

#define HereToOptionList  ([[NSArray alloc]initWithObjects:[[NSDictionary alloc] initWithObjectsAndKeys:@"Date",@"text",value_Date,@"key", nil],[[NSDictionary alloc] initWithObjectsAndKeys:@"Make New Friends",@"text",value_MakeFriend,@"key", nil],[[NSDictionary alloc] initWithObjectsAndKeys:@"Chat",@"text",value_Chat,@"key", nil], nil])

#define value_Frequent @"Frequent"
#define value_Regular @"Regular"
#define value_Rare @"Rare"
#define value_Never @"Never"
#define EmailSettingOptionList  ([NSArray arrayWithObjects:value_Frequent,value_Regular,value_Rare, value_Never, nil])

#define WantToSeeOptionList  ([NSArray arrayWithObjects:@"New People", @"Friends",@"Friends of Friends", nil])

#define ProfileItems  ([NSArray arrayWithObjects:@"Name", @"Birthdate",@"Interested In", @"Gender",@"Relationship",@"Location",@"Height",@"Weight",@"Ethnicity",@"School",@"Language",@"Work",@"About me",@"Popularity",  nil])
#define MyProfileItemList  ([NSArray arrayWithObjects:@"Name", @"Birthdate",@"Email",@"Gender", @"Relationship",@"Height",@"Weight", @"Interested In", @"Location",@"Ethnicity",@"School",@"Language",@"Work",@"About me", nil])
#define SnapshotSettingItemList  ([NSArray arrayWithObjects:@"I'm here to", @"I want to see",@"With who", @"Age around",@"Nearby GPS",@"Where",@"Range", nil])
//==============================
#define MAXLENGTH_NAME 20
#define MAXLENGTH_ABOUT 256

#define MIN_WEIGHT 30 //kg
#define MAX_WEIGHT 200 //kg

#define MIN_HEIGHT 100 //cm
#define MAX_HEIGHT 300 //cm

#define MIN_AGE 16
#define MAX_AGE 80



#define COLOR_BLUE_CELLTEXT [UIColor colorWithRed:(56/255.0) green:(84/255.0) blue:(135/255.0) alpha:1]
#define COLOR_BLUE_CELLBG [UIColor colorWithRed:(190/255.0) green:(237/255.0) blue:(248/255.0) alpha:1]
#define CGCOLOR_BLUE_CELLBG [UIColor colorWithRed:(190/255.0) green:(237/255.0) blue:(248/255.0) alpha:1].CGColor
#define COLOR_PURPLE [UIColor colorWithRed:(121/255.0) green:(1/255.0) blue:(88/255.0) alpha:1]
#define CGCOLOR_PURPLE ([UIColor colorWithRed:(121/255.0) green:(1/255.0) blue:(88/255.0) alpha:1].CGColor)

#define key_isUseGPS @"useGPS"
#define key_isFirstSnapshot @"isFirstSnapshot"
//=============== Advanced setting=============
#define FriendList  ([NSArray arrayWithObjects:@"Tran Van Quy", @"Vanancy Luu",@"Van Khanh", @"Thu Ha",@"RuaCon ChayCham",@"Phuong Lovely Nguyen",@"Mai Xuan Tham", nil])

#define FindPeopleItemList  ([NSArray arrayWithObjects:@"Interests", @"Likes",@"Work network", @"School network", nil])
#define EmailSettingItemList  ([NSArray arrayWithObjects:@"Preferred", @"Notifications", nil])

// =============== registers setting ================
#define ProfileConfirmItems  ([NSArray arrayWithObjects:@"Email", @"Gender",@"Interested In",@"Relationship status",@"Birthdate",@"Location",@"Ethnicity",@"About me",nil])



//=============== FUNCTIONS ================
//====== Fonts =====
#define FONT_NOKIA(s) [UIFont fontWithName:@"UTM Nokia Standard" size:s]
#define FONT_NOKIA_BOLD [UIFont fontWithName:@"UTM Nokia Standard Bold" size:17.0]
//#define FONT_NOKIA_BOLD(s) [UIFont fontWithName:@"UTM Nokia Standard Bold" size:s]

#define FONT_HELVETICANEUE_LIGHT(s) [UIFont fontWithName:@"HelveticaNeue-Light" size:s]

//====== Strings =====
#define NSLocalizedString(key, comment) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]


#endif
typedef enum {
    NAME,
    BIRTHDATE,
    EMAIL,
    GENDER,
    RELATIONSHIP,
    HEIGHT,
    WEIGHT,
    INTERESTED_IN,
    LOCATION,
    ETHNICITY,
    SCHOOL,
    LANGUAGE,
    WORK,
    ABOUT_ME
} EditItems;

typedef enum {
    verylow,
    low,
    average,
    high,
    veryhigh
} Popularity;

typedef enum {
    None,
    single,
    complicated,
    married,
    inRelationship,
    engaged,
    openRelationship,
    widowed,
    separated,
    divorced
} RelationEnum;

typedef enum {
    HERETO,
    WANTTOSEE,
    WITHWHO,
    AGEAROUND,
    NEARBY,
    WHERE,
    RANGE
} SnapshotEditItems;

typedef enum{
    FEMALE,
    MALE
}GenderEnum;

typedef enum {
    LanguageGroup               = 0,
    GenderSearchGroup           = 1,
    HereToGroup                 = 2,
    ShowMeGroup                 = 3,
    AgeGroup                    = 4,
    RangeGroup                  = 5,
    MoreGroup                   = 6,
    NumOfSettingGroup           = 7,
} SettingGroup;

typedef enum{
    MatchUnViewed,
    MatchViewed,
    ChatUnviewed,
    ChatViewed,
}ListChatStatus;
class APIData {
  static const String domainLink = "https://netrecs.com/";
  static const String domainApiLink = domainLink + 'api/';

  // API Links
  static const String loginApi = domainApiLink + "login";
  static const String fbLoginApi = domainApiLink + "fblogin";
  static const String googleLoginApi = domainApiLink + "googlelogin";
  static const String userProfileApi = domainApiLink + "userProfile";
  static const String profileApi = domainApiLink + "profile";
  static const String registerApi = domainApiLink + "register";
  static const String allMovies = domainApiLink + "movie";
  static const String sliderApi = domainApiLink + "slider";
  static const String allDataApi = domainApiLink + "main";
  static const String movieTvApi = domainApiLink + "movietv";
  static const String topMenu = domainApiLink + "menu";
  static Uri verifyOTPApi = Uri.parse(domainApiLink + "verifycode");
  static Uri forgotPasswordApi = Uri.parse(domainApiLink + "forgotpassword");
  static const String resetPasswordApi = domainApiLink + "resetpassword";
  static const String menuDataApi = domainApiLink + "MenuByCategory";
  static const String episodeDataApi = domainApiLink + "episodes/";
  static const String watchListApi = domainApiLink + "showwishlist";
  static const String watchHistory = domainApiLink + "watchhistory";
  static Uri addWatchHistory = Uri.parse(domainApiLink + "addwatchhistory");
  static const String deleteAllWatchHistory =
      domainApiLink + "delete_watchhistory";
  static const String deleteWatchHistory =
      domainApiLink + "delete_watchhistory/";
  static const String removeWatchlistMovie = domainApiLink + "removemovie/";
  static const String removeWatchlistSeason = domainApiLink + "removeseason/";
  static const String addWatchlist = domainApiLink + "addwishlist";
  static const String checkWatchlistSeason = domainApiLink + "checkwishlist/S/";
  static const String checkWatchlistMovie = domainApiLink + "checkwishlist/M/";
  static const String homeDataApi = domainApiLink + "home";
  static const String faq = domainApiLink + "faq";
  static const String userProfileUpdate = domainApiLink + "profileupdate";
  static const String stripeProfileApi = domainApiLink + "stripeprofile";
  static const String stripeDetailApi = domainApiLink + "stripedetail";
  static const String clientNonceApi = domainApiLink + "bttoken";
  static const String sendPaymentNonceApi = domainApiLink + "btpayment";
  static const String stripeUpdateApi = domainApiLink + "stripeupdate/";
  static const String paypalUpdateApi = domainApiLink + "paypalupdate/";
  static const String sendPaystackDetails = domainApiLink + "paystack";
  static const String applyCouponApi = domainApiLink + "applycoupon";
  static const String showScreensApi = domainApiLink + "showscreens";
  static const String screensProfilesApi = domainApiLink + "screenprofile";
  static const String updateScreensApi = domainApiLink + "updatescreen";
  static const String screenLogOutApi = domainApiLink + "logout";
  static const String couponPaymentApi = domainApiLink + "couponpayment";
  static const String notificationsApi = domainApiLink + "notifications";
  static const String sendRazorDetails = domainApiLink + "paystore";
  static const String postVideosRating = domainApiLink + "rating";
  static const String checkVideosRating = domainApiLink + "checkrating";
  static const String downloadCounter = domainApiLink + "downloadcounter";
  static const String postBlogComment = domainApiLink + "addcomment";
  static const String actorMovies = domainApiLink + "detail/";
  static const String applyGeneralCoupon = domainApiLink + "verifycoupon";
  static const String getCoupons = domainApiLink + "coupon";

// URI Links
  static const String loginImageUri = domainLink + "images/login/";
  static const String logoImageUri = domainLink + "images/logo/";
  static const String landingPageImageUri = domainLink + "images/main-home/";
  static const String movieImageUri = domainLink + "images/movies/thumbnails/";
  static const String movieImageUriPosterMovie =
      domainLink + "images/movies/posters/";
  static const String tvImageUriPosterTv =
      domainLink + "images/tvseries/posters/";
  static const String tvImageUriTv = domainLink + "images/tvseries/thumbnails/";
  static const String profileImageUri = domainLink + "images/user/";
  static const String silderImageUri = domainLink + "images/home_slider/";
  static const String shareSeasonsUri = domainLink + "show/detail/";
  static const String shareMovieUri = domainLink + "movie/detail/";
  static const String blogImageUri = domainLink + "images/blog/";
  static const String menuTabLogoUri = domainLink + "images/menulogos/";
  static const String actorsImages = domainLink + "images/actors/";
  static const String directorsImages = domainLink + "images/directors/";
  static const String appSlider = domainLink + "images/app_slider/";

/*
*           Replace android app ID with your app package name.
*           Replace IOS app ID with your IOS app ID.
*/
  // Replace with your app name
  static const String appName = 'Netrecs';
  // Replace with your android app id name
  static const String androidAppId = 'com.netrecs.client';
  // Replace with your ios app id name
  static const String iosAppId = 'com.netrecs.client';
  static const String shareAndroidAppUrl =
      'https://play.google.com/store/apps/details?id=' + '$androidAppId';

// For notifications
  static const String onSignalAppId = "587249c5-44b9-4e10-b45a-b99ad7f21c95";

// To play google drive video
  static const String googleDriveApi = '';

// For Player
  static const String tvSeriesPlayer = domainLink + 'watchseason/';
  static const String moviePlayer = domainLink + 'watchmovie/';
  static const String episodePlayer = domainLink + 'watchepisode/';
  static const String trailerPlayer = domainLink + 'movietrailer/';
  static const String tvtrailerPlayer = domainLink + 'tvtrailer/';
}

import 'package:flutter/foundation.dart';

class Config extends ChangeNotifier {
  Config({
    this.id,
    this.logo,
    this.favicon,
    this.title,
    this.wEmail,
    this.verifyEmail,
    this.download,
    this.freeSub,
    this.freeDays,
    this.stripePubKey,
    this.stripeSecretKey,
    this.paypalMarEmail,
    this.currencyCode,
    this.currencySymbol,
    this.invoiceAdd,
    this.primeMainSlider,
    this.catlog,
    this.withlogin,
    this.primeGenreSlider,
    this.donation,
    this.donationLink,
    this.primeFooter,
    this.primeMovieSingle,
    this.termsCondition,
    this.privacyPol,
    this.refundPol,
    this.copyright,
    this.stripePayment,
    this.paypalPayment,
    this.razorpayPayment,
    this.ageRestriction,
    this.payuPayment,
    this.bankdetails,
    this.accountNo,
    this.branch,
    this.accountName,
    this.ifscCode,
    this.bankName,
    this.paytmPayment,
    this.paytmTest,
    this.preloader,
    this.fbLogin,
    this.gitlabLogin,
    this.googleLogin,
    this.welEml,
    this.blog,
    this.isPlaystore,
    this.isAppstore,
    this.playstore,
    this.appstore,
    this.color,
    this.colorDark,
    this.userRating,
    this.comments,
    this.braintree,
    this.paystack,
    this.removeLandingPage,
    this.coinpay,
    this.aws,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? logo;
  String? favicon;
  String? title;
  String? wEmail;
  dynamic verifyEmail;
  dynamic download;
  dynamic freeSub;
  dynamic freeDays;
  String? stripePubKey;
  String? stripeSecretKey;
  String? paypalMarEmail;
  String? currencyCode;
  String? currencySymbol;
  String? invoiceAdd;
  dynamic primeMainSlider;
  dynamic catlog;
  dynamic withlogin;
  dynamic primeGenreSlider;
  dynamic donation;
  dynamic donationLink;
  dynamic primeFooter;
  dynamic primeMovieSingle;
  String? termsCondition;
  String? privacyPol;
  String? refundPol;
  String? copyright;
  dynamic stripePayment;
  dynamic paypalPayment;
  dynamic razorpayPayment;
  dynamic ageRestriction;
  dynamic payuPayment;
  dynamic bankdetails;
  String? accountNo;
  dynamic branch;
  String? accountName;
  String? ifscCode;
  String? bankName;
  dynamic paytmPayment;
  dynamic paytmTest;
  dynamic preloader;
  dynamic fbLogin;
  dynamic gitlabLogin;
  dynamic googleLogin;
  dynamic welEml;
  dynamic blog;
  dynamic isPlaystore;
  dynamic isAppstore;
  String? playstore;
  String? appstore;
  String? color;
  dynamic colorDark;
  dynamic userRating;
  dynamic comments;
  dynamic braintree;
  dynamic paystack;
  dynamic removeLandingPage;
  dynamic coinpay;
  dynamic aws;
  dynamic createdAt;
  DateTime? updatedAt;

  factory Config.fromJson(Map<String, dynamic> json) => Config(
    id: json["id"],
    logo: json["logo"],
    favicon: json["favicon"],
    title: json["title"],
    wEmail: json["w_email"],
    verifyEmail: json["verify_email"],
    download: json["download"],
    freeSub: json["free_sub"],
    freeDays: json["free_days"],
    stripePubKey: json["stripe_pub_key"],
    stripeSecretKey: json["stripe_secret_key"],
    paypalMarEmail: json["paypal_mar_email"],
    currencyCode: json["currency_code"],
    currencySymbol: json["currency_symbol"],
    invoiceAdd: json["invoice_add"],
    primeMainSlider: json["prime_main_slider"],
    catlog: json["catlog"],
    withlogin: json["withlogin"],
    primeGenreSlider: json["prime_genre_slider"],
    donation: json["donation"],
    donationLink: json["donation_link"],
    primeFooter: json["prime_footer"],
    primeMovieSingle: json["prime_movie_single"],
    termsCondition: json["terms_condition"],
    privacyPol: json["privacy_pol"],
    refundPol: json["refund_pol"],
    copyright: json["copyright"],
    stripePayment: json["stripe_payment"],
    paypalPayment: json["paypal_payment"],
    razorpayPayment: json["razorpay_payment"],
    ageRestriction: json["age_restriction"],
    payuPayment: json["payu_payment"],
    bankdetails: json["bankdetails"],
    accountNo: json["account_no"],
    branch: json["branch"],
    accountName: json["account_name"],
    ifscCode: json["ifsc_code"],
    bankName: json["bank_name"],
    paytmPayment: json["paytm_payment"],
    paytmTest: json["paytm_test"],
    preloader: json["preloader"],
    fbLogin: json["fb_login"],
    gitlabLogin: json["gitlab_login"],
    googleLogin: json["google_login"],
    welEml: json["wel_eml"],
    blog: json["blog"],
    isPlaystore: json["is_playstore"],
    isAppstore: json["is_appstore"],
    playstore: json["playstore"],
    appstore: json["appstore"],
    color: json["color"],
    colorDark: json["color_dark"],
    userRating: json["user_rating"],
    comments: json["comments"],
    braintree: json["braintree"],
    paystack: json["paystack"],
    removeLandingPage: json["remove_landing_page"],
    coinpay: json["coinpay"],
    aws: json["aws"],
    createdAt: json["created_at"],
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "logo": logo,
    "favicon": favicon,
    "title": title,
    "w_email": wEmail,
    "verify_email": verifyEmail,
    "download": download,
    "free_sub": freeSub,
    "free_days": freeDays,
    "stripe_pub_key": stripePubKey,
    "stripe_secret_key": stripeSecretKey,
    "paypal_mar_email": paypalMarEmail,
    "currency_code": currencyCode,
    "currency_symbol": currencySymbol,
    "invoice_add": invoiceAdd,
    "prime_main_slider": primeMainSlider,
    "catlog": catlog,
    "withlogin": withlogin,
    "prime_genre_slider": primeGenreSlider,
    "donation": donation,
    "donation_link": donationLink,
    "prime_footer": primeFooter,
    "prime_movie_single": primeMovieSingle,
    "terms_condition": termsCondition,
    "privacy_pol": privacyPol,
    "refund_pol": refundPol,
    "copyright": copyright,
    "stripe_payment": stripePayment,
    "paypal_payment": paypalPayment,
    "razorpay_payment": razorpayPayment,
    "age_restriction": ageRestriction,
    "payu_payment": payuPayment,
    "bankdetails": bankdetails,
    "account_no": accountNo,
    "branch": branch,
    "account_name": accountName,
    "ifsc_code": ifscCode,
    "bank_name": bankName,
    "paytm_payment": paytmPayment,
    "paytm_test": paytmTest,
    "preloader": preloader,
    "fb_login": fbLogin,
    "gitlab_login": gitlabLogin,
    "google_login": googleLogin,
    "wel_eml": welEml,
    "blog": blog,
    "is_playstore": isPlaystore,
    "is_appstore": isAppstore,
    "playstore": playstore,
    "appstore": appstore,
    "color": color,
    "color_dark": colorDark,
    "user_rating": userRating,
    "comments": comments,
    "braintree": braintree,
    "paystack": paystack,
    "remove_landing_page": removeLandingPage,
    "coinpay": coinpay,
    "aws": aws,
    "created_at": createdAt,
    "updated_at": updatedAt!.toIso8601String(),
  };
}

class Plan{
  Plan({
    this.id,
    this.planId,
    this.name,
    this.currency,
    this.currencySymbol,
    this.amount,
    this.interval,
    this.intervalCount,
    this.trialPeriodDays,
    this.status,
    this.screens,
    this.download,
    this.downloadlimit,
    this.deleteStatus,
    this.createdAt,
    this.updatedAt,
    this.pricingTexts,
  });

  int? id;
  dynamic planId;
  String? name;
  String? currency;
  String? currencySymbol;
  dynamic amount;
  dynamic interval;
  dynamic intervalCount;
  dynamic trialPeriodDays;
  dynamic status;
  dynamic screens;
  dynamic download;
  dynamic downloadlimit;
  dynamic deleteStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic pricingTexts;

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    id: json["id"],
    planId: json["plan_id"],
    name: json["name"],
    currency: json["currency"],
    currencySymbol: json["currency_symbol"],
    amount: json["amount"],
    interval: json["interval"],
    intervalCount: json["interval_count"],
    trialPeriodDays: json["trial_period_days"],
    status: json["status"],
    screens: json["screens"],
    download: json["download"],
    downloadlimit: json["downloadlimit"],
    deleteStatus: json["delete_status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    pricingTexts: json["pricing_texts"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "plan_id": planId,
    "name": name,
    "currency": currency,
    "currency_symbol": currencySymbol,
    "amount": amount,
    "interval": interval,
    "interval_count": intervalCount,
    "trial_period_days": trialPeriodDays,
    "status": status,
    "screens": screens,
    "download": download,
    "downloadlimit": downloadlimit,
    "delete_status": deleteStatus,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "pricing_texts": pricingTexts,
  };
}
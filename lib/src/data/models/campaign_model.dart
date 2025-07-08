class CampaignModel {
  final String? id;
  final String? name;
  final String? organizer;
  final String? description;
  final String? media;
  final List<CampaignDocument>? documents;
  final List<String>? tags;
  final DateTime? targetDate;
  final int? targetAmount;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CampaignModel({
    this.id,
    this.name,
    this.organizer,
    this.description,
    this.media,
    this.documents,
    this.tags,
    this.targetDate,
    this.targetAmount,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      organizer: json['organizer'] as String?,
      description: json['description'] as String?,
      media: json['media'] as String?,
      documents: (json['documents'] as List<dynamic>?)?.map((e) => CampaignDocument.fromJson(e)).toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      targetDate: json['target_date'] != null ? DateTime.tryParse(json['target_date']) : null,
      targetAmount: json['target_amount'] as int?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}

class CampaignDocument {
  final String? id;
  final String? url;

  CampaignDocument({this.id, this.url});

  factory CampaignDocument.fromJson(Map<String, dynamic> json) {
    return CampaignDocument(
      id: json['_id'] as String?,
      url: json['url'] as String?,
    );
  }
}

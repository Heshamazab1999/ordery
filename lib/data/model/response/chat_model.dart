class ChatModel {
  int totalSize;
  int limit;
  int offset;
  List<Messages> messages;

  ChatModel({this.totalSize, this.limit, this.offset, this.messages});

  ChatModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages.add(new Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this.totalSize;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.messages != null) {
      data['messages'] = this.messages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  int id;
  int conversationId;
  CustomerId customerId;
  DeliverymanId deliverymanId;
  String message;
  String reply;
  List<String> attachment;
  List<String> image;
  bool isReply;
  String createdAt;
  String updatedAt;

  Messages(
      {this.id,
        this.conversationId,
        this.customerId,
        this.deliverymanId,
        this.message,
        this.reply,
        this.attachment,
        this.image,
        this.isReply,
        this.createdAt,
        this.updatedAt});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    try{
      conversationId = json['conversation_id'];
    }catch(e){
      conversationId = int.parse(json['conversation_id']);
    }
    if(json['customer_id']!=null){
      customerId = json['customer_id'] != null
          ? new CustomerId.fromJson(json['customer_id'])
          : null;
    }

    if(json['deliveryman_id']!= null){
      deliverymanId = json['deliveryman_id'] != null
          ? new DeliverymanId.fromJson(json['deliveryman_id'])
          : null;
    }
    message = json['message'];
    reply = json['reply'];
    if(json['attachment']!=null && json['attachment']!=[]){
      attachment = json['attachment'].cast<String>();
    }
    if(json['image']!=null){
      image = json['image'].cast<String>();
    }

    isReply = json['is_reply'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['conversation_id'] = this.conversationId;
    if (this.customerId != null) {
      data['customer_id'] = this.customerId.toJson();
    }
    if (this.deliverymanId != null) {
      data['deliveryman_id'] = this.deliverymanId.toJson();
    }
    data['message'] = this.message;
    data['reply'] = this.reply;
    data['attachment'] = this.attachment;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;


    return data;
  }
}

class CustomerId {
  String name;
  String image;

  CustomerId({this.name, this.image});

  CustomerId.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
class DeliverymanId {
  String name;
  String image;

  DeliverymanId({this.name, this.image});

  DeliverymanId.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
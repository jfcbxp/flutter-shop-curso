import 'package:shop/model/cart_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order(
      {required this.id,
      required this.total,
      required this.products,
      required this.date});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

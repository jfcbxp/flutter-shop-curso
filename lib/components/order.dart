import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:shop/model/order.dart';

class OrderWidget extends StatelessWidget {
  final Order order;
  const OrderWidget({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('R\$ ${order.total.toStringAsFixed(2)}'),
        subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(order.date)),
        trailing: IconButton(
          icon: Icon(Icons.expand_more),
          onPressed: () {},
        ),
      ),
    );
  }
}

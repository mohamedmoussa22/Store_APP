import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as Oi;
import 'dart:math';

class OrderItem extends StatefulWidget {
  // here we used a stateful widget so no other widget is intersited in changes here so changes effect this Widget only
  final Oi.OrderItem orderItem;
  OrderItem(this.orderItem);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderItem.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                .format(widget.orderItem.dateTime)),
            trailing: IconButton(
              icon:
                  _expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              height: min(widget.orderItem.products.length * 20.0 + 10, 180),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: ListView(
                children: widget.orderItem.products
                    .map((index) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              index.title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text('${index.quantity} x \$${index.price}',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey))
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}

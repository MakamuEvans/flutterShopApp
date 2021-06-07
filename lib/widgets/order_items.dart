import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/orders.dart' as oi;

class OrderItem extends StatefulWidget {
  final oi.OrderItem orderItem;

  OrderItem(this.orderItem);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: _expanded
          ? min(widget.orderItem.products.length * 20.0 + 110, 200)
          : 100,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('KES: ${widget.orderItem.amount}'),
              subtitle: Text(DateFormat('dd MM yyyy hh:mm')
                  .format(widget.orderItem.dateTime)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded ? min(widget.orderItem.products.length * 20.0 + 10, 80) : 0,
              child: ListView(
                children: widget.orderItem.products
                    .map((e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${e.quantity}x KES: ${e.price}',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            )
                          ],
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

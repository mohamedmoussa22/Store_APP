import 'package:Store_APP/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productID;
  final double price;
  final int quantity;
  final String title;
  CartItem(
      {@required this.id,
      this.productID,
      this.price,
      this.quantity,
      this.title});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productID);
      },
      confirmDismiss: (driection) {
        /// here i should return true if user confirmed to delete this or false if he don't want to delete it
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text(('Are you Sure ?')),
                  content:
                      Text('Do you want to remove the item from the cart ?'),
                  actions: [
                    TextButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop(
                            false); // always remmber that flutter shows screen as an stack of screens this line of code remove the last screen in my stack and this screen is the dialog
                      },
                    ),
                    TextButton(
                      child: Text("Yes"),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    )
                  ],
                ));
      },
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FittedBox(child: Text('\$$price'))),
            ),
            title: Text(title),
            subtitle: Text('Total : \$${price * quantity}'),
            trailing: Text('$quantity\ x'),
          ),
        ),
      ),
    );
  }
}

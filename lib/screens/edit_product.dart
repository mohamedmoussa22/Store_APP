import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProdcutScreen extends StatefulWidget {
  static const routeName = 'edit_product';
  _EditProdcutScreenState createState() => _EditProdcutScreenState();
}

class _EditProdcutScreenState extends State<EditProdcutScreen> {
  final _priceFoucesNode = FocusNode();
  final _descriptionFoucesNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFoucesNode = FocusNode();
  final _form = GlobalKey<
      FormState>(); // i did this so i can interact with my form we use Global key when we want to interact with widget in our code
  var _editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');
  var isInit = true;
  var _isloading = false;

  @override
  void initState() {
    _imageUrlFoucesNode.addListener(
        _updateImageURL); // _updateImageURL called when foucesed is changed
    super.initState();
  }

  var _isInit = true;
  var _map = {'title': '', 'price': '', 'description': '', 'iamgeUrl': ''};

  @override
  void didChangeDependencies() {
    // this function workes  before exectution
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context).findProduct(productId);
        _map = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  void dispose() {
    _imageUrlFoucesNode.removeListener(_updateImageURL);
    _priceFoucesNode.dispose();
    _descriptionFoucesNode
        .dispose(); // you must make sure to delete them from memory otherwise it will lead to memory leaks
    _imageUrlController.dispose();
    _imageUrlFoucesNode.dispose();
    super.dispose();
  }

  void _updateImageURL() {
    if (!_imageUrlFoucesNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.endsWith('.png') &&
                  !_imageUrlController.text.endsWith('.jpg') &&
                  !_imageUrlController.text.endsWith('.jpeg')) &&
              !_imageUrlController.text.startsWith('http')) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final con = _form.currentState.validate();
    if (!con) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isloading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isloading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('An error occurred!'),
                  content: Text('Something Went Wrong'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Okay'))
                  ],
                ));
      }
      setState(() {
        _isloading = false;
      });
      Navigator.of(context).pop();
      // finally {
      //   setState(() {
      //     _isloading = false;
      //   });
      //   Navigator.of(context).pop();
      // } // finally will execute if your code is successed or failed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),

              /// this is loading spinner
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key:
                    _form, // i did this to connect my form to the globalkey i created
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _map['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction
                          .next, // textInputAction: TextInputAction.next is the icon that will show in keyboard useer will press it when he finish typing
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFoucesNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            isFavorite: _editedProduct.isFavorite,
                            id: _editedProduct.id,
                            title: value,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Provide a Value.';
                        }
                        return null; // return null that's means no error
                      },
                    ),
                    TextFormField(
                      initialValue: _map['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction
                          .next, // textInputAction: TextInputAction.next is the icon that will show in keyboard useer will press it when he finish typing
                      keyboardType: TextInputType
                          .number, // keyboard will only contain numebrs
                      focusNode: _priceFoucesNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFoucesNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value),
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                          id: _editedProduct.id,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please Enter a Price .";
                        }
                        if (double.tryParse(value) == null) {
                          // tryParse return null if value is not a number
                          return "Please Enter a Valid Number";
                        }
                        if (double.parse(value) <= 0) {
                          return "Please Enter a Numebr Greater Than Zero";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _map['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType
                          .multiline, // this willl add button to keyboard so user can add new lines
                      focusNode: _descriptionFoucesNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                            isFavorite: _editedProduct.isFavorite,
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: value,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter Description';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 Characters Long .';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter The URL')
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFoucesNode,
                              onFieldSubmitted: (_) {
                                _saveForm(); //we used annoymnos fuction here becuse flutter expects function with String parameter but our function doen't have so
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                    isFavorite: _editedProduct.isFavorite,
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    imageUrl: value);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Image URL';
                                }

                                return null;
                              }),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

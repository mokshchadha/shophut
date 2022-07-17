import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shophut/providers/product.dart';
import 'package:shophut/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  int a = 0;
  bool _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form =
      GlobalKey<FormState>(); //interact with state behind the form widget

  var _editedProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments;
      if (productId != null) {
        print(productId as String);
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId as String);

        print(_editedProduct.imageUrl);

        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };

        _imageUrlController.text = _editedProduct.imageUrl.toString();
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() {
    _form.currentState!.validate();
    _form.currentState!.save();
    if (_editedProduct.id == '') {
      Provider.of<Products>(
        context,
        listen: false,
      ).addProduct(_editedProduct);
    } else {
      Provider.of<Products>(
        context,
        listen: false,
      ).editProduct(_editedProduct.id, _editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _form,
          child: ListView(children: [
            TextFormField(
              initialValue: _initValues['title'],
              validator: (value) {
                if (value!.isEmpty) return 'Please provide a value';
                return null; //it means that input is correct
              },
              decoration: InputDecoration(labelText: 'Title'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_priceFocusNode),
              onSaved: (value) {
                _editedProduct = Product(
                  id: _editedProduct.id,
                  title: value ?? '',
                  description: _editedProduct.description,
                  price: _editedProduct.price,
                  imageUrl: _editedProduct.imageUrl,
                  isFavorite: _editedProduct.isFavorite,
                );
              },
            ),
            TextFormField(
              initialValue: _initValues['price'],
              decoration: InputDecoration(labelText: 'Price'),
              validator: (value) {
                if (value!.isEmpty) return 'Please add a price';
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid Number';
                }
                if (double.parse(value) <= 0) {
                  return 'Please enter a number greater than 0';
                }
              },
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _priceFocusNode,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_descriptionFocusNode),
              onSaved: (value) {
                _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: value != null ? double.parse(value) : 0,
                    isFavorite: _editedProduct.isFavorite,
                    imageUrl: _editedProduct.imageUrl);
              },
            ),
            TextFormField(
              initialValue: _initValues['description'],
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value!.isEmpty) return 'Please enter description';
                if (value.length < 10)
                  return 'Should be more than 10 characters';
              },
              maxLines: 2,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.multiline,
              onSaved: (value) {
                _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: value ?? '',
                    price: _editedProduct.price,
                    isFavorite: _editedProduct.isFavorite,
                    imageUrl: _editedProduct.imageUrl);
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: _imageUrlController.text.isEmpty
                        ? const Text('Enter a url')
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                          )),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Image URL'),
                    ),
                    keyboardType: TextInputType.url,
                    onChanged: (_) {
                      setState(() {});
                    },
                    focusNode: _imageUrlFocusNode,
                    textInputAction: TextInputAction.done,
                    controller: _imageUrlController,
                    onFieldSubmitted: (_) {
                      _saveForm();
                    },
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}

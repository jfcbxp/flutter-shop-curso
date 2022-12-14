import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/product.dart';
import 'package:shop/model/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  bool _isLoading = false;

  @override
  void dispose() {
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.dispose();
//    _imageUrlFocus.removeListener(updateImage);
    super.dispose();
  }

  @override
  void initState() {
    //   _imageUrlFocus.addListener(updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.title;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;
        _imageUrlController.text = product.imageUrl;
      }
    }
    super.didChangeDependencies();
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    // url.toLowerCase().endsWith('.png');
    return isValidUrl;
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState?.save();
      Provider.of<ProductList>(context, listen: false)
          .saveProduct(_formData)
          .catchError((error) {
        _isLoading = false;
        return showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Ocorreu um erro'),
                  content: Text("tente novamente"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text('Ok'))
                  ],
                ));
      }).then((value) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de Produto'),
        actions: [IconButton(onPressed: _submitForm, icon: Icon(Icons.save))],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Nome'),
                        textInputAction: TextInputAction.next,
                        initialValue: _formData['name']?.toString(),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocus);
                        },
                        onSaved: (data) => _formData['name'] = data ?? '',
                        validator: (data) {
                          final _data = data ?? '';
                          if (_data.trim().isEmpty) {
                            return 'Nome ?? obrigatorio';
                          }
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Pre??o'),
                        textInputAction: TextInputAction.next,
                        initialValue: _formData['price']?.toString(),
                        focusNode: _priceFocus,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocus);
                        },
                        onSaved: (data) =>
                            _formData['price'] = double.parse(data ?? '0'),
                        validator: (data) {
                          final _price = double.tryParse(data ?? '') ?? 0;
                          if (_price <= 0.0) {
                            return 'Pre??o invalido';
                          }
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Descri????o'),
                        textInputAction: TextInputAction.next,
                        initialValue: _formData['description']?.toString(),
                        focusNode: _descriptionFocus,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_imageUrlFocus);
                        },
                        onSaved: (data) =>
                            _formData['description'] = data ?? '',
                        validator: (data) {
                          final _data = data ?? '';
                          if (_data.trim().isEmpty) {
                            return 'Descri????o ?? obrigatoria';
                          }
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Url da Imagem'),
                              textInputAction: TextInputAction.done,
                              focusNode: _imageUrlFocus,
                              keyboardType: TextInputType.url,
                              controller: _imageUrlController,
                              onFieldSubmitted: (_) => _submitForm(),
                              onChanged: (value) => updateImage(),
                              onSaved: (data) =>
                                  _formData['imageUrl'] = data ?? '',
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(
                              top: 10,
                              left: 10,
                            ),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            alignment: Alignment.center,
                            child: _imageUrlController.text.isEmpty
                                ? Text('Informe a Url')
                                : Container(
                                    width: 100,
                                    height: 100,
                                    child: FittedBox(
                                      child: Image.network(
                                          _imageUrlController.text),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/category_dto.dart';
import 'package:racoon_tech_panel/src/Model/product_dto.dart';
import 'package:racoon_tech_panel/src/View/components/searchable_menu.dart';
import 'package:racoon_tech_panel/src/View/helpers.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/categories_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/CategoryProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ProductProvider.dart';
import 'package:widget_zoom/widget_zoom.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {

  final _formKey = GlobalKey<FormState>();
  final _productController = Produto();
  int formStep = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchCategories(context);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProdutoProvider>(context, listen: true);
    final categoryModel = Provider.of<CategoryProvider>(context, listen: true);

    _newSale() async {
      productModel.setIsReloading(true);
      await Future.delayed(const Duration(milliseconds: 1500));
      productModel.setIsLoading(false);
      productModel.setImages([]);
      context.pop();
    }

    Future<void> _pickImages(newState) async {
      // Allow picking multiple image files
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null) {
        productModel.setImages(
          result.paths
          .where((path) => path != null)
          .map((path) => File(path!))
          .toList()
        );
        newState(() {
          
          // _selectedImages = result.paths
              // .where((path) => path != null)
              // .map((path) => File(path!))
              // .toList();
        });

    }
  }


    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          Form(
            key: _formKey,
            child: Align(
              alignment: Alignment.topLeft,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Helpers.rowOrWrap(
                    wrap: true,
                    children: [
                    Visibility(
                      visible: formStep == 1,
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Fotos do produto", style: TextStyle(fontWeight: FontWeight.bold)),
                          
                          Column(
                          children: [
                            Visibility(
                              visible: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: List.generate(
                                            (productModel.selectedImages?.length ?? 0),
                                            (int index) => WidgetZoom(
                                              heroAnimationTag: 'tag',
                                              zoomWidget: Image.file(productModel.selectedImages![index], width: 100, height: 100)
                                            ),
                                          ),
                                      ),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(onPressed: () {
                            _pickImages(setState);
                            setState(() {});
                          }, child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 10,
                            children: [
                              Icon(Icons.photo_library),
                              Text("Selecionar fotos"),
                            ],
                          )),
                          Visibility(visible: (productModel.selectedImages?.length ?? 0) != 0, child: Text("Fotos selecionadas: ${productModel.selectedImages?.length}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))  ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(onPressed: () {
                                formStep = 2;
                                setState(() {});
                              }, child: Icon(Icons.arrow_forward_ios, size: 15)
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: formStep == 2,
                      child: Column(
                        spacing: 10,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Nome do produto"
                            )
                          ),
                          TextFormField(
                            readOnly: true,
                            controller: TextEditingController(text: _productController.category?.name),
                            validator: (value) {
                            if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Categoria",
                              suffixIcon: Icon(Icons.expand_more)
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SearchableMenu(
                                    model: Provider.of<CategoryProvider>(context, listen: true), 
                                    items: categoryModel.categories,
                                    selectCb: (Category category) {
                                        _productController.category = category;
                                        setState(() {});
                                    }, 
                                    fetchCb: (String? searchTerm) async {
                                      await fetchCategories(context);
                                    }, 
                                  );
                                }
                              );
                            }
                          ),
                          Row(
                            mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(onPressed: () {
                                  formStep = 1;
                                  setState(() {});
                                }, child: Icon(Icons.arrow_back_ios_new, size: 15)
                              ),
                              
                              ElevatedButton(onPressed: () {
                                  formStep = 2;
                                  setState(() {});
                                }, child: Text("Publicar")
                              ),
                            ],
                          ),
                        ],
                      )
                    ),
                    ]
                  );
                }
              ),
            ),
          )
        ]
      ),
    );
  }
}
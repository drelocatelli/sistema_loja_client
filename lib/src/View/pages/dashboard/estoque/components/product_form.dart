import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/category_dto.dart' as category_dto;
import 'package:racoon_tech_panel/src/Model/product_controller.dart';
import 'package:racoon_tech_panel/src/Model/product_dto.dart';
import 'package:racoon_tech_panel/src/View/components/searchable_menu.dart';
import 'package:racoon_tech_panel/src/View/helpers.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/categories_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/CategoryProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ProductProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/ProdutosRepository.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/SaleRepository.dart';
import 'package:widget_zoom/widget_zoom.dart';

import '../../../../../Model/sales_controller_dto.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {

  final _formKey = GlobalKey<FormState>();
  final _productController = Produto();
  bool _isUploadingImages = false;
  int formStep = 1;
  bool _isSubmitting = false;

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

    ProductController? _formController = ProductController();

    _newSale() async {
      productModel.setIsReloading(true);

      // send request
      final request = await ProdutosRepository.create(_formController);

      // upload photos if request is ok
      if(request.status == 200) {
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: const Text('Sucesso'),
          );
        });

      }


      await Future.delayed(const Duration(milliseconds: 1500));
      productModel.setIsLoading(false);
      productModel.setImages([]);
      context.pop();
    }

    Future<void> _pickImages(newState) async {
      newState(() {
        _isUploadingImages = true;
      });

      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      newState(() {
        _isUploadingImages = false;
      });

      if (result != null) {
        productModel.imagesBytes.clear();
        
        for(PlatformFile file in result.files) {
          if(file.bytes != null) {
            productModel.imagesBytes.add(file.bytes!);
          }
        }
    }
  }

  Future<void> _pickImagesMobile(newState) async {
      newState(() {
          _isUploadingImages = true;
        });

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
          _isUploadingImages = false;
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
                                  Scrollbar(
                                    thumbVisibility: true,
                                    interactive: true,
                                    child: ScrollConfiguration(
                                      behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                                        PointerDeviceKind.touch, // Enable touch gestures
                                        PointerDeviceKind.mouse, // Enable mouse gestures (optional)
                                      },),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: List.generate(
                                                ((kIsWeb) ? productModel.imagesBytes.length : productModel.selectedImages!.length),
                                                (int index) {
                                                    dynamic imageUrl = (kIsWeb) 
                                                      ? productModel.imagesBytes[index] 
                                                      : productModel.selectedImages![index];

                                                    Widget imageWidget = (kIsWeb) 
                                                      ? Image.memory(imageUrl, fit: BoxFit.cover, width: 100, height: 100) 
                                                      : Image.file(imageUrl, width: 100, height: 100);
                                                  
                                                    return MouseRegion(
                                                      cursor: SystemMouseCursors.click,
                                                      child: WidgetZoom(
                                                        heroAnimationTag: 'tag',
                                                        zoomWidget: imageWidget
                                                      ),
                                                    );
                                                }
                                              ),
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
                          if(!kIsWeb) {
                            _pickImagesMobile(setState);
                          } else {
                            _pickImages(setState);

                          }
                            setState(() {});
                          }, child: Visibility(
                            visible: !_isUploadingImages,
                            replacement: SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1,)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 10,
                              children: [
                                Icon(Icons.photo_library),
                                Text("Selecionar fotos"),
                              ],
                            ),
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
                            ),
                            controller: _formController.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }
                              return null;
                            }
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: TextFormField(
                              enableInteractiveSelection: true,
                              readOnly: true,
                              controller: TextEditingController(text: _formController.category?.name),
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
                                      selectCb: (category_dto.Category category) {
                                          _formController.category = category;
                                          setState(() {});
                                      }, 
                                      fetchCb: (String? searchTerm) async {
                                        await fetchCategories(context, searchTerm: searchTerm);
                                      }, 
                                    );
                                  }
                                );
                              }
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Preço",
                              prefixText: 'R\$ '
                            ),
                            keyboardType: TextInputType.number,
                            controller: _formController.price,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }

                              if (double.tryParse(value) == null) {
                                return 'Precisa ser valor numérico';
                              }
                              return null;
                            }
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Quantidade",
                            ),
                            keyboardType: TextInputType.number,
                            controller: _formController.quantity,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }

                              if(value == '0') {
                                return 'Quantidade deve ser maior que 0';
                              }

                              if (int.tryParse(value) == null) {
                                return 'Precisa ser valor numérico';
                              }

                              return null;
                              
                            }
                          ),
                          Row(
                            children: [
                              StatefulBuilder(
                                builder: (context, setState) {
                                  return Checkbox(
                                    value: (_productController.isPublished ?? false),
                                    onChanged: (value) {
                                      _productController.isPublished = value;
                                      setState((){});
                                    },
                                  );
                                }
                              ),
                              GestureDetector(onTap: () {
                                _productController.isPublished = !(_productController.isPublished ?? false);
                                setState(() {});
                              }, child: Text("Público"))
                            ],
                          ),
                          TextFormField(
                            maxLines: null,
                            minLines: 3,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              labelText: "Descrição"
                            ),
                            controller: _formController.description,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }
                              return null;
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
                              
                              StatefulBuilder(
                                builder: (context, setState) {
                                  return ElevatedButton(onPressed: () {
                                      formStep = 2;
                                      setState(() async {
                                        if (_formKey.currentState?.validate() ?? false) {
                                          setState(() {
                                            _isSubmitting = true;
                                          });
                                          await _newSale();

                                          setState(() {
                                            _isSubmitting = false;
                                          });
                                        }
                                      });
                                    }, child: Text(_isSubmitting ? "Publicando..."  : "Publicar")
                                  );
                                }
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
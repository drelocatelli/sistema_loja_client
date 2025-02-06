import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/produtos_response_dto%20copy.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/View/layout/main_layout.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/estoque/components/product_table.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/estoque/components/product_title.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/produtos_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ProductProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/ProdutosRepository.dart';
import 'package:racoon_tech_panel/src/ViewModel/shared/SharedTheme.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _VenddasState();
}

class _VenddasState extends State<ProductPage> {

final NumberPaginatorController _controller = NumberPaginatorController();

   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchData();
    });
    
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future fetchData({int? page = 1, String? searchTerm}) async {
    final model = Provider.of<ProdutoProvider>(context, listen: false);
    
    model.setIsLoading(true);

    ResponseDTO<ProdutosResponseDTO> productsList = await ProdutosRepository.get(pageNum: page, searchTerm: searchTerm);
    final newProducts = productsList.data?.produtos ?? [];

    if(productsList.status != 200) {
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            title: const Text("Ocorreu um erro"),
            content: Text(productsList.message ?? 'Ocorreu um erro inesperado!', style: Theme.of(context).textTheme.bodyMedium),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
                child: const Text('Fechar')
              ),
            ],
          );  
        }
      );
    }

    model.setTotalPages(productsList.data?.pagination?.totalPages ?? 1);
    model.setProdutos(newProducts);
    model.setIsLoading(false);

  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ProdutoProvider>(
      builder: (context, model, child) {
        return MainLayout(
          // floatingActionButton: Container(
          //   color: Colors.white,
          //   padding: EdgeInsets.symmetric(horizontal: SharedTheme.isLargeScreen(context) ? 50 : 20, vertical: 8.0),
          //   child: Visibility(
          //     visible: model.totalPages > 1,
          //     child: NumberPaginator(
                
          //       config: NumberPaginatorUIConfig(
          //         buttonSelectedBackgroundColor: SharedTheme.secondaryColor,
          //       ),
          //       numberPages: model.totalPages,
          //       initialPage: model.currentIdx,
          //       controller: _controller,
          //       onPageChange: (int index) async {
          //         model.setCurrentIdx(index);
          //         model.setCurrentPage(index + 1);
        
          //         await Future.delayed(const Duration(seconds: 1));
          //         await fetchData(page: model.currentPage);
          //       },
          //     )
          //   )
          // ),
          child: SelectionArea(
            child: Column(
              children: [
                ProductTitle(),
                ProductTable(),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: SharedTheme.isLargeScreen(context) ? 50 : 20, vertical: 8.0),
                  child: Visibility(
                    visible: model.totalPages > 1,
                    child: NumberPaginator(
                      
                      config: NumberPaginatorUIConfig(
                        buttonSelectedBackgroundColor: SharedTheme.secondaryColor,
                      ),
                      numberPages: model.totalPages,
                      initialPage: model.currentIdx,
                      controller: _controller,
                      onPageChange: (int index) async {
                        model.setCurrentIdx(index);
                        model.setCurrentPage(index + 1);
              
                        await Future.delayed(const Duration(seconds: 1));
                        await fetchData(page: model.currentPage);
                      },
                    )
                  )
                ),
              ],
            )
          ),
        );
      }
    );
  }
}


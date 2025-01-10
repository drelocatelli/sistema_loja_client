import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/produtos_response_dto%20copy.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/View/layout/main_layout.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/estoque/components/product_table.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/estoque/components/product_title.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ProductProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/ProdutosRepository.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _VenddasState();
}

class _VenddasState extends State<ProductPage> {

final NumberPaginatorController _controller = NumberPaginatorController();
  int _totalPages = 1;
  int currentIdx = 0;
  int currentPage = 1;

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
    ResponseDTO<ProdutosResponseDTO> productsList = await ProdutosRepository.get(page: page, searchTerm: searchTerm);
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

    setState(() {
      _totalPages = productsList.data?.pagination?.totalPages ?? 1;
    });

    Logger().i(_totalPages);

    model.setProdutos(newProducts);
    model.setIsLoading(false);

  }
  
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SelectionArea(
        child: Column(
          children: [
            ProductTitle(),
            ProductTable(),
          ],
        )
      ),
    );
  }
}


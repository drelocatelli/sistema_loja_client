import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:racoon_tech_panel/src/Model/cliente_dto.dart';
import 'package:racoon_tech_panel/src/Model/clientes_response_dto.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/View/layout/main_layout.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/clients/components/clients_table.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/ClientRepository.dart';
import 'package:racoon_tech_panel/src/ViewModel/shared/SharedTheme.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  List<Cliente> clientes = [];
  bool _isLoading = true;
  bool _isReloading = false;
  final NumberPaginatorController _controller = NumberPaginatorController();
  int _totalPages = 1;

  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final newClientes = await fetchData();
      setState(() {
        _isLoading = false;
        clientes = newClientes;
      });
    });
    
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<List<Cliente>> fetchData({int? page = 1, String? searchTerm}) async {
    ResponseDTO<ClientesResponseDTO> clientesList = await ClientRepository.get(page: page, searchTerm: searchTerm);

    final newClientes = clientesList.data?.clientes ?? [];

    if(clientesList.status != 200) {
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            title: const Text("Ocorreu um erro"),
            content: Text(clientesList.message ?? 'Ocorreu um erro inesperado!', style: Theme.of(context).textTheme.bodyMedium),
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
      _totalPages = clientesList.data?.pagination?.totalPages ?? 1;
    });

    debugPrint("Clientes fetched: ${newClientes.length}");

    return newClientes;
  }

  @override
  Widget build(BuildContext context) {

  final maxWidth = MediaQuery.of(context).size.width;  
  int currentIdx = 0;
  int currentPage = 1;

    return MainLayout(
      isLoading: _isLoading,
      floatingActionButton: Container(
        color: Colors.white,
        padding:  EdgeInsets.symmetric(horizontal: SharedTheme.isLargeScreen(context) ? 50 : 20, vertical: 8.0),
        child: Visibility(
          visible: _totalPages > 1,
          child: NumberPaginator(
            config: NumberPaginatorUIConfig(
              buttonSelectedBackgroundColor: SharedTheme.secondaryColor,
            ),
            numberPages: _totalPages,
            initialPage: currentIdx,
            controller: _controller,
            onPageChange: (int index) async {
              setState(() {
                currentIdx = index;
                currentPage = index + 1;
              });
              setState(() { _isReloading = true; });
              await Future.delayed(const Duration(seconds: 1));
              final newClientes = await fetchData(page: currentPage);
              setState(() { 
                _isReloading = false; 
                clientes = newClientes;
              });
            },
          ),
        ),
      ),
      child: SelectionArea(
        child: SizedBox(
          width: maxWidth,
          child: clientsTable(clientes, maxWidth, isReloading: _isReloading, refreshFn: () async {
            setState(() { _isReloading = true; });
            final newClientes = await fetchData(page: 1);
            setState(() { 
              _isReloading = false; 
              clientes = newClientes;
            });
          },
          search: _pesquisa(maxWidth, (String searchTerm) async {
            final newClientes = await fetchData(page: 1, searchTerm: searchTerm);
            setState(() { 
              currentIdx = 0;
              currentPage = 1;
              clientes = newClientes;
             });
          }),
          )
        ),
      ),
    );
  }
}

Widget _pesquisa(double maxWidth, Function fetchCb) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: SizedBox(
      width: maxWidth >= 800 ? 400 : null,
      child: TextFormField(
        autofocus: true,
        onFieldSubmitted: (String value) {
          fetchCb(value);
        },
       decoration: const InputDecoration(
          hintText: 'Procurar por nome...',
          border: OutlineInputBorder(), 
          suffixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          isDense: true
        ),
      ),
    ),
  );
}



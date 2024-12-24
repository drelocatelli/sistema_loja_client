import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:racoon_tech_panel/src/dto/cliente_dto.dart';
import 'package:racoon_tech_panel/src/dto/clientes_response_dto.dart';
import 'package:racoon_tech_panel/src/dto/response_dto.dart';
import 'package:racoon_tech_panel/src/layout/main_layout.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/clients/components/clients_table.dart';
import 'package:racoon_tech_panel/src/repository/ClientRepository.dart';
import 'package:racoon_tech_panel/src/shared/SharedTheme.dart';

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
            title: Text("Ocorreu um erro"),
            content: Text(clientesList.message ?? 'Ocorreu um erro inesperado!', style: Theme.of(context).textTheme.bodyMedium),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
                child: Text('Fechar')
              ),
            ],
          );  
        }
      );
    }


    debugPrint("Clientes fetched: ${newClientes.length}");

    return newClientes;
  }

  @override
  Widget build(BuildContext context) {

  final maxWidth = MediaQuery.of(context).size.width;  
  int _currentIdx = 0;
  int _currentPage = 1;

    return MainLayout(
      isLoading: _isLoading,
      floatingActionButton: Container(
        color: Colors.white,
        padding:  EdgeInsets.symmetric(horizontal: SharedTheme.isLargeScreen(context) ? 50 : 20, vertical: 8.0),
        child: NumberPaginator(
          config: NumberPaginatorUIConfig(
            buttonSelectedBackgroundColor: SharedTheme.secondaryColor,
          ),
          numberPages: 10,
          initialPage: _currentIdx,
          controller: _controller,
          onPageChange: (int index) async {
            setState(() {
              _currentIdx = index;
              _currentPage = index + 1;
            });
            setState(() { _isReloading = true; });
            await Future.delayed(const Duration(seconds: 1));
            final newClientes = await fetchData(page: _currentPage);
            setState(() { 
              _isReloading = false; 
              clientes = newClientes;
            });
          },
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
              _currentIdx = 0;
              _currentPage = 1;
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



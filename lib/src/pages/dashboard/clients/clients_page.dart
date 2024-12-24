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
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchData();
      setState(() {
        _isLoading = false;
      });
    });
    
  }

  Future<void> fetchData({int? page}) async {
    ResponseDTO<ClientesResponseDTO> clientesList = await ClientRepository.get(page: page);
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
    setState(() {
      clientes = clientesList.data?.clientes ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {

  final maxWidth = MediaQuery.of(context).size.width;  
  final NumberPaginatorController _controller = NumberPaginatorController();
  int _currentIdx = 0;
  int _currentPage = 1;
  bool _isReloading = false;

    return MainLayout(
      isLoading: _isLoading,
      floatingActionButton: Padding(
        padding:  EdgeInsets.symmetric(horizontal: SharedTheme.isLargeScreen(context) ? 50 : 20, vertical: 8.0),
        child: NumberPaginator(
          config: NumberPaginatorUIConfig(
            buttonSelectedBackgroundColor: SharedTheme.secondaryColor,
          ),
          numberPages: 10,
          initialPage: _currentIdx,
          controller: _controller,
          onPageChange: (int index) async {
            setState(() async {
              _currentIdx = index;
              _currentPage = index + 1;
              await fetchData(page: _currentPage);
            });
          },
        ),
      ),
      child: SelectionArea(
        child: SizedBox(
          width: maxWidth,
          child: clientsTable(clientes, maxWidth, isReloading: _isReloading, refreshFn: () async {
            setState(() { _isReloading = true; });
            await Future.delayed(const Duration(seconds: 1));
            await fetchData(page: 1);
            setState(() { _isReloading = false; });
          })
        ),
      ),
    );
  }
}




import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:racoon_tech_panel/src/dto/cliente_dto.dart';
import 'package:racoon_tech_panel/src/dto/response_dto.dart';
import 'package:racoon_tech_panel/src/helpers.dart';
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

  Future<void> fetchData() async {
    ResponseDTO<List<Cliente>> clientesList = await ClientRepository.getClients();
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
      clientes = clientesList.data ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {

  final maxWidth = MediaQuery.of(context).size.width;  

    return MainLayout(
      isLoading: _isLoading,
      child: SelectionArea(
        child: SizedBox(
          width: maxWidth,
          child: clientsTable(clientes, maxWidth, isReloading: _isReloading, refreshFn: () async {
            setState(() { _isReloading = true; });
            await Future.delayed(const Duration(seconds: 1));
            await fetchData();
            setState(() { _isReloading = false; });
          }),
        ),
      ),
    );
  }
}




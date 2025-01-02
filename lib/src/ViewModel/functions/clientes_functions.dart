import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/clientes_response_dto.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ClientProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/ClientRepository.dart';

Future fetchClientes(BuildContext context, {bool onlyOnce = false, String? searchTerm, int? page = 1}) async {
  final model = Provider.of<ClientProvider>(context, listen: false);

  if(onlyOnce && model.clientes.isNotEmpty) {
    return;
  }

  model.setIsLoading(true);
  ResponseDTO<ClientesResponseDTO> clientesList = await ClientRepository.get(page: page, searchTerm: searchTerm);

  if(clientesList.status == 200) {
    model.setClientes(clientesList.data?.clientes ?? []);
  }

  Logger().i('Clientes loaded ${model.clientes.length}');

  model.setIsLoading(false);
}
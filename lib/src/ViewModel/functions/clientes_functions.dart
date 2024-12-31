import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/clientes_response_dto.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ClientProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/ClientRepository.dart';

Future fetchClientes(BuildContext context) async {
  final model = Provider.of<ClientProvider>(context, listen: false);
  model.setIsLoading(true);
  ResponseDTO<ClientesResponseDTO> clientesList = await ClientRepository.get();

  if(clientesList.status == 200) {
    model.setClientes(clientesList.data?.clientes ?? []);
  }

  model.setIsLoading(false);
}
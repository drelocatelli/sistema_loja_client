import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/dto/cliente_dto.dart';
import 'package:racoon_tech_panel/src/shared/SharedTheme.dart';

clientsDetails(BuildContext context, Cliente cliente) {
  int columns = SharedTheme.isLargeScreen(context) ?  3 : 2;
  
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Ficha de ${cliente.name}"),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: GridView.count(
            childAspectRatio: 1 /.5,
            shrinkWrap: true,
            crossAxisCount: columns, // Quantidade de colunas
            crossAxisSpacing: 8.0, // Espaçamento horizontal entre colunas
            mainAxisSpacing: 8.0, // Espaçamento vertical entre linhas
            children: _userDetailsGrid(context, cliente),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Fechar"),
          ),
        ],
      );
    },
  );
}


List<Widget> _userDetailsGrid(BuildContext context, Cliente cliente) {
  return [
    _detailTile(context, "Nome completo:", cliente.name),
    _detailTile(context, "E-mail:", cliente.email),
    if (cliente.rg != null) _detailTile(context, "RG:", cliente.rg!),
    if (cliente.cpf != null) _detailTile(context, "CPF:", cliente.cpf!),
    if (cliente.phone != null) _detailTile(context, "Telefone:", cliente.phone!),
    if (cliente.address != null) _detailTile(context, "Endereço:", cliente.address!),
    if (cliente.cep != null) _detailTile(context, "CEP:", cliente.cep!),
    if (cliente.city != null) _detailTile(context, "Cidade:", cliente.city!),
    _detailTile(context, "Último cadastro:", cliente.createdAt.toString()),
  ];
}

Widget _detailTile(BuildContext context, String label, String value) {
  return SelectionArea(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: SharedTheme.isLargeScreen(context) ? Theme.of(context).textTheme.titleLarge : Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 4),
        Text(value, style: SharedTheme.isLargeScreen(context) ? Theme.of(context).textTheme.labelLarge : Theme.of(context).textTheme.labelSmall),
      ],
    ),
  );
}

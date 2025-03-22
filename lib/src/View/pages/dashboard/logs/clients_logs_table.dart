import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/clientes_response_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ClientProvider.dart';

import 'fetch/fetch_logs.dart';

class ClientsLogsTable extends StatefulWidget {
  ClientsLogsTable({super.key, int this.pageSize = 1});

  int? pageSize;

  @override
  State<ClientsLogsTable> createState() => _ClientsLogsTableState();
}

class _ClientsLogsTableState extends State<ClientsLogsTable> {
  late Future<ClientesResponseDTO?> _future;
  late ClientProvider? model;
  int pageNum = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _future = fetchClients(context, pageNum: pageNum);
      model = Provider.of<ClientProvider>(context, listen: false);
      setState(() {});
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
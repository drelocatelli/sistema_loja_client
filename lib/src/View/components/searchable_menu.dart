import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/debouncer_function.dart';

enum ProviderType {
  colaborator,
  client,
  // Adicione outros tipos conforme necessário
}

class SearchableMenu<T> extends StatefulWidget {
  final Function selectCb;
  final Function fetchCb;
  final T model;
  final _debouncer = Debouncer(milliseconds: 500);
  final List<dynamic> items;
  
  SearchableMenu({
    required this.selectCb,
    required this.model,
    required this.fetchCb,
    required this.items
  });

  @override
  State<SearchableMenu> createState() => _SearchableMenuState();
}

class _SearchableMenuState extends State<SearchableMenu> {
  // Recebe o tipo do model

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.model.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Seleciona o model correto com base no tipo passado
    dynamic model = widget.model;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Pesquisar',
                      hintText: 'Buscar por nome',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String? value) async {
                      model.setIsLoading(true);
                      widget._debouncer.run(() async {
                       await widget.fetchCb(value);
                        model.setIsLoading(false);
                      });
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 300,
                  child: Material(
                    child: Scrollbar(
                      trackVisibility: true,
                      thumbVisibility: true,
                      child: Visibility(
                        visible: !model.isLoading,
                        replacement: const Center(child: Text("Buscando dados...")),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.items.length, // Dependendo do Provider, você terá uma lista diferente
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text("${widget.items[index].name}", style: Theme.of(context).textTheme.bodyLarge),
                              onTap: () {
                                widget.selectCb(widget.items[index]);
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/View/components/pulse_components.dart';
import 'package:racoon_tech_panel/src/View/layout/functions/assign_colaborator.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ColaboratorProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/CheckVersionRepository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';


class LoadingScreen extends StatefulWidget {
  LoadingScreen({super.key, required this.child, this.isLoading});

  bool? isLoading;
  Widget child;
  bool _isLoadingPassive = true;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(true);
  bool _newVersion = false;

  @override
  initState() {
    super.initState();
    (() async {
      await _checkNewVersion();
    })();
    Future.delayed(const Duration(milliseconds: 800), () async {
      await assignUserToColaboratorDialog(context);

      if(!kIsWeb) {
        await _checkVersion();
      }
      setState(() {
        widget._isLoadingPassive = false;
      });

    });
  }

  _checkNewVersion() {
    if(kIsWeb) {
      setState(() {
        _newVersion = false;
      });
    }
    widget.isLoading ??= true;
    setState(() {});
  }

  _checkVersion() async {
    bool? hasNewVersion = await CheckVersionRepository.hasNewVersion();
    debugPrint('Has new version: $hasNewVersion');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(hasNewVersion == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Erro ao verificar versão'),
        ));
      } else {
        _newVersion = hasNewVersion;
        setState(() {});
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Visibility(
        visible: _newVersion && !kIsWeb,
        replacement: Visibility(
          visible: widget.isLoading != null && widget.isLoading! && widget._isLoadingPassive,
          replacement: Consumer<ColaboratorProvider>(
            builder: (context, colaboratorModel, child) {
              return Visibility(
                visible: colaboratorModel.hasColaboratorAssigned,
                child: widget.child
              );
            }
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PulseAnimation(
                child: Image.asset("assets/img/logo.png", width: 200)
              ),
            ],
          ),
        ),
        child: _versionObsolete(context),
      ),
    );
  }
}

Widget _versionObsolete(BuildContext context) {
  return Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Nova versão disponível!", style: Theme.of(context).textTheme.headlineSmall),
              const Gap(30),
              Image.asset("assets/img/logo.png", width: 150),
              const Gap(30),
              Text("É necessário atualizar para a nova versão para continuar", style: Theme.of(context).textTheme.bodyLarge),
              const Gap(30),
              OutlinedButton(
                onPressed: () async {
                  Uri url = Uri.parse(dotenv.env['API_DOWNLOAD_APP']!);
                  await launchUrl(url);
                }, 
                child: const Text("Clique aqui pra atualizar")
              ),
              const Gap(20),
              Text("Versão atual: ${dotenv.env['VERSION']}", style: Theme.of(context).textTheme.bodySmall),
            ],
          )
        );
}
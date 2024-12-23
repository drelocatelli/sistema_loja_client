import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:racoon_tech_panel/src/components/pulse_components.dart';
import 'package:racoon_tech_panel/src/repository/CheckVersionRepository.dart';
import 'package:racoon_tech_panel/src/repository/LoginRepository.dart';
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
  ValueNotifier<bool> _isLoading = ValueNotifier(true);
  bool _newVersion = false;

  @override
  initState() {
    super.initState();
    (() async {
      await _checkNewVersion();
    })();
    Future.delayed(const Duration(milliseconds: 800), () async {
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
    if(widget.isLoading == null) {
      widget.isLoading = true;
    }
    setState(() {});
  }

  _checkVersion() async {
    bool? _hasNewVersion = await CheckVersionRepository.hasNewVersion();
    debugPrint('Has new version: $_hasNewVersion');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(_hasNewVersion == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Erro ao verificar versão'),
        ));
      } else {
        _newVersion = _hasNewVersion;
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
        child: _versionObsolete(context),
        replacement: Visibility(
          visible: widget.isLoading != null && widget.isLoading! && widget._isLoadingPassive,
          replacement: widget.child,
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
              Gap(30),
              Image.asset("assets/img/logo.png", width: 150),
              Gap(30),
              Text("É necessário atualizar para a nova versão para continuar", style: Theme.of(context).textTheme.bodyLarge),
              Gap(30),
              OutlinedButton(
                onPressed: () async {
                  Uri _url = Uri.parse(dotenv.env['API_DOWNLOAD_APP']!);
                  await launchUrl(_url);
                }, 
                child: Text("Clique aqui pra atualizar")
              ),
              Gap(20),
              Text("Versão atual: ${dotenv.env['VERSION']}", style: Theme.of(context).textTheme.bodySmall),
            ],
          )
        );
}
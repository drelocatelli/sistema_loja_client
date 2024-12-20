import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';
import 'package:racoon_tech_panel/src/components/pulse_components.dart';
import 'package:racoon_tech_panel/src/repository/CheckVersionRepository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({super.key, required this.child});

  Widget child;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isLoading = true;
  bool _newVersion = true;

  @override
  initState() {
    super.initState();
    if(kIsWeb) {
      setState(() {
        _newVersion = false;
      });
    }
    Future.delayed(const Duration(milliseconds: 800), () {
      if(!kIsWeb) {
        _checkVersion();
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  _checkVersion() async {
    
    bool? _hasNewVersion = await CheckVersionRepository.hasNewVersion();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(_hasNewVersion == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Erro ao verificar versão'),
        ));
      } else if(_hasNewVersion) {
        setState(() {
          _newVersion = true;
        });
      }
      if(_hasNewVersion != null && !_hasNewVersion) {
        setState(() {
          _newVersion = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Visibility(
        visible: _newVersion,
        child: Container(
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
        ),
        replacement: Visibility(
          visible: _isLoading,
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


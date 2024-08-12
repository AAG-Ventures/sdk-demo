import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:metaone_wallet_sdk/metaone_wallet_sdk.dart';
import 'package:metaone_wallet_sdk_example/change_theme_page.dart';
import 'package:metaone_wallet_sdk_example/send_transaction_page.dart';
import 'package:metaone_wallet_sdk_example/sso_login_page.dart';
import 'package:metaone_wallet_sdk_example/utils.dart';
import 'package:metaone_wallet_sdk_example/wallets_page.dart';
import 'package:metaone_wallet_sdk_example/widgets.dart';
import 'package:provider/provider.dart';

import 'theme_provider.dart';

final _sdkConfig = MetaoneConfig(
    realm: dotenv.env['SDK_REALM'].toString(),
    environment: dotenv.env['SDK_ENVIRONMENT'].toString(),
    clientReference: dotenv.env['SDK_API_CLIENT_REFERENCE'].toString(),
    url: dotenv.env['SDK_CONFIG_URL'].toString(),
    sdkApiKeyPhrase: dotenv.env['SDK_API_KEYPHRASE'].toString(),
    version: dotenv.env['VERSION'].toString());

void main() async {
  await dotenv.load();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(ThemeData.light()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: themeProvider.themeData,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  bool _isAuthorized = false;

  Future<void> _initializeSDK() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await initialize(_sdkConfig);

      // Only needed on multiplatform configuration
      await setPrefix('_flutter');
      void printWalletData(Map<String, dynamic> walletData) {
        print('Wallet data: $walletData');
      }
      await NativeWalletListener.startListening(printWalletData);

      final sessionStatus = await getSessionActivityStatus();
      setState(() {
        _isAuthorized = sessionStatus.isActive;
        _isLoading = false;
      });
      if (!mounted) return;
      Utils.showSuccessSnackBar(context, message: 'SDK initialized.');
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.showErrorSnackBar(context, message: '$error');
    }
  }

  Future<void> _onLogInTapped() async {
    try {
      await Navigator.of(context).push(SSOLoginPage.route());
      setState(() {
        _isLoading = true;
      });
      final sessionStatus = await getSessionActivityStatus();
      setState(() {
        _isAuthorized = sessionStatus.isActive;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.showErrorSnackBar(context, message: '$error');
    }
  }

  Future<void> _onRefreshSessionTapped() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await refreshSession();
      final sessionStatus = await getSessionActivityStatus();
      setState(() {
        _isAuthorized = sessionStatus.isActive;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.showErrorSnackBar(context, message: '$error');
    }
  }

  Future<void> _onLogOutTapped() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await logOut();
      final sessionStatus = await getSessionActivityStatus();
      setState(() {
        _isAuthorized = sessionStatus.isActive;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.showErrorSnackBar(context, message: '$error');
    }
  }

  Future<void> _onOpenWalletTapped() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await openWallet();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.showErrorSnackBar(context, message: '$error');
    }
  }

    Future<void> _onOpenBrowserTapped() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await openBrowser();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.showErrorSnackBar(context, message: '$error');
    }
  }

  Future<void> _getTokenExpirationDate() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final tokenExpirationDate = await getExpireAt();
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      Utils.showSuccessSnackBar(
        context,
        message: 'Token expiration date: $tokenExpirationDate',
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.showErrorSnackBar(context, message: '$error');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeSDK();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MetaoneWalletSdk Example')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_isAuthorized)
          _AuthorizedView(
            onOpenWalletTapped: _onOpenWalletTapped,
            onOpenBrowserTapped: _onOpenBrowserTapped,
            onGetTokenExpirationDateTapped: _getTokenExpirationDate,
            onRefreshSessionTapped: _onRefreshSessionTapped,
            onLogOutTapped: _onLogOutTapped,
          )
        else
          _UnauthorizedView(onLogInTapped: _onLogInTapped),
      ],
    );
  }
}

class _UnauthorizedView extends StatelessWidget {
  const _UnauthorizedView({
    required this.onLogInTapped,
  });

  final void Function() onLogInTapped;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        onPressed: onLogInTapped,
        text: 'SSO Login',
      ),
    );
  }
}

class _AuthorizedView extends StatelessWidget {
  const _AuthorizedView({
    required this.onOpenWalletTapped,
    required this.onOpenBrowserTapped,
    required this.onGetTokenExpirationDateTapped,
    required this.onRefreshSessionTapped,
    required this.onLogOutTapped,
  });

  final void Function() onOpenWalletTapped;
  final void Function() onOpenBrowserTapped;
  final void Function() onGetTokenExpirationDateTapped;
  final void Function() onRefreshSessionTapped;
  final void Function() onLogOutTapped;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onOpenWalletTapped,
            child: const Text('Open wallet'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onOpenBrowserTapped,
            child: const Text('Open browser'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () =>
                Navigator.of(context).push(ChangeThemePage.route()),
            child: const Text('Change Theme'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async => {
              if (await isSignatureSet())
                {Navigator.of(context).push(SendTransactionPage.route())}
              else
                {
                  Utils.showErrorSnackBar(context,
                      message: "User needs to set up their signature first.")
                }
            },
            child: const Text('Send transaction'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onGetTokenExpirationDateTapped,
            child: const Text('Get token expiration date'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onRefreshSessionTapped,
            child: const Text('Refresh session'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).push(MyWalletsPage.route()),
            child: const Text('My wallets'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onLogOutTapped,
            child: const Text('Log out'),
          ),
        ),
      ],
    );
  }
}

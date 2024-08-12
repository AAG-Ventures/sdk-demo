import 'package:flutter/material.dart';
import 'package:metaone_wallet_sdk/metaone_wallet_sdk.dart';
import 'package:metaone_wallet_sdk_example/utils.dart';
import 'package:metaone_wallet_sdk_example/wallet_page.dart';

class MyWalletsPage extends StatefulWidget {
  const MyWalletsPage({super.key});

  static Route<dynamic> route() =>
      MaterialPageRoute<dynamic>(builder: (_) => const MyWalletsPage());

  @override
  State<MyWalletsPage> createState() => _MyWalletsPageState();
}

class _MyWalletsPageState extends State<MyWalletsPage> {
  bool _isLoading = false;
  List<Wallet> _wallets = [];

  Future<void> _getWallets() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final wallets = await getWallets();
      setState(() {
        _wallets = wallets;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.showErrorSnackBar(context, message: '$error');
    }
  }

  @override
  void initState() {
    _getWallets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallets'),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _wallets.length,
                itemBuilder: (_, index) {
                  final wallet = _wallets[index];
                  return ListTile(
                    title: Text(wallet.name),
                    subtitle: Text(wallet.address),
                    onTap: () =>
                        Navigator.of(context).push(WalletPage.route(wallet)),
                  );
                },
              ),
      ),
    );
  }
}

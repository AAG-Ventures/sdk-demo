import 'package:flutter/material.dart';
import 'package:metaone_wallet_sdk/metaone_wallet_sdk.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({
    required this.wallet,
    super.key,
  });

  final Wallet wallet;

  static Route<dynamic> route(Wallet wallet) =>
      MaterialPageRoute<dynamic>(builder: (_) => WalletPage(wallet: wallet));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(wallet.name),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            ListTile(
              title: const Text('Address'),
              subtitle: Text(wallet.address),
            ),
            ListTile(
              title: const Text('Balance'),
              subtitle: Text(wallet.balance),
            ),
            ListTile(
              title: const Text('Wallet Type'),
              subtitle: Text(wallet.type ?? 'Unknown'),
            ),
            ListTile(
              title: const Text('Wallet ID'),
              subtitle: Text(wallet.id),
            ),
            ListTile(
              title: const Text('Currency Name'),
              subtitle: Text(wallet.currencyName),
            ),
            ListTile(
              title: const Text('Currency Symbol'),
              subtitle: Text(wallet.currencySymbol),
            ),
            ListTile(
              title: const Text('Price'),
              subtitle: Text(wallet.price),
            ),
            ListTile(
              title: const Text('Address Regex'),
              subtitle: Text(wallet.addressRegex ?? 'Unknown'),
            ),
            ListTile(
              title: const Text('Alternative Address'),
              subtitle: Text(wallet.alternativeAddress ?? 'Unknown'),
            ),
            ListTile(
              title: const Text('Alternative Address Regex'),
              subtitle: Text(wallet.alternativeAddressRegex ?? 'Unknown'),
            ),
            ListTile(
              title: const Text('External Wallet ID'),
              subtitle: Text(wallet.externalWalletId ?? 'Unknown'),
            ),
          ],
        ),
      ),
    );
  }
}

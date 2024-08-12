import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:metaone_wallet_sdk/metaone_wallet_sdk.dart';
import 'package:metaone_wallet_sdk/src/models/models.dart';
import 'package:metaone_wallet_sdk_example/utils.dart';
import 'package:provider/provider.dart';

import 'theme_provider.dart';

class SendTransactionPage extends StatefulWidget {
  const SendTransactionPage({super.key});

  static Route<dynamic> route() =>
      MaterialPageRoute<dynamic>(builder: (_) => const SendTransactionPage());

  @override
  State<SendTransactionPage> createState() => _SendTransactionPageState();
}

class _SendTransactionPageState extends State<SendTransactionPage> {
  bool _isLoading = false;
  late ThemeProvider themeProvider;

  @override
  void initState() {
    _getWallets();
    super.initState();
  }

  List<Wallet> _userWallets = [];
  Wallet? _selectedWallet;
  List<WalletToken> _walletAssets = [];
  WalletToken? _selectedWalletAsset;
  String _toAddress = '';
  String _amount = '';
  String _memo = '';
  String _personalNote = '';

  Future<void> _getWallets() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final wallets = await getWallets();
      setState(() {
        _userWallets = wallets;
        _selectedWallet = wallets[0];
        _walletAssets = wallets[0].tokens ?? [];
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.showErrorSnackBar(context, message: '$error');
    }
  }

  Future<void> _signData() async {
    try {
      final res = await sendTransaction(_selectedWallet!, _toAddress, _amount,
          _selectedWalletAsset, _memo, _personalNote);
      Utils.showSuccessSnackBar(context,
          message: "Transaction successfully signed and sent.");
    } catch (error) {
      Utils.showErrorSnackBar(context, message: '$error');
    }
  }

  void _updateAssets(Wallet? selectedWallet) {
    setState(() {
      _walletAssets = selectedWallet?.tokens ?? [];
      _selectedWalletAsset = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Transaction'),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  SizedBox(height: 16),
                  Flexible(
                    child: DropdownButton<Wallet>(
                      isExpanded: true,
                      value: _selectedWallet,
                      hint: const Text('Select a Wallet'),
                      onChanged: (Wallet? newValue) {
                        setState(() {
                          _selectedWallet = newValue;
                        });
                        _updateAssets(newValue);
                      },
                      items: _userWallets
                          .map<DropdownMenuItem<Wallet>>((Wallet wallet) {
                        return DropdownMenuItem<Wallet>(
                          value: wallet,
                          child: Text(
                            '${wallet.name} ${wallet.balance}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButton<WalletToken>(
                    value: _selectedWalletAsset,
                    hint: Text('Select an Asset'),
                    onChanged: (WalletToken? newValue) {
                      setState(() {
                        _selectedWalletAsset = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem<WalletToken>(
                        value: null,
                        child: Text(
                          "${_selectedWallet?.currencySymbol ?? ""} ${_selectedWallet?.balance.toString()}",
                        ),
                      ),
                      ..._walletAssets.map<DropdownMenuItem<WalletToken>>(
                          (WalletToken asset) {
                        return DropdownMenuItem<WalletToken>(
                          value: asset,
                          child: Text(
                            "${asset.currencyName ?? ""} ${asset.balance.toString()}",
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'To address:',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => setState(() => _toAddress = value),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Amount:',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) => setState(() => _amount = value),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Memo:',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => setState(() => _memo = value),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Personal note:',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) =>
                          setState(() => _personalNote = value),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _selectedWallet != null &&
                            _amount.isNotEmpty &&
                            _toAddress.isNotEmpty
                        ? _signData
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      disabledBackgroundColor:
                          Colors.blue.withOpacity(0.5).withOpacity(0.12),
                    ),
                    child: const Text('Sign'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
      ),
    );
  }
}

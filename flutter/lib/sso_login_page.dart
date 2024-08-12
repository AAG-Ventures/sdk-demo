import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:metaone_wallet_sdk/metaone_wallet_sdk.dart';
import 'package:metaone_wallet_sdk_example/utils.dart';
import 'package:metaone_wallet_sdk_example/widgets.dart';

final _ssoUri = Uri.parse('https://ws-test.aag.ventures/sso/login');

class SSOLoginPage extends StatelessWidget {
  const SSOLoginPage({super.key});

  static Route<dynamic> route() =>
      MaterialPageRoute<dynamic>(builder: (_) => const SSOLoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SSO Login'),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: _LoginForm(),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  bool _isLoading = false;
  String? _email;

  void _onEmailChanged(String value) {
    setState(() {
      _email = value;
    });
  }

  Future<void> _onFormSubmitted() async {
    if (_email == null) {
      Utils.showErrorSnackBar(
        context,
        message: 'Please enter an email address.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final http.Response(:statusCode, :body) = await http.post(
        _ssoUri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'X-Realm': 'SHARE',
        },
        body: jsonEncode({
          'email': _email, 
          'password': '123456'
        }),
      );

      if (statusCode != 200) {
        if (!mounted) return;
        Utils.showErrorSnackBar(
          context,
          message: 'Failed to login with SSO. Status code: $statusCode, resp: $body',
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final decodedResponse = jsonDecode(body) as Map<String, dynamic>;

      await logInWithSSO(decodedResponse['token'] as String);
      await setupUserData();

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;
      Utils.showSuccessSnackBar(context, message: 'Logged in with SSO.');
      Navigator.of(context).pop();
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.showErrorSnackBar(context, message: '$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Email',
          ),
          onChanged: _onEmailChanged,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            onPressed: _onFormSubmitted,
            isLoading: _isLoading,
            text: 'Login',
          ),
        ),
      ],
    );
  }
}

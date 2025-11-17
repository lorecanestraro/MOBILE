import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class UrlLauncherHelper {
  // Previne instanciação
  UrlLauncherHelper._();

  /// Abre uma URL no navegador externo
  static Future<void> openUrl(String? url) async {
    if (url == null || url.isEmpty) {
      debugPrint('❌ URL inválida ou vazia');
      return;
    }

    try {
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        debugPrint('✅ URL aberta com sucesso: $url');
      } else {
        debugPrint('❌ Não foi possível abrir a URL: $url');
      }
    } catch (e) {
      debugPrint('❌ Erro ao abrir URL: $e');
    }
  }

  /// Abre uma URL em uma WebView interna
  static Future<void> openUrlInApp(String? url) async {
    if (url == null || url.isEmpty) {
      debugPrint('❌ URL inválida ou vazia');
      return;
    }

    try {
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
        debugPrint('✅ URL aberta in-app: $url');
      } else {
        debugPrint('❌ Não foi possível abrir a URL: $url');
      }
    } catch (e) {
      debugPrint('❌ Erro ao abrir URL: $e');
    }
  }

  /// Abre um email
  static Future<void> openEmail(
    String email, {
    String? subject,
    String? body,
  }) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: _encodeQueryParameters(<String, String>{
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      }),
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        debugPrint('✅ Email aberto: $email');
      } else {
        debugPrint('❌ Não foi possível abrir o email');
      }
    } catch (e) {
      debugPrint('❌ Erro ao abrir email: $e');
    }
  }

  /// Abre um número de telefone
  static Future<void> openPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
        debugPrint('✅ Telefone aberto: $phoneNumber');
      } else {
        debugPrint('❌ Não foi possível abrir o telefone');
      }
    } catch (e) {
      debugPrint('❌ Erro ao abrir telefone: $e');
    }
  }

  /// Helper para codificar query parameters
  static String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }
}

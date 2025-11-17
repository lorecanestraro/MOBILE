import 'package:app_news/service/url_louncher_helper.dart';
import 'package:flutter/material.dart';

class SourceCard extends StatelessWidget {
  final Map<String, dynamic> source;

  const SourceCard({Key? key, required this.source}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => UrlLauncherHelper.openUrl(source['url']),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              if (source['description'] != null) ...[
                const SizedBox(height: 12),
                _buildDescription(),
              ],
              const SizedBox(height: 8),
              _buildMetadata(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.deepOrangeAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.article, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                source['name'] ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (source['category'] != null)
                Text(
                  source['category'],
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      source['description'],
      style: TextStyle(color: Colors.grey[400]),
    );
  }

  Widget _buildMetadata() {
    return Row(
      children: [
        if (source['language'] != null)
          Chip(
            label: Text(source['language'].toString().toUpperCase()),
            backgroundColor: Colors.blue,
            padding: EdgeInsets.zero,
          ),
        const SizedBox(width: 8),
        if (source['country'] != null)
          Chip(
            label: Text(source['country'].toString().toUpperCase()),
            backgroundColor: Colors.green,
            padding: EdgeInsets.zero,
          ),
      ],
    );
  }
}

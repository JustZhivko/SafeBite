import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'background.dart';
import 'glass_container.dart';
import 'theme.dart';

class ScansPage extends StatefulWidget {
  final int userId;

  const ScansPage({super.key, required this.userId});

  @override
  State<ScansPage> createState() => _ScansPageState();
}

class _ScansPageState extends State<ScansPage> {
  static const String _baseUrl = 'http://localhost:5000';

  List<Map<String, dynamic>> _scans = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchScans();
  }

  Future<void> _fetchScans() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final uri = Uri.parse('$_baseUrl/api/captures?user_id=${widget.userId}');
      final response = await http.get(uri);
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final raw = data['captures'] as List<dynamic>;
        setState(() {
          _scans = raw.cast<Map<String, dynamic>>();
        });
      } else {
        setState(() {
          _error = data['error'] as String? ?? 'Loading error.';
        });
      }
    } catch (_) {
      setState(() {
        _error = 'No connection with the server.';
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Scans'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: _loading ? null : _fetchScans,
              icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
              tooltip: 'Reload',
            ),
          ],
        ),
        body: _loading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFA855F7)),
              )
            : _error != null
            ? _ErrorState(message: _error!, onRetry: _fetchScans)
            : _scans.isEmpty
            ? const _EmptyState()
            : RefreshIndicator(
                onRefresh: _fetchScans,
                color: AppTheme.accent,
                backgroundColor: const Color(0xFF1A1040),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: _scans.length,
                  itemBuilder: (context, i) => _ScanCard(scan: _scans[i]),
                ),
              ),
      ),
    );
  }
}

class _ScanCard extends StatelessWidget {
  final Map<String, dynamic> scan;

  const _ScanCard({required this.scan});

  String _formatDate(String? raw) {
    if (raw == null) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      final p = (int n) => n.toString().padLeft(2, '0');
      return '${p(dt.day)}.${p(dt.month)}.${dt.year}  ${p(dt.hour)}:${p(dt.minute)}';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = scan['image_url'] as String?;
    final responseText = scan['response_text'] as String? ?? '';
    final createdAt = _formatDate(scan['created_at'] as String?);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GlassContainer(
        padding: const EdgeInsets.all(0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Снимка
              if (imageUrl != null)
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) => progress == null
                        ? child
                        : Container(
                            height: 200,
                            color: Colors.white.withOpacity(0.04),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFA855F7),
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: Colors.white.withOpacity(0.04),
                      child: const Center(
                        child: Icon(
                          Icons.broken_image_rounded,
                          color: Colors.white24,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),

              // AI Отговор
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.smart_toy_rounded,
                        size: 15,
                        color: AppTheme.accent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        responseText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.55,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Дата
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 2, 14, 14),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: AppTheme.muted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      createdAt,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.qr_code_scanner_rounded,
            size: 64,
            color: AppTheme.accent.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'No scans yet',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Scan a food with our device',
            style: TextStyle(color: AppTheme.muted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.white24),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: Colors.white60, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

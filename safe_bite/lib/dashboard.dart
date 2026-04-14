import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'background.dart';
import 'glass_container.dart';
import 'theme.dart';
import 'scans.dart';

class DashboardPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const DashboardPage({super.key, required this.user});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const String _baseUrl = 'http://localhost:5000';

  int _scanCount = 0;
  bool _countLoading = true;

  late final int _userId;
  late final String _userName;
  late final String _userEmail;

  @override
  void initState() {
    super.initState();
    _userId = widget.user['id'] as int;
    _userName = widget.user['name'] as String? ?? 'User';
    _userEmail = widget.user['email'] as String? ?? '';
    _fetchScanCount();
  }

  Future<void> _fetchScanCount() async {
    try {
      final uri = Uri.parse('$_baseUrl/api/captures?user_id=$_userId');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final captures = data['captures'] as List<dynamic>;
        setState(() => _scanCount = captures.length);
      }
    } catch (_) {
    } finally {
      setState(() => _countLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WelcomeCard(userName: _userName, userEmail: _userEmail),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.qr_code_scanner_rounded,
                      label: "Scans count",
                      value: _countLoading ? '…' : '$_scanCount',
                      color: AppTheme.accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text(
                "Recent scans",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accent2,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.radius,
                            ),
                          ),
                          elevation: 6,
                          shadowColor: AppTheme.accent2.withOpacity(0.5),
                        ),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ScansPage(userId: _userId),
                            ),
                          );
                          // refresh count when returning from ScansPage
                          _fetchScanCount();
                        },
                        child: const Text(
                          "See Scans",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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

class _WelcomeCard extends StatelessWidget {
  final String userName;
  final String userEmail;

  const _WelcomeCard({required this.userName, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFA855F7), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accent.withOpacity(0.45),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Color(0xFFA855F7), blurRadius: 14),
                        Shadow(color: Colors.white38, blurRadius: 6),
                      ],
                    ),
                    children: [
                      const TextSpan(text: "Welcome, "),
                      TextSpan(
                        text: userName.split(" ").first,
                        style: const TextStyle(color: Color(0xFFD8B4FE)),
                      ),
                      const TextSpan(text: " 👋"),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 13,
                      color: AppTheme.muted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: color.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              shadows: [Shadow(color: color.withOpacity(0.7), blurRadius: 12)],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: AppTheme.muted),
          ),
        ],
      ),
    );
  }
}

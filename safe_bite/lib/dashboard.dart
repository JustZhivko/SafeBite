import 'package:flutter/material.dart';
import 'background.dart';
import 'glass_container.dart';
import 'theme.dart';

class DashboardPage extends StatelessWidget {
  // Example user:
  final String userName = "User";
  final String userEmail = "user@example.com";
  final String joinDate = "...";
  final int totalScans = 0;

  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WelcomeCard(
                userName: userName,
                userEmail: userEmail,
                joinDate: joinDate,
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.qr_code_scanner_rounded,
                      label: "Scans count",
                      value: "$totalScans",
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
                padding: const EdgeInsets.all(0),
                child: Column(children: const [
                    
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
  final String joinDate;

  const _WelcomeCard({
    required this.userName,
    required this.userEmail,
    required this.joinDate,
  });

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
          // Info
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
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 13,
                      color: AppTheme.muted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Member since $joinDate",
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

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: AppTheme.border,
    );
  }
}

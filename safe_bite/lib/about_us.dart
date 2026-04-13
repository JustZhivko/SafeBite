import 'package:flutter/material.dart';
import 'background.dart';
import 'glass_container.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: GlassContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      "За SafeBite",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _Section(
                    icon: Icons.visibility_off_rounded,
                    title: "Проблемът",
                    body:
                        "Незрящите хора не могат самостоятелно да преценят дали храната им е годна за консумация — развалена ли е, има ли мухъл, какво изобщо е. Тези въпроси изискват чужда помощ всеки ден.",
                  ),
                  const SizedBox(height: 20),
                  _Section(
                    icon: Icons.camera_alt_rounded,
                    title: "Решението",
                    body:
                        "Вградена камера сканира храната в реално време. Снимката се изпраща до AI, който разпознава продукта и оценява състоянието му, а резултатът се съобщава в рамките на няколко секунди под формата на гласово съобщение. ",
                  ),
                  const SizedBox(height: 20),
                  _Section(
                    icon: Icons.language_rounded,
                    title: "Приложение",
                    body:
                        "Придружаващото приложение предоставя история на сканиранията, подробна информация за продуктите и настройки за персонализация.",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _Section({required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2, right: 12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFA855F7).withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFA855F7).withOpacity(0.30),
            ),
          ),
          child: Icon(icon, color: const Color(0xFFA855F7), size: 18),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                body,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(height: 1.55),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class FragmentAbout extends StatelessWidget {
  const FragmentAbout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaW = MediaQuery.of(context).size.width;
    final isWideScreen = mediaW > 600;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWideScreen ? 24.0 : 16.0,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo / Icon
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.restaurant_menu,
                      size: 60,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // App Name
              Text(
                'AI Cooking Helper',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(height: 8),

              // Version
              Text(
                'Versi 1.2.0',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 24),

              // Description
              Text(
                'Tentang Aplikasi',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'AI Cooking Helper adalah aplikasi inovatif yang membantu Anda menemukan resep masakan berdasarkan bahan yang Anda miliki atau gambar makanan. '
                'Dengan teknologi AI terdepan, aplikasi ini memberikan resep lengkap, bahan-bahan, cara memasak, dan tips praktis untuk hasil terbaik.',
                textAlign: TextAlign.justify,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              // Features
              Text(
                'Fitur Unggulan',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              _FeatureItem(
                icon: Icons.text_fields,
                title: 'Resep dari Teks',
                description:
                    'Masukkan bahan atau nama masakan, AI akan membuat resep lengkap untuk Anda.',
              ),

              const SizedBox(height: 12),

              _FeatureItem(
                icon: Icons.image,
                title: 'Resep dari Gambar',
                description:
                    'Ambil foto bahan atau makanan, AI akan menganalisis dan membuat resep sesuai kategori.',
              ),

              const SizedBox(height: 24),

              // Developer Info
              Text(
                'Pengembang',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1. Achmad Dwi Prasetyo - 220401010168',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '2. Jovita Kusuma - 220401010270',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '3. Jeki Hendrian - 220401010191',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '4. Ikram - 240401020139',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '5. Harry Kusuma Bhakti - 240401020171',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tim berdedikasi dalam mengembangkan aplikasi mobile yang inovatif dan user-friendly.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Contact / Links
              Text(
                'Kontak & Media',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ContactButton(
                    icon: Icons.language,
                    label: 'Website',
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  _ContactButton(
                    icon: Icons.email,
                    label: 'Email',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Copyright
              Text(
                'Copyright © ${DateTime.now().year} Flying Cats\nAll Rights Reserved',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: Icon(icon, color: Colors.orange, size: 24)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.orange, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

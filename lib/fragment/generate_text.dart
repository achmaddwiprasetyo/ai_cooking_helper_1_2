import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../utils/ai_service.dart';

class FragmentGenerateText extends StatefulWidget {
  const FragmentGenerateText({super.key});

  @override
  State<FragmentGenerateText> createState() => _FragmentGenerateTextState();
}

class _FragmentGenerateTextState extends State<FragmentGenerateText> {
  final TextEditingController textEditingController = TextEditingController();
  String strAnswer = '';
  bool visibleSP = false;
  bool isLoading = false;

  String selectedCategory = 'Masakan Indonesia';

  final listCategory = [
    'Masakan Indonesia',
    'Masakan Barat',
    'Masakan Jepang',
    'Masakan Korea',
    'Masakan China',
    'Masakan Timur Tengah',
    'Makanan Diet / Sehat',
    'Makanan Vegan',
    'Dessert / Kue',
    'Minuman',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxW = constraints.maxWidth;
            final horizontalPadding = (maxW > 600) ? 24.0 : 16.0;
            final inputBoxHeight = (maxW > 600) ? 120.0 : 100.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Text input
                  Container(
                    height: inputBoxHeight,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: TextField(
                      controller: textEditingController,
                      maxLines: 4,
                      onChanged: (text) => setState(() {}),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        labelText: 'Masukkan bahan atau nama masakan...',
                        suffixIcon: IconButton(
                          icon: Icon(
                            textEditingController.text.isNotEmpty
                                ? Icons.cancel
                                : null,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            textEditingController.clear();
                            visibleSP = false;
                            setState(() {});
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        onChanged: (value) {
                          setState(() => selectedCategory = value!);
                        },
                        items: listCategory.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Button
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (textEditingController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Input tidak boleh kosong!'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                visibleSP = true;
                                isLoading = true;
                                strAnswer = '';
                              });

                              try {
                                final model = GenerativeModel(
                                  model: 'gemini-2.5-flash-lite',
                                  apiKey: API_KEY,
                                );

                                final response = await model.generateContent([
                                  Content.text("""
Kamu adalah AI Cooking Helper.

Buatkan **resep lengkap** sesuai kategori **$selectedCategory**, dari input:

"${textEditingController.text}"

Format markdown:

# 🍽️ Nama Masakan  
## 📝 Bahan  
- ...  
## 👩‍🍳 Cara Memasak  
1. ...  
2. ...  
## ⏱ Waktu  
- Persiapan: ...  
- Memasak: ...  
## 🍽 Tips  
- ...
"""),
                                ]);

                                setState(() {
                                  strAnswer =
                                      response.text ?? 'Tidak ada respon.';
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Terjadi kesalahan: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('Buatkan Resep'),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Result area with animated switcher for smooth transitions
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: visibleSP
                        ? Container(
                            key: ValueKey<String>(
                              isLoading ? 'loading' : strAnswer,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.orange),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: isLoading
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Mencari resep...',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  )
                                : (strAnswer.isEmpty
                                      ? const Text('Belum ada hasil.')
                                      : MarkdownBody(data: strAnswer)),
                          )
                        : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 18),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/ai_service.dart';

class FragmentGenerateImage extends StatefulWidget {
  const FragmentGenerateImage({super.key});

  @override
  State<FragmentGenerateImage> createState() => _FragmentGenerateImageState();
}

class _FragmentGenerateImageState extends State<FragmentGenerateImage> {
  String strAnswer = '';
  bool visibleSP = false;
  bool isLoading = false;
  File? imageFile;
  final picker = ImagePicker();

  String selectedType = 'Masakan Indonesia';

  final listType = [
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final double maxW = constraints.maxWidth;
                  final double boxHeight = (maxW * 0.56).clamp(180.0, 420.0);

                  return GestureDetector(
                    onTap: showImagePicker,
                    child: SizedBox(
                      height: boxHeight,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        color: Colors.orange,
                        dashPattern: const [6, 4],
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: imageFile != null
                              ? Image.file(
                                  imageFile!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: boxHeight,
                                )
                              : Container(
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.food_bank,
                                        size: 72,
                                        color: Colors.orange,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Ketuk untuk pilih gambar',
                                        style: TextStyle(color: Colors.orange),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedType,
                    onChanged: (v) => setState(() => selectedType = v!),
                    items: listType
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    isExpanded: true,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: theme.textTheme.titleMedium,
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (imageFile == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Masukkan gambar bahan makanan'),
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

                          await generateRecipeFromImage();
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
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
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
                                    'Menganalisis gambar...',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )
                            : (strAnswer.isEmpty
                                  ? const Text('Belum ada hasil.')
                                  : MarkdownBody(data: strAnswer)),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void showImagePicker() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) => Container(
        height: 160,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (picked != null)
                      setState(() => imageFile = File(picked.path));
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.image,
                    size: 40,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 6),
                const Text('Galeri'),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final picked = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (picked != null)
                      setState(() => imageFile = File(picked.path));
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 6),
                const Text('Kamera'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> generateRecipeFromImage() async {
    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash-lite',
        apiKey: API_KEY,
      );

      final result = await model.generateContent([
        Content.multi([
          TextPart("""
Kamu adalah AI Cooking Helper.  
Analisis gambar bahan makanan ini dan buatkan resep lengkap sesuai kategori: **$selectedType**.

Format:
## Nama Makanan
## Bahan-bahan
## Cara Memasak
## Tips
"""),
          DataPart('image/jpeg', imageFile!.readAsBytesSync()),
        ]),
      ]);

      setState(() {
        strAnswer = result.text ?? 'Tidak ada respon dari AI.';
      });
    } catch (e) {
      setState(() {
        strAnswer = 'Terjadi kesalahan: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

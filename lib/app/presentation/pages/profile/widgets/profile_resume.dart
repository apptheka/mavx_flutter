import 'dart:ui';

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart'; 
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileResume extends StatelessWidget {
  final ProfileController controller;
  const ProfileResume({super.key, required this.controller});

  String prefixBase(String path) {
    if (path.isEmpty) return path;
    if (path.startsWith('http')) return path;
    // Use baseUrlImage and append just the file name or relative path (no 'uploads/' prefix)
    final base = AppConstants.baseUrlImage.endsWith('/')
        ? AppConstants.baseUrlImage
        : '${AppConstants.baseUrlImage}/';
    String clean = path.trim();
    if (clean.startsWith('/')) clean = clean.substring(1);
    final lower = clean.toLowerCase();
    // Remove any accidental leading public/ or uploads/ from the stored value
    if (lower.startsWith('public/')) {
      clean = clean.substring(7);
    } else if (lower.startsWith('uploads/')) {
      clean = clean.substring(8);
    }
    final full = '$base$clean';
    // URL-encode to handle spaces and special chars
    return Uri.encodeFull(full);
  }

  @override
  Widget build(BuildContext context) {
    String rawResume = controller.registeredProfile.value.resume ?? '';
    String resumeUrl = prefixBase(rawResume);
    return SectionCard(
      title: 'Resume',
      subtitle: 'Highlight your strongest areas of expertise',
      // onEdit: () {
      //   Get.bottomSheet(
      //     BackdropFilter(
      //       filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      //       child: Container(
      //         padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      //         decoration: const BoxDecoration(
      //           color: Colors.white,
      //           borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      //         ),
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             const Text(
      //               'Edit Resume',
      //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
      //             ),
      //             const SizedBox(height: 6),
      //             const Text(
      //               'Update your professional document',
      //               style: TextStyle(color: AppColors.textSecondaryColor),
      //             ),
      //             const SizedBox(height: 12),
      //             Container(
      //               height: 180,
      //               width: double.infinity,
      //               decoration: BoxDecoration(
      //                 color: AppColors.greyColor,
      //                 borderRadius: BorderRadius.circular(12),
      //                 border: Border.all(
      //                   color: AppColors.black.withValues(alpha: 0.06),
      //                   width: 2,
      //                 ),
      //                 boxShadow: [
      //                   BoxShadow(
      //                     color: Colors.black.withValues(alpha: 0.06),
      //                     blurRadius: 10,
      //                     offset: const Offset(0, 4),
      //                   ),
      //                 ],
      //               ),
      //               child: Center(
      //                 child: Column(
      //                   mainAxisSize: MainAxisSize.min,
      //                   children: [
      //                     const Icon(
      //                       Icons.picture_as_pdf,
      //                       color: AppColors.textSecondaryColor,
      //                       size: 36,
      //                     ),
      //                     const SizedBox(height: 8),
      //                     CommonText(
      //                       rawResume.isNotEmpty
      //                           ? rawResume.split('/').last
      //                           : 'No resume found',
      //                       color: AppColors.textSecondaryColor, 
      //                       fontSize: 15,
      //                       fontWeight: FontWeight.w600,
      //                       overflow: TextOverflow.ellipsis,
      //                     ),
      //                     const SizedBox(height: 12),
      //                     SizedBox(
      //                       width: MediaQuery.of(context).size.width * 0.4,
      //                       child: ElevatedButton(
      //                         onPressed: () {
                            
      //                         },
      //                         child: const CommonText(
      //                           'Update',
      //                           fontSize: 15,
      //                           fontWeight: FontWeight.w600,
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             const SizedBox(height: 12),
      //             Align(
      //               alignment: Alignment.centerRight,
      //               child: TextButton(
      //                 onPressed: () => Get.back(),
      //                 child: const Text('Close'),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //     isScrollControlled: true,
      //   );
      // },
      child: Obx(() {
        rawResume = controller.registeredProfile.value.resume ?? '';
        resumeUrl = prefixBase(rawResume);
        final displayName = rawResume.isNotEmpty
            ? rawResume.split('/').last
            : 'No resume found';
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.greyColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.black.withValues(alpha: 0.06),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Image.asset(
                IconAssets.resume,
                height: 20,
                width: 20,
                color: AppColors.textSecondaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CommonText(
                  displayName,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryColor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  HapticFeedback.lightImpact();
                  final url = resumeUrl.trim();
                  print("url>>>>>>>>>>>> $url");
                  if (url.isEmpty) {
                    Get.snackbar('Resume', 'No resume found to view');
                    return;
                  }
                  await Get.to(() => ResumeViewerPage(url: url));
                  
                },
                child: Icon(Icons.remove_red_eye)
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ResumeViewerPage extends StatelessWidget {
  final String url;
  const ResumeViewerPage({super.key, required this.url});

  bool _isImageUrl(String u) {
    try {
      final path = Uri.parse(u).path.toLowerCase();
      return path.endsWith('.jpg') ||
          path.endsWith('.jpeg') ||
          path.endsWith('.png') ||
          path.endsWith('.gif') ||
          path.endsWith('.webp');
    } catch (_) {
      final p = u.toLowerCase().split('?').first;
      return p.endsWith('.jpg') ||
          p.endsWith('.jpeg') ||
          p.endsWith('.png') ||
          p.endsWith('.gif') ||
          p.endsWith('.webp');
    }
  }

  Future<Uint8List> _loadPdfBytes() async {
    final encoded = Uri.encodeFull(url);
    final variants = <String>[encoded, url];
    final dio = Dio(BaseOptions(
      responseType: ResponseType.bytes,
      followRedirects: true,
      receiveTimeout: const Duration(seconds: 25),
      connectTimeout: const Duration(seconds: 20),
      validateStatus: (s) => s != null && s < 500,
    ));
    for (final u in variants) {
      try {
        debugPrint('[ResumeViewer] fetching: ' + u);
        final resp = await dio.get<List<int>>(u,
            options: Options(
              responseType: ResponseType.bytes,
              headers: {
                'User-Agent': 'Mozilla/5.0 (Mobile; Flutter) AppleWebKit/537.36 (KHTML, like Gecko) Safari/537.36',
              },
            ));
        if (resp.statusCode == 200 && resp.data != null) {
          // Basic type check
          final headers = resp.headers.map.map((k, v) => MapEntry(k.toLowerCase(), v));
          final ct = (headers['content-type']?.join(',') ?? '').toLowerCase();
          if (ct.isNotEmpty && !(ct.contains('pdf') || ct.contains('octet-stream'))) {
            // Try next variant
            continue;
          }
          final bytes = Uint8List.fromList(resp.data!);
          debugPrint('[ResumeViewer] fetched ${bytes.length} bytes from variant');
          return bytes;
        }
      } catch (e) {
        // try next variant
        continue;
      }
    }
    throw Exception('Unable to fetch PDF');
  }

  @override
  Widget build(BuildContext context) {
    if (_isImageUrl(url)) {
      return Scaffold(
        appBar: AppBar(title: const Text('Resume')),
        body: Center(
          child: InteractiveViewer(
            child: Image.network(
              url,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.broken_image, size: 42, color: Colors.redAccent),
                    const SizedBox(height: 8),
                    const Text('Unable to load image.'),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () async {
                        final u = Uri.parse(url);
                        if (await canLaunchUrl(u)) {
                          await launchUrl(u, mode: LaunchMode.externalApplication);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 40),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Open in browser'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Resume')),
      body: FutureBuilder<Uint8List>(
        future: _loadPdfBytes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            debugPrint('[ResumeViewer] error: ' + snapshot.error.toString());
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 42, color: Colors.redAccent),
                  const SizedBox(height: 10),
                  const Text('We couldn\'t open your resume.'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () => Get.off(() => ResumeViewerPage(url: url)),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 40),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Retry'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () async {
                          final u = Uri.parse(url);
                          if (await canLaunchUrl(u)) {
                            await launchUrl(u, mode: LaunchMode.externalApplication);
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 40),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Open in browser'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return SfPdfViewer.memory(
            snapshot.data!,
            canShowScrollStatus: true,
            enableDoubleTapZooming: true,
            onDocumentLoadFailed: (details) {
              debugPrint('[ResumeViewer] render failed: ' + details.description);
              Get.snackbar('Resume', 'Unable to render the PDF. Please try again.');
            },
          );
        },
      ),
    );
  }
}

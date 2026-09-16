import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ArticleImageCarousel extends StatefulWidget {
  final List<String> images;

  const ArticleImageCarousel({required this.images, super.key});

  @override
  State<ArticleImageCarousel> createState() => _ArticleImageCarouselState();
}

class _ArticleImageCarouselState extends State<ArticleImageCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.image_not_supported,
          size: 60,
          color: Colors.grey,
        ),
      );
    }

    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          items: widget.images.map((imageUrl) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 350,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      // Optimisation RAM : redimensionne l'image au décodage pour ne pas saturer la mémoire
                      memCacheWidth: 800,
                      memCacheHeight: 800,
                      // Optimisation Disque : limite la taille du fichier enregistré dans le cache
                      maxWidthDiskCache: 800,
                      maxHeightDiskCache: 800,
                      fadeInDuration: const Duration(milliseconds: 300),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Container(
                            height: 350,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                      errorWidget: (context, url, error) => Container(
                        height: 350,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  : Image.asset(
                      'assets/images/empty_image.png',
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 300,
            viewportFraction: 1.0,
            enableInfiniteScroll: widget.images.length > 1,
            autoPlay: widget.images.length > 1,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),
        const SizedBox(height: 12),

        // ⭐ Indicateur via smooth_page_indicator
        if (widget.images.length > 1)
          AnimatedSmoothIndicator(
            activeIndex: _currentIndex,
            count: widget.images.length,
            onDotClicked: (index) {
              _controller.animateToPage(index);
            },
            effect: WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: Theme.of(context).primaryColor,
              dotColor: Colors.grey.shade300,
            ),
          ),
      ],
    );
  }
}

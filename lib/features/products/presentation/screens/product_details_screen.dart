import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/core/di/injection_container.dart';
import 'package:flutter_application_1/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_application_1/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter_application_1/features/products/presentation/bloc/product_bloc.dart';
import 'package:flutter_application_1/features/products/presentation/bloc/product_event.dart';
import 'package:flutter_application_1/features/products/presentation/bloc/product_state.dart';
import 'package:flutter_application_1/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:flutter_application_1/features/wishlist/presentation/bloc/wishlist_event.dart';
import 'package:flutter_application_1/features/wishlist/presentation/bloc/wishlist_state.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/core/utils/toast_helper.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late ProductBloc _productBloc;
  int _activeImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _productBloc = sl<ProductBloc>()
      ..add(LoadProductDetailsRequested(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _productBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductDetailsLoaded) {
              final product = state.product;
              return CustomScrollView(
                slivers: [
                  // Premium Header with Image Carousel
                  SliverAppBar(
                    expandedHeight: 400,
                    pinned: true,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          PageView.builder(
                            onPageChanged: (index) =>
                                setState(() => _activeImageIndex = index),
                            itemCount: product.images.length,
                            itemBuilder: (context, index) {
                              return Hero(
                                tag: 'product_${product.id}',
                                child: CachedNetworkImage(
                                  imageUrl: product.images[index],
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                          ),
                          if (product.images.length > 1)
                            Positioned(
                              bottom: 20,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  product.images.length,
                                  (index) => Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _activeImageIndex == index
                                          ? theme.primaryColor
                                          : Colors.grey[300],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    actions: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.share_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          onPressed: () => _showShareSheet(context, product),
                        ),
                      ),
                      BlocBuilder<WishlistBloc, WishlistState>(
                        builder: (context, wishlistState) {
                          bool isWishlisted = false;
                          if (wishlistState is WishlistLoaded) {
                            isWishlisted = wishlistState.products.any(
                              (e) => e.id == product.id,
                            );
                          }
                          return Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                isWishlisted
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isWishlisted ? Colors.red : Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: () {
                                if (isWishlisted) {
                                  context.read<WishlistBloc>().add(
                                    RemoveFromWishlistRequested(product.id),
                                  );
                                } else {
                                  context.read<WishlistBloc>().add(
                                    AddToWishlistRequested(product),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // Product Info Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product.category.toUpperCase(),
                                style: TextStyle(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${product.rating}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    ' (${product.reviews.length} ${l10n.customerReviews})',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                '\$${(product.price * (1 - product.discountPercentage / 100)).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (product.discountPercentage > 0) ...[
                                const SizedBox(width: 12),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 18,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${product.discountPercentage}% OFF',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 24),
                          Text(
                            l10n.description,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            product.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Reviews Header
                          Text(
                            l10n.customerReviews,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Ratings summary breakdown
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${product.rating}',
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (i) => Icon(
                                        Icons.star,
                                        size: 16,
                                        color: i < product.rating.round()
                                            ? Colors.amber
                                            : Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${product.reviews.length} ${l10n.customerReviews}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 32),
                              Expanded(
                                child: Column(
                                  children: List.generate(5, (index) {
                                    final starLevel = 5 - index;
                                    final count = product.reviews
                                        .where((r) => r.rating == starLevel)
                                        .length;
                                    final percentage = product.reviews.isEmpty
                                        ? 0.0
                                        : count / product.reviews.length;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 2.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            '$starLevel',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.star,
                                            size: 10,
                                            color: Colors.amber,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              child: LinearProgressIndicator(
                                                value: percentage,
                                                minHeight: 6,
                                                backgroundColor:
                                                    Colors.grey[200],
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          SizedBox(
                                            width: 20,
                                            child: Text(
                                              '$count',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[600],
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // Reviews List
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final review = product.reviews[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  review.reviewerName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      Icons.star,
                                      size: 14,
                                      color: i < review.rating
                                          ? Colors.amber
                                          : Colors.grey[300],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              review.comment,
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            ),
                          ],
                        ),
                      );
                    }, childCount: product.reviews.length),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ), // Space for bottom bar
                ],
              );
            } else if (state is ProductError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
        bottomSheet: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductDetailsLoaded) {
              final product = state.product;
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<WishlistBloc, WishlistState>(
                        builder: (context, wishlistState) {
                          bool isWishlisted = false;
                          if (wishlistState is WishlistLoaded) {
                            isWishlisted = wishlistState.products.any(
                              (e) => e.id == product.id,
                            );
                          }
                          return OutlinedButton(
                            onPressed: () {
                              if (isWishlisted) {
                                context.read<WishlistBloc>().add(
                                  RemoveFromWishlistRequested(product.id),
                                );
                              } else {
                                context.read<WishlistBloc>().add(
                                  AddToWishlistRequested(product),
                                );
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              foregroundColor: isWishlisted ? Colors.red : null,
                              side: isWishlisted
                                  ? const BorderSide(color: Colors.red)
                                  : null,
                            ),
                            child: Icon(
                              isWishlisted
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<CartBloc>().add(
                            AddProductToCartRequested(product),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.addedToCart),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.addToCart.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  void _showShareSheet(BuildContext context, dynamic product) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[950] : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isAr ? 'مشاركة المنتج' : 'Share Product',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: product.thumbnail,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${product.price}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildShareOption(
                      icon: Icons.copy,
                      label: isAr ? 'نسخ الرابط' : 'Copy Link',
                      color: Colors.blue,
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                          text: 'https://velvet-shop.com/product/${product.id}',
                        ));
                        Navigator.pop(context);
                        ToastHelper.showSuccess(
                          isAr ? 'تم نسخ الرابط إلى الحافظة!' : 'Link copied to clipboard!',
                        );
                      },
                    ),
                    _buildShareOption(
                      icon: Icons.send,
                      label: isAr ? 'واتساب' : 'WhatsApp',
                      color: const Color(0xFF25D366),
                      onTap: () => _simulateShare(context, 'WhatsApp'),
                    ),
                    _buildShareOption(
                      icon: Icons.telegram,
                      label: isAr ? 'تيليجرام' : 'Telegram',
                      color: const Color(0xFF0088cc),
                      onTap: () => _simulateShare(context, 'Telegram'),
                    ),
                    _buildShareOption(
                      icon: Icons.chat_bubble_outline,
                      label: isAr ? 'ماسنجر' : 'Messenger',
                      color: const Color(0xFF0084FF),
                      onTap: () => _simulateShare(context, 'Messenger'),
                    ),
                    _buildShareOption(
                      icon: Icons.email_outlined,
                      label: isAr ? 'بريد' : 'Email',
                      color: Colors.redAccent,
                      onTap: () => _simulateShare(context, 'Email'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(28),
            child: CircleAvatar(
              radius: 26,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color, size: 24),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _simulateShare(BuildContext context, String platform) {
    Navigator.pop(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    ToastHelper.showSuccess(
      isAr
          ? 'تمت المشاركة بنجاح عبر $platform!'
          : 'Successfully shared via $platform!',
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/features/products/presentation/bloc/product_bloc.dart';
import 'package:flutter_application_1/features/products/presentation/bloc/product_event.dart';
import 'package:flutter_application_1/features/products/presentation/bloc/product_state.dart';
import 'package:flutter_application_1/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_application_1/features/cart/presentation/bloc/cart_state.dart';
import 'package:flutter_application_1/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_application_1/features/products/presentation/widgets/product_card.dart';
import 'package:flutter_application_1/features/products/presentation/widgets/category_chips.dart';
import 'package:flutter_application_1/core/widgets/error_view.dart';
import 'package:flutter_application_1/core/widgets/fade_in_animation.dart';
import 'package:flutter_application_1/core/widgets/shimmer_loading.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [const _ProductHome(), const ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.profile,
          ),
        ],
      ),
    );
  }
}

class _ProductHome extends StatefulWidget {
  const _ProductHome();

  @override
  State<_ProductHome> createState() => _ProductHomeState();
}

class _ProductHomeState extends State<_ProductHome> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;
  bool _isSearching = false;

  final List<String> _categories = [
    'All',
    'Beauty',
    'Fragrances',
    'Furniture',
    'Groceries',
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<ProductBloc>().add(LoadMoreProductsRequested());
    }
  }

  void _loadProducts() {
    context.read<ProductBloc>().add(LoadProductsRequested());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.length >= 3 || query.isEmpty) {
        context.read<ProductBloc>().add(SearchProductsRequested(query));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchProducts,
                  border: InputBorder.none,
                  filled: false,
                ),
                style: const TextStyle(fontSize: 18),
                onChanged: _onSearchChanged,
                onSubmitted: (query) {
                  context.read<ProductBloc>().add(SearchProductsRequested(query));
                },
              )
            : Text(AppLocalizations.of(context)!.discover),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _loadProducts();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => context.push('/wishlist'),
          ),
          _CartBadge(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadProducts();
        },
        child: Column(
          children: [
            if (!_isSearching)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CategoryChips(
                  categories: _categories,
                  categoryLabels: _categories.map((c) {
                    final l10n = AppLocalizations.of(context)!;
                    switch (c) {
                      case 'All':
                        return l10n.all;
                      case 'Beauty':
                        return l10n.beauty;
                      case 'Fragrances':
                        return l10n.fragrances;
                      case 'Furniture':
                        return l10n.furniture;
                      case 'Groceries':
                        return l10n.groceries;
                      default:
                        return c;
                    }
                  }).toList(),
                  onCategorySelected: (category) {
                    context.read<ProductBloc>().add(
                      FilterProductsRequested(category),
                    );
                  },
                ),
              ),
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return _buildSkeletonGrid();
                  } else if (state is ProductsLoaded) {
                    if (state.products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.network(
                              'https://assets9.lottiefiles.com/packages/lf20_ghp9m5re.json',
                              width: 200,
                              height: 200,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.search_off,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.noProductsFound,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        return FadeInAnimation(
                          delay: Duration(milliseconds: index * 50),
                          child: ProductCard(product: state.products[index]),
                        );
                      },
                    );
                  } else if (state is ProductError) {
                    return ErrorView(
                      message: state.message,
                      onRetry: _loadProducts,
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonGrid() {
    return ShimmerLoading(
      isLoading: true,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => const ProductSkeleton(),
      ),
    );
  }
}

class _CartBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int count = 0;
        if (state is CartLoaded) {
          count = state.totalItems;
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () => context.push('/cart'),
            ),
            if (count > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

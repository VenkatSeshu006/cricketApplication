import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../domain/models/shop.dart';
import '../../domain/models/shop_item.dart';

class ShopDetailPage extends StatefulWidget {
  final Shop shop;

  const ShopDetailPage({super.key, required this.shop});

  @override
  State<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';

  // Mock shop items
  final List<ShopItem> _shopItems = [
    ShopItem(
      id: '1',
      shopId: '1',
      name: 'SS Professional Cricket Bat',
      description:
          'Premium English willow cricket bat for professional players',
      imageUrl: 'https://images.unsplash.com/photo-1531415074968-036ba1b575da',
      price: 12000,
      discountPrice: 10200,
      category: 'Bats',
      brand: 'SS',
      inStock: true,
      stockQuantity: 15,
      rating: 4.7,
      reviewCount: 89,
      sizes: ['Short Handle', 'Long Handle'],
      colors: [],
      images: [],
      material: 'English Willow',
      weight: '1200g',
      isFeatured: true,
      isNewArrival: false,
    ),
    ShopItem(
      id: '2',
      shopId: '1',
      name: 'MRF Genius Grand Edition Bat',
      description: 'Top-grade Kashmir willow bat with excellent balance',
      imageUrl: 'https://images.unsplash.com/photo-1624526267942-ab0ff8a3e972',
      price: 8500,
      discountPrice: null,
      category: 'Bats',
      brand: 'MRF',
      inStock: true,
      stockQuantity: 8,
      rating: 4.8,
      reviewCount: 124,
      sizes: ['Short Handle', 'Long Handle'],
      colors: [],
      images: [],
      material: 'Kashmir Willow',
      weight: '1150g',
      isFeatured: true,
      isNewArrival: true,
    ),
    ShopItem(
      id: '3',
      shopId: '1',
      name: 'SG Test Cricket Ball (Pack of 6)',
      description: 'Premium leather cricket balls for match play',
      imageUrl: 'https://images.unsplash.com/photo-1531415074968-036ba1b575da',
      price: 3600,
      discountPrice: 3200,
      category: 'Balls',
      brand: 'SG',
      inStock: true,
      stockQuantity: 25,
      rating: 4.6,
      reviewCount: 67,
      sizes: [],
      colors: ['Red'],
      images: [],
      material: 'Premium Leather',
      weight: '156g each',
      isFeatured: false,
      isNewArrival: false,
    ),
    ShopItem(
      id: '4',
      shopId: '1',
      name: 'Nike Cricket Batting Pads',
      description:
          'Lightweight professional batting pads with excellent protection',
      imageUrl: 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e',
      price: 4500,
      discountPrice: 3800,
      category: 'Protective Gear',
      brand: 'Nike',
      inStock: true,
      stockQuantity: 12,
      rating: 4.5,
      reviewCount: 45,
      sizes: ['Small', 'Medium', 'Large'],
      colors: ['White', 'Black'],
      images: [],
      material: 'High-Density Foam',
      weight: '850g',
      isFeatured: false,
      isNewArrival: false,
    ),
    ShopItem(
      id: '5',
      shopId: '1',
      name: 'Adidas Batting Gloves Pro',
      description: 'Premium batting gloves with superior grip and comfort',
      imageUrl: 'https://images.unsplash.com/photo-1595435742656-5272d0b3e4b7',
      price: 2800,
      discountPrice: null,
      category: 'Protective Gear',
      brand: 'Adidas',
      inStock: true,
      stockQuantity: 20,
      rating: 4.7,
      reviewCount: 98,
      sizes: ['Small', 'Medium', 'Large', 'XL'],
      colors: ['White', 'Black', 'Blue'],
      images: [],
      material: 'Premium Leather',
      weight: '180g',
      isFeatured: true,
      isNewArrival: true,
    ),
    ShopItem(
      id: '6',
      shopId: '1',
      name: 'Puma Cricket Shoes',
      description: 'High-performance cricket shoes with excellent grip',
      imageUrl: 'https://images.unsplash.com/photo-1512719994953-eabf50895df7',
      price: 5500,
      discountPrice: 4900,
      category: 'Shoes',
      brand: 'Puma',
      inStock: true,
      stockQuantity: 18,
      rating: 4.6,
      reviewCount: 76,
      sizes: ['7', '8', '9', '10', '11'],
      colors: ['White', 'White/Blue'],
      images: [],
      material: 'Synthetic Leather',
      weight: '320g',
      isFeatured: false,
      isNewArrival: false,
    ),
  ];

  List<ShopItem> get _filteredItems {
    if (_selectedCategory == 'All') return _shopItems;
    return _shopItems
        .where((item) => item.category == _selectedCategory)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = ResponsiveHelper.getValue(
      context,
      mobile: double.infinity,
      tablet: 900,
      desktop: 1200,
    );

    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: CustomScrollView(
            slivers: [
              // App Bar with Image
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: Colors.white,
                foregroundColor: AppColors.textPrimary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.shop.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppColors.surfaceColor,
                          child: const Icon(
                            Icons.store,
                            size: 64,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.shop.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.shop.location,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Shop Info
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            widget.shop.rating.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' (${widget.shop.reviewCount} reviews)',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: widget.shop.isOpen
                                  ? AppColors.primaryGreen
                                  : AppColors.error,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.shop.isOpen ? 'Open Now' : 'Closed',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              Icons.access_time,
                              'Hours',
                              widget.shop.openingHours,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInfoCard(
                              Icons.phone,
                              'Phone',
                              widget.shop.phoneNumber,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              Icons.category,
                              'Category',
                              widget.shop.category,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInfoCard(
                              Icons.inventory,
                              'Items',
                              '${widget.shop.itemCount} products',
                            ),
                          ),
                        ],
                      ),
                      if (widget.shop.hasDelivery) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primaryGreen.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delivery_dining,
                                color: AppColors.primaryGreen,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Home Delivery Available',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryGreen,
                                      ),
                                    ),
                                    Text(
                                      'Delivery fee: ৳${widget.shop.deliveryFee}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      const Text(
                        'Specialties',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.shop.specialties.map((specialty) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.border.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              specialty,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              // Tabs
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primaryGreen,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primaryGreen,
                    tabs: const [
                      Tab(text: 'Products'),
                      Tab(text: 'About'),
                      Tab(text: 'Reviews'),
                    ],
                  ),
                ),
              ),
              // Tab Content
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildProductsTab(),
                    _buildAboutTab(),
                    _buildReviewsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primaryGreen),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    return Column(
      children: [
        // Category Filter
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip('All'),
                _buildCategoryChip('Bats'),
                _buildCategoryChip('Balls'),
                _buildCategoryChip('Protective Gear'),
                _buildCategoryChip('Shoes'),
              ],
            ),
          ),
        ),
        // Products Grid - Mobile optimized
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              return _buildProductCard(_filteredItems[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: AppColors.primaryGreen.withValues(alpha: 0.2),
        checkmarkColor: AppColors.primaryGreen,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 13,
        ),
        side: BorderSide(
          color: isSelected
              ? AppColors.primaryGreen
              : AppColors.border.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildProductCard(ShopItem item) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  item.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    color: AppColors.surfaceColor,
                    child: const Icon(
                      Icons.shopping_bag,
                      size: 40,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              if (item.hasDiscount)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '-${item.discountPercentage.toInt()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              if (item.isNewArrival)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.brand,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        item.rating.toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (item.hasDiscount) ...[
                        Text(
                          '৳${item.price.toInt()}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        '৳${item.finalPrice.toInt()}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: item.hasDiscount
                              ? AppColors.error
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAboutSection('Address', widget.shop.address, Icons.location_on),
          const SizedBox(height: 16),
          _buildAboutSection(
            'Phone Number',
            widget.shop.phoneNumber,
            Icons.phone,
          ),
          const SizedBox(height: 16),
          _buildAboutSection(
            'Opening Hours',
            widget.shop.openingHours,
            Icons.access_time,
          ),
          const SizedBox(height: 16),
          _buildAboutSection('Owner', widget.shop.ownerName, Icons.person),
          const SizedBox(height: 24),
          const Text(
            'Location',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.3),
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 48, color: AppColors.textSecondary),
                  SizedBox(height: 8),
                  Text(
                    'Map view would go here',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(String title, String content, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.primaryGreen),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (context, index) => const Divider(height: 24),
      itemBuilder: (context, index) {
        return _buildReviewCard(index);
      },
    );
  }

  Widget _buildReviewCard(int index) {
    final reviews = [
      {
        'name': 'Rahul Sharma',
        'rating': 5.0,
        'date': '2 days ago',
        'review':
            'Excellent shop with great quality products. The staff is very helpful and knowledgeable.',
      },
      {
        'name': 'Amit Kumar',
        'rating': 4.0,
        'date': '1 week ago',
        'review':
            'Good collection of cricket equipment. Prices are reasonable and delivery was fast.',
      },
      {
        'name': 'Priya Patel',
        'rating': 5.0,
        'date': '2 weeks ago',
        'review':
            'Best cricket shop in the area! Highly recommend for professional players.',
      },
      {
        'name': 'Vijay Singh',
        'rating': 4.0,
        'date': '3 weeks ago',
        'review':
            'Great variety of products. Found exactly what I was looking for.',
      },
      {
        'name': 'Suresh Reddy',
        'rating': 5.0,
        'date': '1 month ago',
        'review':
            'Professional service and authentic products. Will definitely visit again!',
      },
    ];

    final review = reviews[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.2),
              child: Text(
                review['name'].toString()[0],
                style: const TextStyle(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review['name'].toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    review['date'].toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  review['rating'].toString(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          review['review'].toString(),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

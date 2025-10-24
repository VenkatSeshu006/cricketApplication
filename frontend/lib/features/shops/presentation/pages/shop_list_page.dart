import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../domain/models/shop.dart';
import 'shop_detail_page.dart';

class ShopListPage extends StatefulWidget {
  const ShopListPage({super.key});

  @override
  State<ShopListPage> createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Dummy data for shops
  final List<Shop> _shops = [
    Shop(
      id: '1',
      name: 'Cricket Gear Pro',
      location: 'Gulshan, Dhaka',
      address: 'Plot 23, Road 11, Gulshan 1, Dhaka 1212',
      imageUrl: 'https://images.unsplash.com/photo-1624526267942-ab0ff8a3e972',
      rating: 4.8,
      reviewCount: 342,
      category: 'Cricket Equipment',
      specialties: ['Professional Bats', 'Protective Gear', 'Custom Orders'],
      isOpen: true,
      openingHours: '9:00 AM - 9:00 PM',
      phoneNumber: '+880 1711-123456',
      latitude: 23.7808,
      longitude: 90.4209,
      itemCount: 250,
      hasDelivery: true,
      deliveryFee: 50,
      ownerName: 'Rajesh Kumar',
    ),
    Shop(
      id: '2',
      name: 'Sports Arena',
      location: 'Dhanmondi, Dhaka',
      address: 'House 12, Road 8, Dhanmondi, Dhaka 1205',
      imageUrl: 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e',
      rating: 4.6,
      reviewCount: 278,
      category: 'Sportswear',
      specialties: ['Jerseys', 'Training Wear', 'Team Uniforms'],
      isOpen: true,
      openingHours: '10:00 AM - 8:00 PM',
      phoneNumber: '+880 1812-234567',
      latitude: 23.7461,
      longitude: 90.3742,
      itemCount: 180,
      hasDelivery: true,
      deliveryFee: 40,
      ownerName: 'Ahmed Hassan',
    ),
    Shop(
      id: '3',
      name: 'Champions Cricket Store',
      location: 'Banani, Dhaka',
      address: 'Block C, Road 15, Banani, Dhaka 1213',
      imageUrl: 'https://images.unsplash.com/photo-1531415074968-036ba1b575da',
      rating: 4.9,
      reviewCount: 521,
      category: 'Cricket Equipment',
      specialties: ['Premium Bats', 'Match Balls', 'Wicket Keeping Gear'],
      isOpen: true,
      openingHours: '9:00 AM - 10:00 PM',
      phoneNumber: '+880 1911-345678',
      latitude: 23.7937,
      longitude: 90.4066,
      itemCount: 320,
      hasDelivery: true,
      deliveryFee: 60,
      ownerName: 'Kamal Patel',
    ),
    Shop(
      id: '4',
      name: 'Striker Sports',
      location: 'Mirpur, Dhaka',
      address: 'Section 6, Mirpur, Dhaka 1216',
      imageUrl: 'https://images.unsplash.com/photo-1595435742656-5272d0b3e4b7',
      rating: 4.5,
      reviewCount: 198,
      category: 'Accessories',
      specialties: ['Cricket Shoes', 'Bags', 'Accessories'],
      isOpen: true,
      openingHours: '10:00 AM - 9:00 PM',
      phoneNumber: '+880 1611-456789',
      latitude: 23.8223,
      longitude: 90.3654,
      itemCount: 150,
      hasDelivery: true,
      deliveryFee: 45,
      ownerName: 'Sunil Sharma',
    ),
    Shop(
      id: '5',
      name: 'Elite Cricket Hub',
      location: 'Uttara, Dhaka',
      address: 'Sector 10, Uttara, Dhaka 1230',
      imageUrl: 'https://images.unsplash.com/photo-1589487391730-58f20eb2c308',
      rating: 4.7,
      reviewCount: 389,
      category: 'Cricket Equipment',
      specialties: ['International Brands', 'Expert Advice', 'Bat Repairs'],
      isOpen: false,
      openingHours: '10:00 AM - 9:00 PM',
      phoneNumber: '+880 1711-567890',
      latitude: 23.8759,
      longitude: 90.3795,
      itemCount: 280,
      hasDelivery: true,
      deliveryFee: 50,
      ownerName: 'Pradeep Singh',
    ),
    Shop(
      id: '6',
      name: 'Cricket Mania',
      location: 'Bashundhara, Dhaka',
      address: 'Block H, Bashundhara R/A, Dhaka 1229',
      imageUrl: 'https://images.unsplash.com/photo-1512719994953-eabf50895df7',
      rating: 4.8,
      reviewCount: 456,
      category: 'Sportswear',
      specialties: ['Custom Jerseys', 'Team Orders', 'Printing Services'],
      isOpen: true,
      openingHours: '9:00 AM - 10:00 PM',
      phoneNumber: '+880 1812-678901',
      latitude: 23.8223,
      longitude: 90.4292,
      itemCount: 200,
      hasDelivery: true,
      deliveryFee: 55,
      ownerName: 'Vikram Reddy',
    ),
    Shop(
      id: '7',
      name: 'Pro Sports Outlet',
      location: 'Mohakhali, Dhaka',
      address: 'Wireless Gate, Mohakhali, Dhaka 1212',
      imageUrl: 'https://images.unsplash.com/photo-1624526267942-ab0ff8a3e972',
      rating: 4.4,
      reviewCount: 167,
      category: 'Accessories',
      specialties: ['Cricket Balls', 'Practice Equipment', 'Training Aids'],
      isOpen: true,
      openingHours: '10:00 AM - 8:00 PM',
      phoneNumber: '+880 1911-789012',
      latitude: 23.7806,
      longitude: 90.4031,
      itemCount: 120,
      hasDelivery: false,
      deliveryFee: 0,
      ownerName: 'Nasir Ahmed',
    ),
    Shop(
      id: '8',
      name: 'Cricket World',
      location: 'Lalmatia, Dhaka',
      address: 'Block A, Lalmatia, Dhaka 1207',
      imageUrl: 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e',
      rating: 4.6,
      reviewCount: 234,
      category: 'Cricket Equipment',
      specialties: ['Affordable Gear', 'Beginner Equipment', 'Coaching Tools'],
      isOpen: true,
      openingHours: '9:00 AM - 9:00 PM',
      phoneNumber: '+880 1611-890123',
      latitude: 23.7503,
      longitude: 90.3709,
      itemCount: 175,
      hasDelivery: true,
      deliveryFee: 40,
      ownerName: 'Rizwan Ali',
    ),
  ];

  List<Shop> get _filteredShops {
    List<Shop> filtered = _shops;

    // Filter by category
    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((shop) => shop.category == _selectedFilter)
          .toList();
    }

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((shop) {
        return shop.name.toLowerCase().contains(query) ||
            shop.location.toLowerCase().contains(query) ||
            shop.specialties.any((s) => s.toLowerCase().contains(query));
      }).toList();
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
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
      appBar: AppBar(
        title: const Text(
          'Cricket Shops',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: AppColors.border.withValues(alpha: 0.3),
            height: 1,
          ),
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            children: [
              // Search and Filter Section
              Container(
                color: Colors.white,
                padding: ResponsiveHelper.getPagePadding(context),
                child: Column(
                  children: [
                    // Search Bar
                    TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search shops, items, or location...',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.primaryGreen,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.border.withValues(alpha: 0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.border.withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryGreen,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('All'),
                          _buildFilterChip('Cricket Equipment'),
                          _buildFilterChip('Sportswear'),
                          _buildFilterChip('Accessories'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Results Header
              Container(
                padding: ResponsiveHelper.getPagePadding(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_filteredShops.length} Shops Found',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.sort),
                      onSelected: (value) {
                        // Implement sorting
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'rating',
                          child: Text('Highest Rated'),
                        ),
                        const PopupMenuItem(
                          value: 'reviews',
                          child: Text('Most Reviews'),
                        ),
                        const PopupMenuItem(
                          value: 'name',
                          child: Text('Name (A-Z)'),
                        ),
                        const PopupMenuItem(
                          value: 'items',
                          child: Text('Most Items'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Shop List
              Expanded(
                child: _filteredShops.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: ResponsiveHelper.getPagePadding(context),
                        itemCount: _filteredShops.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildShopCard(_filteredShops[index]),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = label;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: AppColors.primaryGreen.withValues(alpha: 0.2),
        checkmarkColor: AppColors.primaryGreen,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected
              ? AppColors.primaryGreen
              : AppColors.border.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildShopCard(Shop shop) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShopDetailPage(shop: shop)),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    shop.imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 140,
                      color: AppColors.surfaceColor,
                      child: const Icon(
                        Icons.store,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: shop.isOpen
                          ? AppColors.primaryGreen
                          : AppColors.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      shop.isOpen ? 'OPEN' : 'CLOSED',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (shop.hasDelivery)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.delivery_dining,
                            size: 12,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Delivery',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            // Shop Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            shop.location,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          shop.rating.toString(),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          ' (${shop.reviewCount})',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${shop.itemCount} items',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: shop.specialties.take(2).map((specialty) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceColor,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.border.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            specialty,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_outlined,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No shops found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search or filters',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/* ================= COLOR PALETTE ================= */
class AppColors {
  static const pumpkin = Color(0xFFFD802E); // Orange
  static const charcoal = Color(0xFF233D4C);
  static const darkBg = Color(0xFF0A0A0A);
  static const cardBg = Color(0xFF1A1A1A);
  static const accent = Color(0xFFFF6B35); // Orange accent
  static const mintGreen = Color(0xFF4CAF50);
}

/* ================= APP ================= */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Order',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.darkBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkBg,
          foregroundColor: AppColors.pumpkin,
          elevation: 0,
        ),
      ),
      home: const MainPage(),
    );
  }
}

/* ================= MAIN PAGE ================= */
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final List<Map<String, dynamic>> cart = [];
  final List<Map<String, dynamic>> wishlist = [];
  final List<List<Map<String, dynamic>>> orderHistory = [];

  void addToCart(Map<String, dynamic> food) {
    setState(() {
      int index = cart.indexWhere((e) => e["name"] == food["name"]);
      if (index == -1) {
        cart.add({...food, "qty": 1});
      } else {
        cart[index]["qty"]++;
      }
    });
  }

  void removeFromCart(int index) {
    setState(() {
      cart.removeAt(index);
    });
  }

  void updateQuantity(int index, int change) {
    setState(() {
      cart[index]["qty"] += change;
      if (cart[index]["qty"] <= 0) {
        cart.removeAt(index);
      }
    });
  }

  void toggleWishlist(Map<String, dynamic> food) {
    setState(() {
      int index = wishlist.indexWhere((e) => e["name"] == food["name"]);
      if (index == -1) {
        wishlist.add(food);
      } else {
        wishlist.removeAt(index);
      }
    });
  }

  void checkout() {
    if (cart.isNotEmpty) {
      setState(() {
        orderHistory.add(List.from(cart));
        cart.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Order Placed Successfully! 🎉'),
          backgroundColor: AppColors.pumpkin,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        addToCart: addToCart,
        toggleWishlist: toggleWishlist,
        wishlist: wishlist,
      ),
      WishlistPage(
        wishlist: wishlist,
        addToCart: addToCart,
        toggleWishlist: toggleWishlist,
      ),
      CartPage(
        cart: cart,
        checkout: checkout,
        removeFromCart: removeFromCart,
        updateQuantity: updateQuantity,
      ),
      ProfilePage(orderHistory: orderHistory),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.cardBg,
        selectedItemColor: AppColors.pumpkin,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: "Wishlist"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_rounded), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profile"),
        ],
      ),
    );
  }
}

/* ================= HOME PAGE ================= */
class HomePage extends StatefulWidget {
  final Function(Map<String, dynamic>) addToCart;
  final Function(Map<String, dynamic>) toggleWishlist;
  final List<Map<String, dynamic>> wishlist;

  const HomePage({
    super.key,
    required this.addToCart,
    required this.toggleWishlist,
    required this.wishlist,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "All";

  final List<Map<String, dynamic>> categories = [
    {"name": "All", "icon": "🍽️", "color": AppColors.pumpkin},
    {"name": "Burgers", "icon": "🍔", "color": AppColors.pumpkin},
    {"name": "Pizza", "icon": "🍕", "color": AppColors.charcoal},
    {"name": "Healthy", "icon": "🥗", "color": AppColors.pumpkin}, // Fruit Bowl orange
    {"name": "Drinks", "icon": "🥤", "color": AppColors.accent},
  ];

  final List<Map<String, dynamic>> foodList = [
    {
      "name": "Veg Burger",
      "price": 120,
      "category": "Burgers",
      "image": "https://images.unsplash.com/photo-1550547660-d9450f859349",
      "accentColor": AppColors.pumpkin,
      "rating": 4.5,
    },
    {
      "name": "Veg Pizza",
      "price": 250,
      "category": "Pizza",
      "image": "https://images.unsplash.com/photo-1594007654729-407eedc4be65",
      "accentColor": AppColors.charcoal,
      "rating": 4.8,
    },
    {
      "name": "Sandwich",
      "price": 100,
      "category": "Burgers",
      "image": "https://images.unsplash.com/photo-1528735602780-2552fd46c7af",
      "accentColor": AppColors.accent,
      "rating": 4.2,
    },
    {
      "name": "Fruit Bowl",
      "price": 150,
      "category": "Healthy",
      "image": "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",
      "accentColor": AppColors.pumpkin, // changed to orange
      "rating": 4.7,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFood = selectedCategory == "All"
        ? foodList
        : foodList.where((f) => f["category"] == selectedCategory).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "Food Menu",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = selectedCategory == cat["name"];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedCategory = cat["name"]),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? cat["color"] : AppColors.cardBg,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected ? cat["color"] : Colors.grey.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(cat["icon"], style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 6),
                            Text(
                              cat["name"],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final food = filteredFood[index];
                  final isFav = widget.wishlist.any((e) => e["name"] == food["name"]);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (food["accentColor"] as Color).withOpacity(0.15),
                          AppColors.cardBg,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (food["accentColor"] as Color).withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              child: Image.network(
                                food["image"],
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: GestureDetector(
                                onTap: () => widget.toggleWishlist(food),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    color: isFav ? Colors.red : Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                food["name"],
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton(
                                onPressed: () => widget.addToCart(food),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: food["accentColor"],
                                ),
                                child: const Text("ADD"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: filteredFood.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= WISHLIST PAGE ================= */
class WishlistPage extends StatelessWidget {
  final List<Map<String, dynamic>> wishlist;
  final Function(Map<String, dynamic>) addToCart;
  final Function(Map<String, dynamic>) toggleWishlist;

  const WishlistPage({
    super.key,
    required this.wishlist,
    required this.addToCart,
    required this.toggleWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist"), centerTitle: true),
      body: wishlist.isEmpty
          ? Center(child: Text("No items in wishlist", style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                final item = wishlist[index];
                return ListTile(
                  leading: Image.network(item["image"], width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(item["name"], style: const TextStyle(color: Colors.white)),
                  trailing: ElevatedButton(
                    onPressed: () => addToCart(item),
                    style: ElevatedButton.styleFrom(backgroundColor: item["accentColor"]),
                    child: const Text("Add"),
                  ),
                );
              },
            ),
    );
  }
}

/* ================= CART PAGE ================= */
class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final VoidCallback checkout;
  final Function(int) removeFromCart;
  final Function(int, int) updateQuantity;

  const CartPage({
    super.key,
    required this.cart,
    required this.checkout,
    required this.removeFromCart,
    required this.updateQuantity,
  });

  @override
  Widget build(BuildContext context) {
    int total = 0;
    for (var item in cart) total += (item["price"] as int) * (item["qty"] as int);

    return Scaffold(
      appBar: AppBar(title: const Text("Cart"), centerTitle: true),
      body: cart.isEmpty
          ? Center(child: Text("Cart is empty", style: TextStyle(color: Colors.grey)))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return ListTile(
                        leading: Image.network(item["image"], width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(item["name"], style: const TextStyle(color: Colors.white)),
                        subtitle: Text("Qty: ${item["qty"]} | ₹${item["price"]}", style: TextStyle(color: item["accentColor"])),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeFromCart(index),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total", style: TextStyle(color: Colors.white, fontSize: 18)),
                      Text("₹ $total", style: const TextStyle(color: AppColors.pumpkin, fontSize: 18)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ElevatedButton(
                    onPressed: checkout,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.pumpkin),
                    child: const Text("PLACE ORDER"),
                  ),
                ),
              ],
            ),
    );
  }
}

/* ================= PROFILE PAGE ================= */
class ProfilePage extends StatelessWidget {
  final List<List<Map<String, dynamic>>> orderHistory;
  const ProfilePage({super.key, required this.orderHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile header with gradient
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.pumpkin.withValues(alpha: 0.3), AppColors.cardBg],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.pumpkin.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.pumpkin,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.pumpkin.withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Sangeetha",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "sangeetha@gmail.com",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Address Section
            _buildSection(
              title: "Address",
              icon: Icons.location_on,
              color: AppColors.charcoal,
              child: const Text(
                "No:10, Anna Nagar,\nChennai - 600028",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            const SizedBox(height: 16),

            // Payment Details Section (ORANGE NOW)
            _buildSection(
              title: "Payment Details",
              icon: Icons.credit_card,
              color: AppColors.pumpkin, // ← CHANGED from mintGreen to pumpkin
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.pumpkin.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.credit_card, color: AppColors.pumpkin),
                ),
                title: const Text(
                  "**** **** **** 1234",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  "Visa Card",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.pumpkin),
                  onPressed: () {},
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Order History Section
            _buildSection(
              title: "Order History",
              icon: Icons.history,
              color: AppColors.accent,
              child: orderHistory.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "No orders yet",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orderHistory.length,
                      itemBuilder: (context, index) {
                        final order = orderHistory[index];
                        int orderTotal = 0;
                        for (var item in order) {
                          orderTotal +=
                              (item["price"] as int) * (item["qty"] as int);
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.darkBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.accent.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Order #${index + 1}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${order.length} items",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "₹ $orderTotal",
                                style: const TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.15), AppColors.cardBg],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}


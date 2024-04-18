import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lzzt/providers/app_provider.dart';

class BottomBarWidget extends ConsumerWidget {
  const BottomBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sepet sayısını izlemek için provider'ı izleyin
    final basketCount = ref.watch(basketNotifierProvider);

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Keşfet',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.fastfood_outlined),
          label: 'Siparişler',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              const Icon(Icons.shopping_cart),
              // Sepet sayısı sıfırdan büyükse CircleAvatar göster
              if (basketCount > 0)
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      basketCount.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          label: 'Sepet',
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        actions: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 16.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(color: Colors.grey, width: 2),
              ),
              image: DecorationImage(
                image: NetworkImage(
                  'https://avatars.githubusercontent.com/u/57899010?v=4',
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Store Name',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          // description
          const SizedBox(height: 8.0),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam eget nunc nec nunc tincidunt ultricies. Donec nec nunc nec nunc tincidunt ultricies. Donec nec nunc nec nunc tincidunt ultricies. Donec nec nunc nec nunc tincidunt ultricies.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Informasi Lokasi
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, size: 20.0),
                  const SizedBox(height: 4.0),
                  Text(
                    'Jl. Lorem Ipsum',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              // Informasi Jam Operasional
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time, size: 20.0),
                  const SizedBox(height: 4.0),
                  Text(
                    '09:00 - 21:00',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              // Informasi Telepon
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.phone, size: 20.0),
                  const SizedBox(height: 4.0),
                  Text(
                    '+62 123 456',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Divider(),
          const SizedBox(height: 16.0),
          Text(
            'Menu',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8.0),
          // Menu
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text('Menu Name'),
                subtitle: Text('Rp 10.000'),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

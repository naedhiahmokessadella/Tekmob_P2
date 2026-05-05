import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil & To-Do',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MainNavigation(),
    );
  }
}

// NAVIGASI UTAMA (BottomNavigationBar)

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // FIX: nama class konsisten → TodoPage (bukan ToDoPage)
  final List<Widget> _pages = const [
    ProfilePage(),
    TodoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'To-Do',
          ),
        ],
      ),
    );
  }
}

// HALAMAN 1 — STATELESS PAGE (Profil)

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),

            // 1. CircleAvatar — foto profil
            CircleAvatar(
              radius: 60,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 70,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: 16),

            // 2. Text — nama
            Text(
              'Naedhiah Mokessa Della',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 4),

            // 3. Text — jurusan
            Text(
              'Sistem Informasi — Semester 4',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 8),

            // 4. Row — ikon lokasi + teks
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on,
                    size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 4),
                Text(
                  'Yogyakarta, Indonesia',
                  style:
                      TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 5. Divider
            const Divider(),

            const SizedBox(height: 16),

            // 6. Container — bio
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tentang Saya',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mahasiswa aktif prodi Sistem Informasi yang belajar '
                    'tentang bidang mobile development dan analisis data. '
                    'Disini saya coba-coba buat aplikasi sederhana untuk latihan flutter, '
                    'saya memilih membuat to-do list tugas kuliah sederhana ala saya ',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// MODEL DATA TUGAS

class TodoItem {
  final String id;
  String title;
  String matkul;
  String deadline;
  bool isDone;

  TodoItem({
    required this.id,
    required this.title,
    required this.matkul,
    required this.deadline,
    this.isDone = false,
  });
}

// HALAMAN 2 — STATEFUL PAGE (To-Do List)
// FIX: nama class diseragamkan → TodoPage & _TodoPageState

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  // State data tugas
  final List<TodoItem> _todos = [
    TodoItem(
      id: '1',
      title: 'Tugas flutter',
      matkul: 'Tekmob',
      deadline: '6 Mei 2026',
    ),
    TodoItem(
      id: '2',
      title: 'Laprak',
      matkul: 'KSI',
      deadline: '6 Mei 2026',
      isDone: true,
    ),
    TodoItem(
      id: '3',
      title: 'Kalimat pasif',
      matkul: 'Bahasa Indonesia',
      deadline: '5 Mei 2026',
    ),
    TodoItem(
      id: '4',
      title: 'Observasi',
      matkul: 'RDPP',
      deadline: '9 Mei 2026',
      isDone: true,
    ),
  ];

  String _filterStatus = 'Semua'; // Semua, Belum, Selesai

  // controller untuk dialog tambah tugas
  final _titleCtrl = TextEditingController();
  final _matkulCtrl = TextEditingController();
  final _deadlineCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _matkulCtrl.dispose();
    _deadlineCtrl.dispose();
    super.dispose();
  }

  // Toggle selesai
  void _toggleDone(String id) {
    setState(() {
      final todo = _todos.firstWhere((t) => t.id == id);
      todo.isDone = !todo.isDone;
    });
  }

  // Hapus tugas
  void _deleteTodo(String id) {
    setState(() {
      _todos.removeWhere((t) => t.id == id);
    });
  }

  // Tambah tugas baru
  void _addTodo() {
    if (_titleCtrl.text.trim().isEmpty) return;

    setState(() {
      _todos.add(TodoItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleCtrl.text.trim(),
        matkul: _matkulCtrl.text.trim().isEmpty
            ? 'Umum'
            : _matkulCtrl.text.trim(),
        deadline: _deadlineCtrl.text.trim().isEmpty
            ? '-'
            : _deadlineCtrl.text.trim(),
      ));
    });

    _titleCtrl.clear();
    _matkulCtrl.clear();
    _deadlineCtrl.clear();
  }

  // Dialog tambah tugas
  void _showAddDialog() {
    _titleCtrl.clear();
    _matkulCtrl.clear();
    _deadlineCtrl.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final theme = Theme.of(ctx);
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul modal
                  Text(
                    'Tambah Tugas Baru',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // TextField — judul tugas
                  TextField(
                    controller: _titleCtrl,
                    decoration: InputDecoration(
                      labelText: 'Nama Tugas',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // TextField — mata kuliah
                  TextField(
                    controller: _matkulCtrl,
                    decoration: InputDecoration(
                      labelText: 'Mata Kuliah',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // TextField — deadline
                  TextField(
                    controller: _deadlineCtrl,
                    decoration: InputDecoration(
                      labelText: 'Deadline',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol simpan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _addTodo();
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      label: const Text(
                        'Simpan Tugas',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Filter list tugas
  List<TodoItem> get _filteredTodos {
    if (_filterStatus == 'Belum') {
      return _todos.where((t) => !t.isDone).toList();
    } else if (_filterStatus == 'Selesai') {
      return _todos.where((t) => t.isDone).toList();
    }
    return _todos;
  }

  // Warna avatar berdasarkan inisial matkul
  Color _avatarColor(BuildContext context, bool isDone) {
    final theme = Theme.of(context);
    return isDone
        ? theme.colorScheme.outline.withOpacity(0.4)
        : theme.colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final done = _todos.where((t) => t.isDone).length;
    final total = _todos.length;
    final progress = total == 0 ? 0.0 : done / total;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('To-Do List Tugas'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),

      // tambah tugas
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Tugas'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          // Header progress
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20), // border radius
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row — ringkasa
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Column di dalam Row
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Progress Tugas',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          '$done dari $total tugas selesai',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer
                                .withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),

                    // Container persentase
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // LinearProgressIndicator
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor:
                        theme.colorScheme.primary.withOpacity(0.2),
                    valueColor:
                        AlwaysStoppedAnimation(theme.colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),

          // Filter chip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['Semua', 'Belum', 'Selesai'].map((label) {
                final isActive = _filterStatus == label;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: isActive,
                    onSelected: (_) {
                      setState(() => _filterStatus = label);
                    },
                    selectedColor: theme.colorScheme.primaryContainer,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Daftar tugas
          Expanded(
            child: _filteredTodos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 60,
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.3),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tidak ada tugas',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                    itemCount: _filteredTodos.length,
                    itemBuilder: (ctx, i) {
                      final todo = _filteredTodos[i];

                      // Dismissible
                      return Dismissible(
                        key: Key(todo.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => _deleteTodo(todo.id),
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete,
                              color: Colors.white, size: 28),
                        ),

                        // Card — item tugas
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16), // border radius
                            side: BorderSide(
                              color: todo.isDone
                                  ? theme.colorScheme.outline.withOpacity(0.2)
                                  : theme.colorScheme.outline.withOpacity(0.5),
                            ),
                          ),
                          color: todo.isDone
                              ? theme.colorScheme.surfaceContainerHighest
                              : theme.colorScheme.surface,

                          child: Padding(
                            padding: const EdgeInsets.all(12), // paddin
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                // AVATAR
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor:
                                      _avatarColor(context, todo.isDone),
                                  child: Icon(
                                    todo.isDone
                                        ? Icons.check
                                        : Icons.assignment_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // TEKS (Expanded)
                                Expanded(
                                  child: Column( // Column
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      // Judul tugas
                                      Text(
                                        todo.title,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          decoration: todo.isDone
                                              ? TextDecoration.lineThrough
                                              : null,
                                          color: todo.isDone
                                              ? theme.colorScheme
                                                  .onSurfaceVariant
                                              : theme.colorScheme.onSurface,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      // Deskripsi: matkul & deadline
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.school,
                                            size: 13,
                                            color: theme.colorScheme
                                                .onSurfaceVariant,
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible( // Flexible
                                            child: Text(
                                              todo.matkul,
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                color: theme.colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Icon(
                                            Icons.schedule,
                                            size: 13,
                                            color: theme.colorScheme
                                                .onSurfaceVariant,
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible( // Flexible
                                            child: Text(
                                              todo.deadline,
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                color: theme.colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // AKSI: Checkbox + Hapus
                                Column(
                                  children: [
                                    // Checkbox — toggle selesai
                                    Checkbox(
                                      value: todo.isDone,
                                      onChanged: (_) => _toggleDone(todo.id),
                                      activeColor: theme.colorScheme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    // IconButton — hapus
                                    IconButton(
                                      icon: const Icon(
                                          Icons.delete_outline,
                                          size: 20),
                                      color: theme.colorScheme.onSurfaceVariant,
                                      onPressed: () => _deleteTodo(todo.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
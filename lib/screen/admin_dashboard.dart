import 'package:flutter/material.dart';
import '../component /app_colors.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  String _category = 'Beginner';
  final List<String> _categories = ['Beginner', 'Intermediate', 'Advanced'];

  // Video Upload State
  bool _isYoutubeMode = true;
  String? _selectedFileName;

  // Mock User Data for management
  final List<Map<String, String>> _users = [
    {"name": "Alice Smith", "email": "alice@example.com", "plan": "Beginner", "status": "Active"},
    {"name": "Bob Johnson", "email": "bob@example.com", "plan": "Advanced", "status": "Error"},
    {"name": "Charlie Brown", "email": "charlie@example.com", "plan": "Intermediate", "status": "Active"},
  ];

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
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text("Admin Master Panel", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.sharpPink,
          labelColor: AppColors.sharpPink,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard_outlined), text: "Overview"),
            Tab(icon: Icon(Icons.cloud_upload_outlined), text: "Upload"),
            Tab(icon: Icon(Icons.manage_accounts_outlined), text: "Users"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildUploadTab(),
          _buildUserManagementTab(),
        ],
      ),
    );
  }

  // --- TAB 1: OVERVIEW ---
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildStatsCard("Total Users", "1,248", Icons.people, AppColors.sharpPink),
          const SizedBox(height: 16),
          _buildStatsCard("Total Revenue", "\$4,850", Icons.monetization_on, Colors.green),
          const SizedBox(height: 16),
          _buildStatsCard("Active Sessions", "84", Icons.bolt, Colors.amber),
        ],
      ),
    );
  }

  // --- TAB 2: UPLOAD CONTENT ---
  Widget _buildUploadTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Upload Tutorial", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.navy)),
              const SizedBox(height: 20),
              _buildAdminTextField("Video Title", Icons.title),
              const SizedBox(height: 16),
              _buildCategoryDropdown(),
              const SizedBox(height: 16),
              _buildAdminTextField("Cost (\$)", Icons.attach_money, isNumber: true),
              const SizedBox(height: 24),

              const Text("Select Source", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text("YouTube Link")),
                      selected: _isYoutubeMode,
                      onSelected: (val) => setState(() => _isYoutubeMode = true),
                      selectedColor: AppColors.sharpPink.withOpacity(0.2),
                      labelStyle: TextStyle(color: _isYoutubeMode ? AppColors.sharpPink : AppColors.textLight),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text("Desktop File")),
                      selected: !_isYoutubeMode,
                      onSelected: (val) => setState(() => _isYoutubeMode = false),
                      selectedColor: AppColors.sharpPink.withOpacity(0.2),
                      labelStyle: TextStyle(color: !_isYoutubeMode ? AppColors.sharpPink : AppColors.textLight),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (_isYoutubeMode)
                _buildAdminTextField("Video URL (YouTube)", Icons.link)
              else
                _buildFilePickerUI(),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.sharpPink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (!_isYoutubeMode && _selectedFileName == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a file")));
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Video Published!")));
                    }
                  },
                  child: const Text("Publish Video", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilePickerUI() {
    return InkWell(
      onTap: () {
        // Mock file selection logic
        setState(() => _selectedFileName = "facial_massage_intro.mp4");
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Icon(Icons.cloud_upload_outlined, color: AppColors.sharpPink, size: 40),
            const SizedBox(height: 12),
            Text(
              _selectedFileName ?? "Click to upload from desktop",
              style: TextStyle(color: _selectedFileName != null ? AppColors.navy : AppColors.textLight, fontWeight: _selectedFileName != null ? FontWeight.bold : FontWeight.normal),
            ),
            if (_selectedFileName != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text("Size: 42.5 MB", style: TextStyle(color: AppColors.textLight, fontSize: 12)),
              ),
          ],
        ),
      ),
    );
  }

  // --- TAB 3: USER MANAGEMENT ---
  Widget _buildUserManagementTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        bool hasError = user['status'] == 'Error';
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: hasError ? Colors.red.shade100 : AppColors.accentPink,
              child: Icon(Icons.person, color: hasError ? Colors.red : AppColors.sharpPink),
            ),
            title: Text(user['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${user['email']}\nPlan: ${user['plan']}"),
            isThreeLine: true,
            trailing: PopupMenuButton<String>(
              onSelected: (value) => _handleUserAction(value, index),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'switch', child: Text("Switch Plan")),
                const PopupMenuItem(value: 'fix', child: Text("Fix Account Error")),
                const PopupMenuItem(value: 'delete', child: Text("Remove User", style: TextStyle(color: Colors.red))),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Helper Methods ---

  void _handleUserAction(String action, int index) {
    if (action == 'switch') {
      _showSwitchPlanDialog(index);
    } else if (action == 'fix') {
      setState(() => _users[index]['status'] = 'Active');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account Restored")));
    }
  }

  void _showSwitchPlanDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Switch Plan for ${_users[index]['name']}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _categories.map((c) => ListTile(
            title: Text(c),
            onTap: () {
              setState(() => _users[index]['plan'] = c);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildStatsCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white24)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          ]),
        ],
      ),
    );
  }

  Widget _buildAdminTextField(String label, IconData icon, {bool isNumber = false}) {
    return TextFormField(
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.textLight),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
      validator: (val) => val!.isEmpty ? "Required" : null,
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _category,
      decoration: InputDecoration(
        labelText: "Category",
        prefixIcon: const Icon(Icons.category_outlined, color: AppColors.textLight),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
      items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
      onChanged: (val) => setState(() => _category = val!),
    );
  }
}
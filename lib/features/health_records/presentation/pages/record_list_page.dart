import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthmate/core/theme/app_theme.dart';
import 'package:healthmate/data/models/health_record.dart';
import 'package:healthmate/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:healthmate/features/health_records/presentation/pages/add_record_page.dart';
import 'package:healthmate/features/health_records/presentation/providers/health_record_provider.dart';
import 'package:healthmate/features/reports/presentation/pages/generate_report_page.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class RecordListPage extends StatefulWidget {
  const RecordListPage({super.key});

  @override
  State<RecordListPage> createState() => _RecordListPageState();
}

class _RecordListPageState extends State<RecordListPage> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  int _currentIndex = 1; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HealthRecordProvider>(context, listen: false).loadRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Health Records',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.assessment, color: AppTheme.primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GenerateReportPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<HealthRecordProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              
              _buildSearchBar(provider),
              
             
              if (provider.records.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        '${provider.records.length} record${provider.records.length == 1 ? '' : 's'} found',
                        style: GoogleFonts.inter(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              
              
              Expanded(
                child: provider.records.isEmpty
                    ? _buildEmptyState(provider)
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.records.length,
                        itemBuilder: (context, index) {
                          final record = provider.records[index];
                          return _buildRecordCard(record, context, provider);
                        },
                      ),
              ),
            ],
          );
        },
      ),

      
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: AppTheme.backgroundLight,
        color: AppTheme.primaryColor,
        animationDuration: const Duration(milliseconds: 300),
        index: _currentIndex,
        items: const [
          Icon(Icons.dashboard, color: Colors.white, size: 30),
          Icon(Icons.list, color: Colors.white, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
              (route) => false,
            );
          }
          
        },
      ),

      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddRecordPage(),
            ),
          ).then((_) {
            
            Provider.of<HealthRecordProvider>(context, listen: false).loadRecords();
          });
        },
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildSearchBar(HealthRecordProvider provider) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.textLight.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: AppTheme.textLight,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by date (e.g., 2024-01, Jan, January, 15)',
                hintStyle: GoogleFonts.inter(
                  color: AppTheme.textLight,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: GoogleFonts.inter(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _performSearch(value, provider);
                  setState(() {
                    _isSearching = true;
                  });
                } else {
                  provider.clearSearch();
                  setState(() {
                    _isSearching = false;
                  });
                }
              },
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.clear_rounded,
                color: AppTheme.textLight,
                size: 20,
              ),
              onPressed: () => _clearSearch(provider),
            ),
        ],
      ),
    );
  }

  void _performSearch(String searchText, HealthRecordProvider provider) {
    
    final searchTextLower = searchText.toLowerCase();
    
    
    if (RegExp(r'^\d{4}-\d{2}$').hasMatch(searchText)) {
      provider.searchByDatePattern(searchText); // Search for records starting with this pattern
      return;
    }
    
   
    if (RegExp(r'^\d{4}$').hasMatch(searchText)) {
      provider.searchByDatePattern(searchText);
      return;
    }
    
    
    final monthPattern = _getMonthPattern(searchTextLower);
    if (monthPattern != null) {
      provider.searchByDatePattern(monthPattern);
      return;
    }
    
    
    if (RegExp(r'^\d{1,2}$').hasMatch(searchText)) {
      final day = int.tryParse(searchText);
      if (day != null) {
        provider.searchByDay(day);
        return;
      }
    }
    
   
    provider.searchByDate(searchText);
  }

  String? _getMonthPattern(String monthText) {
    const monthMap = {
      'jan': '-01-',
      'january': '-01-',
      'feb': '-02-',
      'february': '-02-',
      'mar': '-03-',
      'march': '-03-',
      'apr': '-04-',
      'april': '-04-',
      'may': '-05-',
      'jun': '-06-',
      'june': '-06-',
      'jul': '-07-',
      'july': '-07-',
      'aug': '-08-',
      'august': '-08-',
      'sep': '-09-',
      'september': '-09-',
      'oct': '-10-',
      'october': '-10-',
      'nov': '-11-',
      'november': '-11-',
      'dec': '-12-',
      'december': '-12-',
    };
    
    return monthMap[monthText];
  }

  Widget _buildRecordCard(HealthRecord record, BuildContext context, HealthRecordProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.textLight.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(record.date),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: AppTheme.textLight,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddRecordPage(record: record),
                        ),
                      ).then((_) {
                        
                        provider.loadRecords();
                      });
                    } else if (value == 'delete') {
                      _showDeleteDialog(record, context, provider);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_rounded, color: AppTheme.primaryColor, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Edit',
                            style: GoogleFonts.inter(
                              color: AppTheme.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_rounded, color: AppTheme.caloriesColor, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: GoogleFonts.inter(
                              color: AppTheme.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
           
            Row(
              children: [
                _buildMetricItem(
                  'Steps',
                  record.steps.toString(),
                  Icons.directions_walk_rounded,
                  AppTheme.stepsColor,
                ),
                const SizedBox(width: 12),
                _buildMetricItem(
                  'Calories',
                  record.calories.toString(),
                  Icons.local_fire_department_rounded,
                  AppTheme.caloriesColor,
                ),
                const SizedBox(width: 12),
                _buildMetricItem(
                  'Water',
                  '${(record.water / 1000).toStringAsFixed(1)}L',
                  Icons.water_drop_rounded,
                  AppTheme.waterColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(HealthRecordProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.assignment_rounded,
          size: 80,
          color: AppTheme.textLight.withOpacity(0.5),
        ),
        const SizedBox(height: 16),
        Text(
          'No Records Found',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            _isSearching
                ? 'Try adjusting your search criteria'
                : 'Start by adding your first health record',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (!_isSearching)
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddRecordPage(),
                ),
              ).then((_) {
              
                provider.loadRecords();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Add First Record',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  void _showDeleteDialog(HealthRecord record, BuildContext context, HealthRecordProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Record',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete the record for ${_formatDate(record.date)}?',
          style: GoogleFonts.inter(),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              provider.deleteRecord(record.id!);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.caloriesColor,
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return _isToday(date) ? 'Today' : 
             _isYesterday(date) ? 'Yesterday' : 
             DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && 
           date.month == yesterday.month && 
           date.day == yesterday.day;
  }

  void _clearSearch(HealthRecordProvider provider) {
    _searchController.clear();
    provider.clearSearch();
    setState(() {
      _isSearching = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
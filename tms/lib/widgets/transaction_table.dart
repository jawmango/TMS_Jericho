import 'package:flutter/material.dart';
import 'package:tms/models/transaction.dart';
import 'package:tms/utils/styles.dart';
import 'package:tms/utils/helpers.dart';

class TransactionTable extends StatefulWidget {
  final Future<List<Transaction>> futureTransaction;
  const TransactionTable({super.key, required this.futureTransaction});

  @override
  State<TransactionTable> createState() => _TransactionTableState();
}

//table header
Widget _buildHeader(){
  return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: AppStyles.secondaryColor.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              border: Border(
                bottom: BorderSide(color: AppStyles.primaryColor.shade300, width: 1),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Transaction Management System',
                  style: TextStyle(
                    fontSize: AppStyles.largeFontSize,
                    fontWeight: FontWeight.w600,
                    color: AppStyles.primaryColor.shade700,
                  ),
                ),
              ],
            ),
          );
}

//status component
Widget _buildStatusChip(String status) {
  final color = AppHelpers.statusColor(status);
  final icon = AppHelpers.statusIcon(status);

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: status=='Pending'?Colors.orange.withOpacity(0.3):color.withOpacity(0.3), width: 1),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: status=='Pending'?Colors.orange:color),
        const SizedBox(width: 4),
        Text(
          status,
          style: TextStyle(
            color: status=='Pending'?Colors.orange:color,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

class _TransactionTableState extends State<TransactionTable>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentPage = 0;
  int _rowsPerPage = 10;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    //initialize tab controller
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentPage = 0;
        switch (_tabController.index) {
          case 0:
            _selectedFilter = 'all';
            break;
          case 1:
            _selectedFilter = 'pending';
            break;
          case 2:
            _selectedFilter = 'settled';
            break;
          case 3:
            _selectedFilter = 'failed';
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //returns transaction data of selected filter
  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    if (_selectedFilter == 'all') {
      return transactions;
    }
    return transactions
        .where(
          (transaction) =>
              transaction.status.toLowerCase() == _selectedFilter.toLowerCase(),
        )
        .toList();
  }

  //paginated list of transactions
  List<Transaction> _paginateTransactions(List<Transaction> transactions) {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage).clamp(0, transactions.length);
    return transactions.sublist(startIndex, endIndex);
  }

  //returns length of filtered data for pagination
  int _getFilteredCount(List<Transaction> allTransactions, String filter) {
    if (filter == 'all') return allTransactions.length;
    return allTransactions
        .where((t) => t.status.toLowerCase() == filter.toLowerCase())
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.defaultBorderRadius,
        border: Border.all(color: AppStyles.primaryColor.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          // tab bar
          FutureBuilder<List<Transaction>>(
            future: widget.futureTransaction,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppStyles.primaryColor.shade300, width: 1),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: AppStyles.secondaryColor.shade600,
                    unselectedLabelColor: AppStyles.primaryColor.shade600,
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    indicatorColor: AppStyles.secondaryColor.shade600,
                    indicatorWeight: 2,
                    tabs: const [
                      Tab(text: 'All Transactions'),
                      Tab(text: 'Pending'),
                      Tab(text: 'Settled'),
                      Tab(text: 'Failed'),
                    ],
                  ),
                );
              }

              final allTransactions = snapshot.data!;
              final allCount = allTransactions.length;
              final pendingCount = _getFilteredCount(
                allTransactions,
                'pending',
              );
              final settledCount = _getFilteredCount(
                allTransactions,
                'settled',
              );
              final failedCount = _getFilteredCount(allTransactions, 'failed');

              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppStyles.primaryColor.shade300, width: 1),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: AppStyles.secondaryColor.shade600,
                  unselectedLabelColor: AppStyles.primaryColor.shade600,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  indicatorColor: AppStyles.secondaryColor.shade600,
                  indicatorWeight: 2,
                  tabs: [
                    Tab(text: 'All Transactions ($allCount)'),
                    Tab(text: 'Pending ($pendingCount)'),
                    Tab(text: 'Settled ($settledCount)'),
                    Tab(text: 'Failed ($failedCount)'),
                  ],
                ),
              );
            },
          ),

          // table content
          Expanded(
            child: FutureBuilder<List<Transaction>>(
              future: widget.futureTransaction,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Transaction> allTransactions = snapshot.data!.reversed
                      .toList();
                  List<Transaction> filteredTransactions = _filterTransactions(
                    allTransactions,
                  );
                  List<Transaction> paginatedTransactions =
                      _paginateTransactions(filteredTransactions);

                  final totalPages =
                      (filteredTransactions.length / _rowsPerPage).ceil();
                  final startIndex = _currentPage * _rowsPerPage + 1;
                  final endIndex = ((_currentPage + 1) * _rowsPerPage).clamp(
                    0,
                    filteredTransactions.length,
                  );

                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: SizedBox(
                            width: double.infinity,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dataTableTheme: DataTableThemeData(
                                  headingRowColor: WidgetStateProperty.all(
                                    AppStyles.secondaryColor.shade50,
                                  ),
                                  dataRowColor:
                                      WidgetStateProperty.resolveWith<Color?>((
                                        Set<WidgetState> states,
                                      ) {
                                        return Colors.white;
                                      }),
                                  dividerThickness: 1,
                                  horizontalMargin: 16,
                                  columnSpacing: 20,
                                  headingTextStyle: TextStyle(
                                    color: AppStyles.primaryColor.shade700,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  dataTextStyle: TextStyle(
                                    color: AppStyles.primaryColor.shade800,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              child: DataTable(
                                showBottomBorder: true,
                                columnSpacing: 20,
                                columns: [
                                  DataColumn(
                                    label: SizedBox(
                                      width: 120,
                                      child: Text('Transaction Date'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: 120,
                                      child: Text('Account Number'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: 150,
                                      child: Text('Account Holder Name'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: 100,
                                      child: Text('Amount'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: 80,
                                      child: Text('Status'),
                                    ),
                                  ),
                                ],
                                rows: paginatedTransactions.map<DataRow>((
                                  transaction,
                                ) {
                                  return DataRow(
                                    color:
                                        WidgetStateProperty.resolveWith<Color?>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                              WidgetState.hovered,
                                            )) {
                                              return AppStyles.primaryColor.shade50;
                                            }
                                            return Colors.white;
                                          },
                                        ),
                                    cells: [
                                      DataCell(
                                        SizedBox(
                                          width: 120,
                                          child: Text(
                                            transaction.transactionDate,
                                            style: AppStyles.dataRowTextStyle,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 120,
                                          child: Text(
                                            transaction.accountNumber,
                                            style: AppStyles.dataRowTextStyle,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            transaction.accountName,
                                            style: AppStyles.dataRowTextStyle,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            AppHelpers.formatCurrency(transaction.amount),
                                            style: AppStyles.dataRowTextStyle,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 80,
                                          child: _buildStatusChip(
                                            transaction.status,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // pagination bar
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: AppStyles.primaryColor.shade300,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton<int>(
                              value: _rowsPerPage,
                              underline: Container(),
                              style: TextStyle(
                                color: AppStyles.primaryColor.shade600,
                                fontSize: 14,
                              ),
                              items: [5, 10, 25, 50].map((value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('Rows per page: $value'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _rowsPerPage = value!;
                                  _currentPage = 0;
                                });
                              },
                            ),
                            Row(
                              children: [
                                Text(
                                  filteredTransactions.isEmpty
                                      ? '0 of 0'
                                      : '$startIndex-$endIndex of ${filteredTransactions.length}',
                                  style: TextStyle(
                                    color: AppStyles.primaryColor.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                IconButton(
                                  onPressed: _currentPage > 0
                                      ? () {
                                          setState(() {
                                            _currentPage--;
                                          });
                                        }
                                      : null,
                                  icon: Icon(
                                    Icons.chevron_left,
                                    color: _currentPage > 0
                                        ? AppStyles.primaryColor.shade600
                                        : AppStyles.primaryColor.shade400,
                                    size: 20,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _currentPage < totalPages - 1
                                      ? () {
                                          setState(() {
                                            _currentPage++;
                                          });
                                        }
                                      : null,
                                  icon: Icon(
                                    Icons.chevron_right,
                                    color: _currentPage < totalPages - 1
                                        ? AppStyles.primaryColor.shade600
                                        : AppStyles.primaryColor.shade400,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Failed to load transaction data: ${snapshot.error}',
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }

                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
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

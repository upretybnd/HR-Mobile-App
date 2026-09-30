
import 'package:get/get.dart';
import 'package:hr_management/features/employee/api/employee_api.dart';
import 'package:hr_management/features/employee/model/employee_model.dart';
import 'package:hr_management/features/employee/model/employee_id_model.dart';

import 'package:hr_management/features/employee/model/employee_grouped_model.dart';

class EmployeeController extends GetxController{
  // observable state
  final employees = <Employee>[].obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;

  final selectedEmployee = Rx<EmployeeIdModel?>(null);

// Api call to fetch employees  data
  Future<void> fetchEmployees() async{
    isLoading.value=true;
    hasError.value =false;
    errorMessage.value='';
    try{
      final result = await EmployeeApi.fetchEmployees();
      employees.value =result.data;
    }
    catch(e){
      hasError.value=true;
      errorMessage.value=e.toString();
    }
    finally{
      isLoading.value=false;
    }
  }

// Api call to fetch employees data by id
  Future<void> fetchEmployeesById(
    String id
  ) async{
    isLoading.value=true;
    hasError.value =false;
    errorMessage.value='';
    try{
      final result = await EmployeeApi.fetchEmployeesById(id);
      selectedEmployee.value = result.data;
    }
    catch(e){
      hasError.value=true;
      errorMessage.value=e.toString();
    }
    finally{
      isLoading.value=false;
    }
  }

  final apiSearchedEmployee = Rx<Employee?>(null);
  
  // Type filtering
  final selectedType = 'All Employees'.obs;
  final availableTypes = ['All Employees', 'FULL_TIME', 'PART_TIME', 'CONTRACT', 'INTERN'];

  // Department (Grouped) filtering
  final selectedDepartment = 'All Departments'.obs;
  final availableDepartments = <String>[].obs;
  final groupedEmployeesData = <String, List<EmployeeGroupedItemModel>>{}.obs;

  // Status filtering
  final selectedStatus = 'All Status'.obs;
  final availableStatuses = ['All Status', 'ACTIVE', 'INACTIVE', 'TERMINATED', 'PENDING'];

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
    fetchGroupedEmployeesData();
  }

  Future<void> fetchGroupedEmployeesData() async {
    try {
      final result = await EmployeeApi.fetchGroupedEmployees();
      if (result.success) {
        groupedEmployeesData.value = result.data;
        availableDepartments.value = ['All Departments', ...result.data.keys];
      }
    } catch(e) {
      print('Error fetching grouped employees: $e');
    }
  }

  // Filtered employees based on search query, type, status, and department
  List<Employee> get filteredEmployees {
    List<Employee> baseList = employees;

    // Filter by Type
    if (selectedType.value != 'All Employees') {
      baseList = baseList.where((e) => e.employeeType.toRawString().toUpperCase() == selectedType.value.toUpperCase()).toList();
    }

    // Filter by Status
    if (selectedStatus.value != 'All Status') {
      baseList = baseList.where((e) => e.status.toRawString().toUpperCase() == selectedStatus.value.toUpperCase()).toList();
    }

    // Filter by Department (from grouped API)
    if (selectedDepartment.value != 'All Departments') {
      final groupList = groupedEmployeesData[selectedDepartment.value] ?? [];
      final groupUserIds = groupList.map((e) => e.userId).toSet();
      baseList = baseList.where((e) => groupUserIds.contains(e.userId)).toList();
    }

    if (searchQuery.value.isEmpty) {
      return baseList;
    }
    
    final query = searchQuery.value.toLowerCase();
    
    // Local filter
    final localMatches = baseList.where((emp) {
      final name = '${emp.user?.firstName ?? ''} ${emp.user?.email ?? ''}'.toLowerCase();
      final position = emp.position.toLowerCase();
      final dept = emp.department?.name.toLowerCase() ?? '';
      return name.contains(query) || position.contains(query) || dept.contains(query);
    }).toList();

    // If API found an employee by email, and it's not already in the list, add it
    if (apiSearchedEmployee.value != null) {
      final apiEmp = apiSearchedEmployee.value!;
      if (!localMatches.any((e) => e.userId == apiEmp.userId)) {
        localMatches.insert(0, apiEmp);
      }
    }

    return localMatches;
  }

  // update search query
  Future<void> onSearch(String value) async {
    searchQuery.value = value;
    
    final query = value.trim();
    // Basic email regex
    final bool isEmail = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(query);

    if (isEmail) {
      try {
        isLoading.value = true;
        final result = await EmployeeApi.fetchUsersByEmail(query);
        if (result.success && result.data != null) {
          final data = result.data!;
          // Map ByEmailData to Employee for display
          apiSearchedEmployee.value = Employee(
            id: '', // Will be empty since it's just a user
            userId: data.id,
            employeeId: 'N/A',
            departmentId: '',
            position: data.role.isNotEmpty ? data.role : 'User',
            employeeType: EmployeeType.unknown,
            joinDate: data.createdAt ?? DateTime.now(),
            status: data.isActive ? EmployeeStatus.active : EmployeeStatus.inactive,
            createdAt: data.createdAt ?? DateTime.now(),
            updatedAt: DateTime.now(),
            user: EmployeeUser(
              id: data.id,
              email: data.email,
              firstName: data.fullName,
            ),
          );
        } else {
          apiSearchedEmployee.value = null;
        }
      } catch (e) {
        apiSearchedEmployee.value = null;
      } finally {
        isLoading.value = false;
      }
    } else {
      apiSearchedEmployee.value = null;
    }
  }

  // Helper: Get Initials
  String getInitials(Employee emp){
    final first =emp.user?.firstName ??'';
    if(first.length >=2){
      return first.substring(0,2).toUpperCase();
    }
    return first.toUpperCase();
  }

  // Helper: Get display name
  String getDisplayName(Employee emp){
    return emp.user?.firstName ?? 'Unknown';
  }

  // Helper:Get role & department string
  String getRoleDept(Employee emp){
    final position=emp.position.isNotEmpty ? emp.position : 'No Position';
    final dept =emp.department?.name??'No Department';
    return '$position . $dept';
  }
}


import 'package:get/get.dart';
import 'package:hr_management/features/employee/api/employee_api.dart';
import 'package:hr_management/features/employee/model/employee_model.dart';

class EmployeeController extends GetxController{
  // observable state
  final employees = <Employee>[].obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;

  // Auto-fetch when controller is created
  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

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

  // Filtered employees based on search query
  List<Employee> get filteredEmployees{
    if(searchQuery.value.isEmpty){
      return employees;
    }
    final query=searchQuery.value.toLowerCase();
    return employees.where((emp){
      final name= '${emp.user?.firstName??''} ${emp.user?.email??''}'.toLowerCase();
      final position =emp.position.toLowerCase();
      final dept =emp.department?.name.toLowerCase()??'';
      return name.contains(query) || position.contains(query) || dept.contains(query);
    }).toList();
  }

  // update search query
  void onSearch(String value){
    searchQuery.value=value;
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

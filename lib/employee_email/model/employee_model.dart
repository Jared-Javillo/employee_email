class EmployeeModel {
  final String firstName;
  final String lastName;
  final String email;
  final String employeeId;
  final String teamId;

  const EmployeeModel({
    required String firstName,
    required String lastName,
    required String email,
    required String employeeId,
    required String teamId,
  })  : firstName = firstName,
        lastName = lastName,
        email = email,
        employeeId = employeeId,
        teamId = teamId;

  factory EmployeeModel.fromJson(Map<String, dynamic> map) {
    return EmployeeModel(
      firstName: map['firstname'],
      lastName: map['lastname'],
      email: map['email'],
      employeeId: map['employee_id'],
      teamId: map['team_id'],
    );
  }
//Factory constructor <- handle json parsing
}

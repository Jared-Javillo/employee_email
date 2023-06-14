import 'package:employee_email/data/database/schema.dart';

const schema = Schema();
const String dbName = 'employee_emails.db';
const String libraryPath = 'D:/Development/SQLCipher/build/sqlite3.dll';
const int version = DbVersionHistory.v20230512;

class DbVersionHistory {
  static const int v20230512 = 4;
}

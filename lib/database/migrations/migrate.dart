import 'dart:io';
import 'package:vania/vania.dart';
import 'create_users_table.dart';
import 'create_personal_access_tokens_table.dart';
import 'create_task_table.dart';


void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
		 await CreateUsersTable().up();
		 await CreatePersonalAccessTokensTable().up();
		 await CreateTaskTable().up();
	}

  dropTables() async {
		 await CreateTaskTable().down();
		 await CreatePersonalAccessTokensTable().down();
		 await CreateUsersTable().down();
	 }
}

import 'package:vania/vania.dart';

class CreateTaskTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('task', () {
      id();
      string('name', length: 100);
      string('description', length: 200);
      time('task_time');
      date('start_date');
      date('end_date');
      
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('task');
  }
}

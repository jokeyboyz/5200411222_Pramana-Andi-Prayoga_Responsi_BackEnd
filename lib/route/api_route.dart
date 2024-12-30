import 'package:restapi_vania/app/http/controllers/auth_controller.dart';
import 'package:restapi_vania/app/http/controllers/users_controller.dart';
import 'package:restapi_vania/app/http/middleware/authenticate.dart';

import 'package:vania/vania.dart';

class ApiRoute implements Route {
  @override
  void register() {

    Router.get('api/user/profile', authController.profile);
    Router.basePrefix('api');
    Router.group((){
      Router.post('register', authController.register);
      Router.post('login', authController.login);
      Router.post('addTask', authController.addTask);
      Router.get('getTask', authController.getAllTasks);
      Router.put('updateTask', authController.updateTask);
      Router.delete('api/auth/deleteTask/:id', authController.deleteTask);
    }, prefix: 'auth');

     Router.group(() {
      Router.get('me', userController.index);
    }, prefix: 'user', middleware: [AuthenticateMiddleware()]);

  }
}

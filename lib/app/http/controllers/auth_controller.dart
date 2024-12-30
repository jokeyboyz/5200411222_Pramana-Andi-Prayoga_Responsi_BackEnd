import 'dart:io';

import 'package:restapi_vania/app/models/tasks.dart';
import 'package:restapi_vania/app/models/user.dart';
import 'package:vania/vania.dart';

class AuthController extends Controller {

     Future<Response> register(Request request) async {
      request.validate({
        'name': 'required',
        'email': 'required|email',
        'password': 'required|min_length:6|confirmed'
      }, {
        'name.required': 'data cant be empty',
        'email.required': 'data cant be empty',
        'password.required': 'data cant be empty',
        'password.min_length': 'data cant be empty',
        'password.confirmed': 'data cant be empty'
      });

      final name = request.input('name');
      final email = request.input('email');
      var password = request.input('password').toString();

      var users = await User().query().where('email', '=', email).first();
      if (users != null) {
        return Response.json({
          "massage": "user sudah ada"
        }, 409);
      }

      password = Hash().make(password);
      await User().query().insert({
        "name": name,
        "email": email,
        "password": password,
        "created_at": DateTime.now().toIso8601String(),
      });
      
          return Response.json({'message':'Data Berhasil Ditambahkan'}, 201);
     }

     Future<Response> login(Request request) async {
      // request.validate({
      //   'email': 'required|email',
      //   'password': 'required'
      // }, {
      //   'email.required': 'data cant be empty',
      //   'password.required': 'data cant be empty'
      // });

      final email = request.input('email');
      var password = request.input('password').toString();

      var users = await User().query().where('email', '=', email).first();
      if (users == null) {
        return Response.json({
          "massage": "user belum terdaftar"
        }, 409);
      }

      if (!Hash().verify(password, users['password'])) {
        return Response.json({'massage': 'password yang anda masukan salah'}, 409);
      }

      final token = await Auth().login(users).createToken(expiresIn: Duration(days: 30), withRefreshToken: true);
      
          return Response.json({
            'message':'Berhasil Login',
            'token': token
          });      
     }

     Future<Response> me() async {
      Map? users = Auth().user();

      if (users != null) {
        users.remove("password");
        return Response.json({
          "massage": "success",
          "data": users,
        }, HttpStatus.ok);
      }
          return Response.json({
            "massage": "success",
            "date": "",
          }, HttpStatus.notFound);
     }

     Future<Response> show(int id) async {
          return Response.json({});
     }

     Future<Response> edit(int id) async {
          return Response.json({});
     }

     Future<Response> update(Request request,int id) async {
          return Response.json({});
     }

     Future<Response> destroy(int id) async {
          return Response.json({});
     }

    Future<Response> profile() async {
      Map? user = Auth().user();
      if (user != null) {
        var userData = await User()
            .query()
            .where('id', '=', user['id'])
            .select(['name', 'email']).first();

        if (userData != null) {
          return Response.json({
            "message": "success",
            "data": userData,
          }, HttpStatus.ok);
        }
      }

      return Response.json({
        "message": "User not found",
        "data": null,
      }, HttpStatus.notFound);
    }

      Future<Response> addTask(Request request) async {
      request.validate({
        'name': 'required',
        'description': 'required|description',
        'task_time': 'required|task_time',
        'task_date': 'required|task_date',
      }, {
        'name.required': 'data cant be empty',
        'description.required': 'data cant be empty',
        'task_time.required': 'data cant be empty',
        'task_date.min_length': 'data cant be empty'
      });

      final name = request.input('name');
      final description = request.input('description');
      final taskTime = request.input('task_time');
      final taskDate = request.input('task_time');

      var tasks = await Tasks().query().where('name', '=', name).first();
      if (tasks != null) {
        return Response.json({
          "massage": "user sudah ada"
        }, 409);
      }

      await Tasks().query().insert({
        "name": name,
        "description": description,
        "task_time": taskTime,
        "task_date": taskDate,
      });
      
          return Response.json({'message':'Data Berhasil Ditambahkan'}, 201);
    }

 Future<Response> updateTask(Request request) async {
  try {
    // Ambil ID dari input dan parsing ke int
    final String idString = request.input('id');
    final int id = int.parse(idString);

    final name = request.input('name');
    final description = request.input('description');
    final taskTime = request.input('task_time');
    final taskDate = request.input('task_date');

    final updatedTask = await Tasks().query().where('id', '=', id).update({
      'name': name,
      'description': description,
      'task_time': taskTime,
      'task_date': taskDate,
    });

    if (updatedTask > 0) {
      return Response.json({"message": "Task updated successfully"}, HttpStatus.ok);
    }
    return Response.json({"message": "Task not found"}, HttpStatus.notFound);
  } catch (e) {
    return Response.json({'error': e.toString()}, HttpStatus.internalServerError);
  }
}




 Future<Response> deleteTask(Request request) async {
  try {
    // Ambil ID dari params dan parsing ke int jika perlu
    final String idString = request.input('id');
    final int id = int.parse(idString);

    // Gunakan ID dalam query
    final deletedTask = await Tasks().query().where('id', '=', id).delete();

    if (deletedTask > 0) {
      return Response.json({"message": "Task deleted successfully"}, HttpStatus.ok);
    }
    return Response.json({"message": "Task not found"}, HttpStatus.notFound);
  } catch (e) {
    return Response.json({'error': e.toString()}, HttpStatus.internalServerError);
  }
}



Future<Response> getAllTasks() async {
  // Query untuk mengambil semua task dari tabel
  var tasks = await Tasks()
      .query()
      .select(['id', 'name', 'description', 'task_time', 'task_date']) // Pilih kolom yang dibutuhkan
      .get(); // Ambil semua data

  // Jika ada task, kembalikan dalam format JSON
  if (tasks.isNotEmpty) {
    return Response.json({
      "message": "success",
      "data": tasks, // Semua data task
    }, HttpStatus.ok);
  }

  // Jika tidak ada task
  return Response.json({
    "message": "No tasks found",
  }, HttpStatus.notFound);
}


    
}

final AuthController authController = AuthController();


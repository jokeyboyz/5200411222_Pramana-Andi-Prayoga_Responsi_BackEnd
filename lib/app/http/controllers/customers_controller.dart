import 'package:restapi_vania/app/models/customers.dart';
import 'package:vania/vania.dart';

class CustomersController extends Controller {

     Future<Response> index() async {
          return Response.json({'message':'Hello World'});
     }

     Future<Response> create(Request request) async {
      request.validate({
        'cust_name': 'required',
        'cust_address': 'required',
        'cust_city': 'required',
        'state': 'required',
        'zip': 'required',
        'country': 'required',
        'telp': 'required'
      }, {
        'cust_name.required': 'data cant be empty',
        'cust_address.required': 'data cant be empty',
        'cust_city.required': 'data cant be empty',
        'state.required': 'data cant be empty',
        'zip.required': 'data cant be empty',
        'country.required': 'data cant be empty',
        'telp.required': 'data cant be empty',
      });

      final requestData = request.input();
      requestData['created_at'] = DateTime.now().toIso8601String();

      final existingData =
        await Customers().query().where('cust_name', '=', requestData['cust_name']).first();
      if (existingData != null) {
        return Response.json(
          {"massage": "Data already exist"},
          410
        );
      }

      await Customers().query().insert(requestData);

          return Response.json({
            "massage": "Data added successfully",
            "data": Customers,
          }, 201);
     }

     Future<Response> store(Request request) async {
          return Response.json({});
     }

     Future<Response> show(int id) async {
          return Response.json({});
     }

     Future<Response> edit(int custId) async {
      final customers = await Customers().query().where('cust_id', '=', custId).first();
        if (customers == null) {
            return Response.json({
                "message": "Customer not found"
            }, 404);
        }

        return Response.json({
            "message": "Customer data retrieved successfully",
            "data": customers
        });
     }

     Future<Response> update(Request request,int id) async {
          return Response.json({});
     }

     Future<Response> destroy(int custId) async {
      final customers = await Customers().query().where('cust_id', '=', custId).first();
        if (customers == null) {
            return Response.json({
                "message": "Customer not found"
            }, 404);
        }

        // Hapus data
        await Customers().query().where('cust_id', '=', custId).delete();

        return Response.json({
            "message": "Customer deleted successfully"
        }, 200);
     }
}

final CustomersController customersController = CustomersController();


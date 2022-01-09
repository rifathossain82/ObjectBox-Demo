import 'dart:io';

import 'package:flutter/material.dart';
import 'package:objectbox_database_demo/model/data.dart';
import 'package:objectbox_database_demo/model/user_model.dart';
import 'package:objectbox_database_demo/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  // Store? _store;
  // Box<UserModel>? userbox;
  // final syncServerIp=Platform.isAndroid ? '10.0.2.2':'127.0.0.1';
  late Store store;
  late Box<UserModel> box;
  late UserModel userModel;
  String buttonText='Add';     //button text

  List<Data> datalist=[];         //to store  all data in datalist
  late Data data;       //variable of Data class
  late int id;          //to put id for update

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    ddd();

  }

     void ddd()async{
     store = await openStore();  //open object box
     box = store.box<UserModel>();      //

     refreshData();   //just load all data of datalist


    //userModel = UserModel(name: 'Rifat', age: 21);

    // final id = box.put(userModel);
    // print(box.get(id)!.name);
  }

  void refreshData(){
    if(box.getAll().isNotEmpty){
      datalist=[];
      for(var n in box.getAll()){
        var d=Data(n.id, n.name.toString(), int.parse(n.age.toString()));
        datalist.add(d);
      }
    }
  }

  @override
  void dispose() {
    store.close(); //to close store
    super.dispose();
  }
 var username='';    //skip it
  TextEditingController namecontroller=TextEditingController();
  TextEditingController agecontroller=TextEditingController();

  
  @override
  Widget build(BuildContext context) {
    buttonText=namecontroller.text.isNotEmpty? 'Save':'Add';
    return Scaffold(
      appBar: AppBar(
        title: Text('ObjectBox Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: namecontroller,
              decoration: InputDecoration(
                hintText: 'Enter Name',
              ),
            ),
            SizedBox(height: 8,),
            TextField(
              controller: agecontroller,
              decoration: InputDecoration(
                hintText: 'Enter age',
              ),
            ),
            Center(
              child: ElevatedButton(
                child: Text(buttonText),
                onPressed: (){
                  //to add new data
                  if(buttonText.contains('Add')){
                    userModel = UserModel(name: namecontroller.text.toString(), age: int.parse(agecontroller.text.toString()));
                    var id=box.put(userModel);
                    setState(() {
                      var d=Data(box.get(id)!.id, box.get(id)!.name.toString(), int.parse(box.get(id)!.age.toString()));
                      datalist.add(d);
                      // for(var n in box.get(id)){
                      //   var d=Data(n.id, n.name.toString(), int.parse(n.age.toString()));
                      //   datalist.add(d);
                      // }
                      namecontroller.clear();
                      agecontroller.clear();
                    });
                  }

                  //to update specific data
                  else{
                    userModel = UserModel(id: id ,name: namecontroller.text.toString(), age: int.parse(agecontroller.text.toString()));
                    box.put(userModel);

                    setState(() {
                      refreshData();

                      namecontroller.clear();
                      agecontroller.clear();
                    });
                  }

                },
              ),
            ),
            Text('${datalist.length}'),
            SizedBox(height: 8,),
            //to show all data
            Expanded(
              child: ListView.builder(
                itemCount: datalist.length,
                  itemBuilder: (context,index){
                  return Card(
                    child: ExpansionTile(
                      title: Text(datalist[index].name),
                      trailing: Text('${datalist[index].age}'),
                      leading: Text('${datalist[index].id}'),
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: TextButton.icon(
                                  onPressed: (){
                                    setState(() {
                                      namecontroller.text=datalist[index].name;
                                      agecontroller.text=datalist[index].age.toString();
                                      setState(() {
                                        id=datalist[index].id;
                                      });
                                    });
                                  },
                                  icon: Icon(Icons.edit),
                                  label: Text('Edit'),
                                ),
                            ),
                            SizedBox(width: 12,),
                            Expanded(
                              child: TextButton.icon(
                                onPressed: (){
                                  box.remove(datalist[index].id);
                                  setState(() {
                                    datalist.removeAt(index);
                                    namecontroller.clear();
                                    agecontroller.clear();
                                  });
                                },
                                icon: Icon(Icons.delete),
                                label: Text('Delete'),
                              ),
                            )
                          ],
                        ),

                      ],
                    ),
                  );
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}




import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat_app/models/user.dart';



class UsersPage extends StatefulWidget {

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {


  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  
  


  final users = [
    User(uid: '1', nombre: 'Carlos', email: 'Carlos1@test.com', online: true),
    User(uid: '2', nombre: 'Melisa', email: 'Melisa1@test.com', online: false),
    User(uid: '3', nombre: 'Roberto', email: 'Roberto1@test.com', online: true),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Luciano Romero', style: TextStyle(color: Colors.black54)),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          color: Colors.black54,
          onPressed: (){},
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.blue[400]),
            //child: Icon(Icons.check_circle, color: Colors.red),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _loadUsers,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue
        ),
        child: _listViewUsers(),
      )
   );
  }

  ListView _listViewUsers() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _userListTile(users[i]), 
      separatorBuilder: (_, i) => Divider(), 
      itemCount: users.length
    );
  }

  ListTile _userListTile(User user) {
    return ListTile(
        title: Text(user.nombre),
        subtitle: Text(user.email),
        leading: CircleAvatar(
          child: Text(user.nombre.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
      );
  }
  
  void _loadUsers() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }


}
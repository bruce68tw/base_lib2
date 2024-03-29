import 'package:flutter/material.dart';
import 'all.dart';

class Sqlite extends StatefulWidget {
  const Sqlite({Key? key}) : super(key: key);
  //final String dbName;

  @override
  _SqliteState createState() => _SqliteState();
}

class _SqliteState extends State<Sqlite> {  
  bool _isOk = false;       //state variables
  late PagerSrv _pagerSrv;  //pager service
  //late PagerDto<DeptItemDto> _pagerDto;
  String _table = '';   //now table
  List<IdStrDto> _tables = [];
  final Map<String, String> _tableSql = {};  //table,sql
  String _sql = '';   //now sql
  List<Map<String, dynamic>> _rows = []; //??
  int _recordsFiltered = -1;

  //Map<String, dynamic>? _row; //??
  //dynamic _key; //??

  @override
  void initState() {
    //initial variables
    _pagerSrv = PagerSrv(getPageAsync);

    super.initState();
    Future.delayed(Duration.zero, ()=> initAsync());
  }

  //run one time
  Future initAsync() async {
    //read table list
    var sql = '''
select name as Id, name as Str 
from sqlite_master 
where type = 'table' 
and name not like 'sqlite%'
and name not like 'android%'
order by name
''';
    _tables = await DbUt.getIdStrsAsync(sql);
    _table = _tables.first.id;
    _isOk = true;
    await showAsync();
  }

  //called by: 1.initAsync, 2.change table
  Future showAsync() async {
    //get order string from primary key if need
    if (_tableSql.isEmpty || _tableSql[_table] == null){
      var sql = "select name, type from pragma_table_info('$_table') where pk";
      var rows = await DbUt.getJsonsAsync(sql);
      var order = rows.map((a)=> a['name']).toList().join(',');
      if (order == ''){
        ToolUt.msg(context, 'Primary Key 不存在。');
        return;
      }

      _sql = 'select * from $_table order by $order';
      _tableSql[_table] = _sql;
    } else {
      _sql = _tableSql[_table]!;
    }

    await getPageAsync();
  }

  /// get page rows
  Future getPageAsync() async {
    var json = await CrudRead().getPageBySqlAsync(_sql, _pagerSrv.getDtJson());
    if (json == null) return;

    _rows = (json['data'] == null) ? [] : json['data'] as List<Map<String, dynamic>>;
    _recordsFiltered = json['recordsFiltered'];
    /*
    var dtos = jsons.map((a) => fromJson(a)).cast<T>().toList(); //has cast<>

    return PagerDto(
      //draw: json['draw'],
      recordsFiltered: json['recordsFiltered'],
      dtos: dtos,
    );

    _pagerDto = PagerDto<DeptItemDto>.fromJson(json, DeptItemDto.fromJson);
    */

    setState((){_isOk = true;});
    //var rows 

    //setState((){});
  }

  Widget getBody() {
    //add 'New' button first
    var widgets = <Widget>[];

    //table name & divider
    widgets.add(WG.iselect('資料表', _table, _tables, (value) async {
      _table = value;
      await showAsync();
    }));
    //widgets.add(WG.divider(15));

    widgets.add(const SizedBox(height: 10));

    for(var row in _rows){
      for(var prop in row.entries){
        widgets.add(WG.labelText(prop.key+' : ', prop.value.toString()));
      }
      widgets.add(WG.divider(15));
    }

    //add pager
    widgets.add(_pagerSrv.getWidget(_recordsFiltered));

    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOk) return Container();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 42,
        title: const Text('檢視 sqlite 資料表', style:TextStyle(fontSize:16))
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: getBody()
    ));
  }
  
} //class
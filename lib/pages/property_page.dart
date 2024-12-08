import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:property_bloc_fetch_api/blocs/property_bloc/property_bloc.dart';
import 'package:property_bloc_fetch_api/models/property_model.dart';

class PropertyPage extends StatefulWidget {
  @override
  _PropertyPageState createState() => _PropertyPageState();
}

class _PropertyPageState extends State<PropertyPage> {
  final PropertyBloc _newsBloc = PropertyBloc();

  @override
  void initState() {
    _newsBloc.add(GetPropertyList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sleek Propertis LLC')),
      body: _buildListProperty(),
    );
  }

  Widget _buildListProperty() {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (_) => _newsBloc,
        child: BlocListener<PropertyBloc, PropertyState>(
          listener: (context, state) {
            if (state is PropertyError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                ),
              );
            }
          },
          child: BlocBuilder<PropertyBloc, PropertyState>(
            builder: (context, state) {
              if (state is PropertyInitial) {
                return _buildLoading();
              } else if (state is PropertyLoading) {
                return _buildLoading();
              } else if (state is PropertyLoaded) {
                return _buildCard(context, state.propertyModel);
              } else if (state is PropertyError) {
                return Container();
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, PropertyModel model) {
    return ListView.builder(
      itemCount: model!.length,
      itemBuilder: (context, index) {
        // return Container(
        //   margin: EdgeInsets.all(8.0),
        //   child: Card(
        //     child: Container(
        //       margin: EdgeInsets.all(8.0),
        //       child: Column(
        //         children: <Widget>[
        //           Text("Name: ${model![index].name}"),
        //           Text(
        //               "Description: ${model![index].description}"),
        //           Text("Cost: ${model![index].cost}"),
        //           Text(
        //               "Image: ${model![index].image}"),
        //         ],
        //       ),
        //     ),
        //   ),
        // );
        
          final data = model[index];
          return ListTile(
            title: Text(data['name']),
            subtitle: Text(data['description']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => PropertyDetail(data['id']),
                  // _updateData(data['id']),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteData(data['id']),
                ),
              ],
            ),
          );
      },
      
      floatingActionButton: FloatingActionButton(
        onPressed: _createData,
        tooltip: 'Create',
        child: Icon(Icons.add),
      ),
    );

    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}

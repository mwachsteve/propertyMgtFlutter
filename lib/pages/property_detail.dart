class PropertyDetail extends StatefulWidget {
  final String id;
  PropertyDetail(this.id);

  @override
  _PropertyDetailState createState() => new _PropertyDetailState();
}

class _PropertyDetailState extends State<PropertyDetail> {
  PropertyBloc _propertyBloc;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();

  StreamSubscription blocSubscription;

  @override
  void initState() {
    _propertyBloc = PropertyBloc();

    if (widget.id != "") {
      _propertyBloc.getProperty(widget.id);
    }

    blocSubscription = _propertyBloc.state.listen((onData) {
      if (onData.isSaved == true || onData.isDeleted == true) {
        Navigator.pop(context, true);
      }

      if (onData.isLoaded) {
        _nameController.text = onData.property.name;
        _descriptionController.text = onData.property.description;
        _costController.text = onData.property.cost;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    blocSubscription.cancel();
    _propertyBloc.dispose();
    super.dispose();
  }

  void create() {
    _propertyBloc.createProperty(
      Property(
        name: _nameController.text,
        description: _descriptionController.text,
        cost: _costController.text,
      ),
    );
  }

  void deleteProperty(String id) {
    _propertyBloc.deleteProperty(widget.id);
  }

  void update(String id) {
    _propertyBloc.updateProperty(
      Property(
        id: id,
        name: _nameController.text,
        description: _descriptionController.text,
        cost: _costController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Property Detail"),
        actions: <Widget>[
          BlocBuilder(
              bloc: _propertyBloc,
              builder: (BuildContext context, PropertyState state) {
                return IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () {
                      if (widget.id != "") {
                        update(state.property.id);
                      } else {
                        create();
                      }
                    });
              }),
          BlocBuilder(
              bloc: _propertyBloc,
              builder: (BuildContext context, PropertyState state) {
                return IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      if (widget.id != "") {
                        deleteProperty(widget.id);
                      }
                    });
              })
        ],
      ),
      body: BlocBuilder(
          bloc: _propertyBloc,
          builder: (BuildContext context, PropertyState state) {
            if (state.isSaving == true) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return state.isLoading
                ? LinearProgressIndicator()
                : Form(
                    child: SingleChildScrollView(
                      child: Column(children: [
                        ListTile(
                          leading: Icon(Icons.person),
                          title: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: "Name",
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.verified_user),
                          title: TextFormField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              hintText: "Description",
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.mail),
                          title: TextFormField(
                            controller: _costController,
                            decoration: InputDecoration(
                              hintText: "Cost",
                            ),
                          ),
                        )
                      ]),
                    ),
                  );
          }),
    );
  }
}
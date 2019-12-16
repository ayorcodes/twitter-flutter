import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:news_app/api/postApi.dart';

class NewPostModal extends StatefulWidget {
  @override
  _NewPostModalState createState() => _NewPostModalState();
}

class _NewPostModalState extends State<NewPostModal> {

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  var isDisabled = true;

  final api = PostApi();

  submit() async{
    setState(() {
      this.isDisabled = true;
    });
    if (_fbKey.currentState.saveAndValidate()) {
      var content  = _fbKey.currentState.value['post'].toString();
      Map payload = {
        "content": content,
        "title": "new tag",
        "category_id": "5",
        "post_type": "text",
        "tags": [2,4,5,6]
      };

      await api.addPost(payload).then((res) {
        //var output = res.data;
        Navigator.pop(context, {
          'refresh': true
        });
      }).catchError((err) {
        setState(() {
          this.isDisabled = false;
        });
        print(err);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    dynamic data = ModalRoute.of(context).settings.arguments;

    final form = FormBuilder(
      key: _fbKey,
      child: ListTile(
        title: Text(""),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(data['image'])
          ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FormBuilderTextField(
              attribute: "post",
              decoration: InputDecoration.collapsed(
                  hintText: 'Write Something.....'
              ),
              validators: [
                FormBuilderValidators.required()
              ],
              autofocus: true,
              onChanged:(value) {
                if (value != "") {
                  setState(() {
                    this.isDisabled = false;
                  });
                } else {
                  setState(() {
                    this.isDisabled = true;
                  });
                }
              },

            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close,color: Colors.lightBlue,size: 30,),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  child: Text('Tweet',style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                  ),),
                  color: Colors.blue[600],
                  onPressed: isDisabled ? null : () {
                    submit();
                  },
                  disabledColor: Colors.blue[300],
                  disabledTextColor: Colors.white,
                  textColor: Colors.white,
                  shape: StadiumBorder(),
                  height: 30.0,
                  minWidth: 30,
                  elevation: 2.0,
                ),
              ),
            ],
          )
        ],
      ),
      body: form,
    );
  }
}

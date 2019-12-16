import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:news_app/api/postApi.dart';

class NewCommentModal extends StatefulWidget {

  final postId;

  NewCommentModal({
    this.postId
  });

  @override
  _NewCommentModalState createState() => _NewCommentModalState();
}

class _NewCommentModalState extends State<NewCommentModal> {

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  var isDisabled = true;

  final api = PostApi();
  

  submit() async{
    setState(() {
      this.isDisabled = true;
    });
    if (_fbKey.currentState.saveAndValidate()) {
      var content  = _fbKey.currentState.value['comment'].toString();
      Map payload = {
        "comment": content
      };
      var id = widget.postId;

      await api.addComment(id, payload).then((res) {
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
              attribute: "comment",
              decoration: InputDecoration.collapsed(
                  hintText: 'Tweet your reply'
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
                  child: Text('Reply',style: TextStyle(
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

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'schoolapis.dart';

import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import '../Contsants.dart';

class ResourcesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future:
        Getresources (context),
        builder: (BuildContext context, AsyncSnapshot platformData) {
          if (platformData.hasData) {
            List<Widget>children=[];
            for(int i=0; i <List.from(resourcedata.reversed).length;i++){
              children.add(
                  Events(
                    title: List.from(resourcedata.reversed)[i].title,
                    attachments: List.from(resourcedata.reversed)[i].attachments,
                  )
              );
            }
            return SingleChildScrollView(
                child: Column(
                  children: children,
                ),
              );
          } else {
            return  Center(
                child: Image.asset("assets/volume-colorful.gif"));
          }
        });
  }
}

class Events extends StatelessWidget {
  String title;
  List<attachement>attachments;
  Events({this.title,this.attachments});
  @override
  List<Widget> children=[];
  Widget build(BuildContext context) {
    for(int i=0;i<attachments.length;i++){
      children.add(
        GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Previewpdf(
                 attachments[i].attachmnet,attachments[i].name,
              )),
            );
          },
          child: Container(
              margin: EdgeInsets.fromLTRB(10,5,10,5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                 color: borderyellow,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Resource name",style: TextStyle(color: Colors.grey),),
                      SizedBox(height: 5,),
                      Text(attachments[i].name),
                    ],
                  ),
                  Icon(CupertinoIcons.doc_plaintext,color: secondarycolor,)
                ],
              )),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 35,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.only(left:8.0,right: 8),
                child: Divider(thickness: 0.3,color: Colors.black,),
              )),
              Text(title,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(left:8.0,right: 8),
                child: Divider(thickness: 0.3,color: Colors.black,),
              ))
            ],
          ),
        ),
        Column(
            children: children
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}
class Previewpdf extends StatelessWidget {
  String link;
  String name;
  Previewpdf(this.link,this.name);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_sharp, color: secondarycolor),
        ),
        title:
        FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(name,style: TextStyle(fontWeight: FontWeight.bold,color: secondarycolor),)),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: PDF().cachedFromUrl(
          link,
          placeholder: (progress) =>
              Center(child: Text('$progress %')),
          errorWidget: (error) =>
              Center(child: Text(error.toString())),
        ),
      ),
    );
  }
}

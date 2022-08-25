import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';


class Testing extends StatelessWidget {
  final String videosss;
Testing(this.videosss);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Widget from HTML',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Widget from HTML'),
        ),
        body:  Container(
    child:  HtmlWidget(
      '''
  <h3>Heading</h3>
  <p>
    A paragraph with <strong>strong</strong>, <em>emphasized</em>
    and <span style="color: red">colored</span> text.
  </p>
  <html><body><iframe src="$videosss"></iframe></body></html>
  <!-- anything goes here -->
  ''',

  // all other parameters are optional, a few notable params:

  // specify custom styling for an element
  // see supported inline styling below
  customStylesBuilder: (element) {
    if (element.classes.contains('foo')) {
      return {'color': 'red'};
    }

    return null;
  },

  // render a custom widget
  customWidgetBuilder: (element) {
    if (element.attributes['foo'] == 'bar') {
      return ;
    }

    return null;
  },

  // set the default styling for text
  textStyle: TextStyle(fontSize: 14),

  // turn on `webView` if you need IFRAME support
  webView: true,
    ),
        
        
      ),),
    );
  }
}
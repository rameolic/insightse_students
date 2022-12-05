import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'schoolapis.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';
import '../Contsants.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GalleryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetGallery(context),
        builder: (BuildContext context, AsyncSnapshot platformData) {
          if (platformData.hasData) {
            List<Widget>children=[];
            for(int i=0; i <List.from(gallerydata.reversed).length;i++){
              children.add(
                  Events(
                    title: List.from(gallerydata.reversed)[i].title,
                    images: List.from(gallerydata.reversed)[i].images,
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
  List<String>images;
  Events({this.title,this.images});
  @override
  List<ImageGalleryHeroProperties> heroProperties=[];
  List<Widget> assets=[];
  List<Widget> children=[];
  Widget build(BuildContext context) {
    children=[];
    for(int i=0;i<images.length;i++){
      assets.add(Image(image: NetworkImage(images[i])));
      heroProperties.add(ImageGalleryHeroProperties(tag: 'imageId'+'$i'),);
      children.add(
        GestureDetector(
          onTap: (){
            SwipeImageGallery(
              context: context,
              children: assets,
              heroProperties: heroProperties,
              initialIndex: i,
            ).show();
          },
          child: Hero(
            tag:heroProperties[i],
            child: Container(
                margin: EdgeInsets.only(bottom: 2.5,left: 2.5),
                height:  MediaQuery.of(context).size.width/2.2,
                width: MediaQuery.of(context).size.width/2.04,
                decoration: BoxDecoration(
                  border: Border.all(color: borderyellow)
                ),
                child: Image.network(
                  images[i],
                  fit: BoxFit.cover,
                )),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Wrap(
          children: children
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}

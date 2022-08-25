import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../ProgressHUD.dart';
import 'package:intl/intl.dart';
import '../Contsants.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'circularapi.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import '../newdashboardui.dart';

class CircularHome extends StatefulWidget {
  @override
  State<CircularHome> createState() => _CircularHomeState();
}

class _CircularHomeState extends State<CircularHome> {
  var _searchview = TextEditingController();
  bool _firstSearch = true;
  String _query = "";
  List<dynamic> inputlist = titlelist;
  List<int> _filterList;
  @override
  void initState() {
    super.initState();
  }

  _CircularHomeState() {
    _searchview.addListener(() {
      if (_searchview.text.isEmpty) {
        setState(() {
          _firstSearch = true;
          _query = "";
        });
      } else {
        setState(() {
          _firstSearch = false;
          _query = _searchview.text;
        });
      }
    });
  }
  bool isdatepickerselected = false;
  final loading = ValueNotifier(false);
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) async {
    if (args.value is PickerDateRange) {
      startdate =
          DateFormat('yyyy-MM-dd').format(args.value.startDate).toString();
      enddate = DateFormat('yyyy-MM-dd').format(args.value.endDate).toString();
    }
    if (startdate.toString() != "null" && enddate.toString() != "null") {
      // loading.value = true;
      // await getcirculars(startdate, enddate, context);
      // loading.value = false;
      isdatepickerselected = !isdatepickerselected;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        await getunreadcount();
        await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            NewDashbBard(
              currentIndex: 0,
            )), (Route<dynamic> route) => false);
        return true;
      },
      child: ValueListenableBuilder<bool>(
          valueListenable: loading,
          builder: (context, value, child) {
            return ProgressHUD(
              inAsyncCall: loading.value,
              opacity: 0.3,
              color: secondarycolor,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: _appBar(context),
                body: Container(
                  margin: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _createSearchView(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isdatepickerselected = !isdatepickerselected;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              width: 40,
                              height: 45,
                              decoration: BoxDecoration(
                                  color: !isdatepickerselected
                                      ? borderyellow
                                      : secondarycolor,
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              child: Icon(
                                Icons.filter_alt_sharp,
                                color: isdatepickerselected
                                    ? Colors.white
                                    : secondarycolor,
                                size: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                      if (isdatepickerselected)
                        SfDateRangePicker(
                          rangeSelectionColor: secondarycolor,
                          rangeTextStyle: const TextStyle(color: Colors.white),
                          onSelectionChanged: _onSelectionChanged,
                          selectionMode: DateRangePickerSelectionMode.range,
                        ),
                      if (startdate.toString() != "null" && enddate.toString() != "null")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0, left: 10),
                                    child: Stack(children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                        decoration: const BoxDecoration(
                                            color: secondarycolor,
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(25))),
                                        child: Stack(
                                          children: [
                                            Text("$startdate - $enddate",
                                                style: const TextStyle(
                                                    color: Colors.white, fontSize: 15)),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              startdate = "null";
                                              enddate = "null";
                                            });
                                          },
                                          child: const CircleAvatar(
                                            radius: 8,
                                            backgroundColor: Colors.red,
                                            child: Icon(
                                              CupertinoIcons.multiply,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                      )
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      _firstSearch ? _createListView() : _performSearch(),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _createSearchView() {
    return Container(
      height: 45,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      width: MediaQuery.of(context).size.width / 1.25,
      decoration: const BoxDecoration(
        color: borderyellow,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(color: secondarycolor),
              controller: _searchview,
              cursorColor: secondarycolor,
              decoration: const InputDecoration(
                contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                focusColor: secondarycolor,
                hintText: 'Search',
                hintStyle: TextStyle(color: secondarycolor),
                border: InputBorder.none,
                icon: Icon(
                  CupertinoIcons.search,
                  color: secondarycolor,
                ),
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                _searchview.clear();
              },
              child: const Icon(
                Icons.close_rounded,
                color: secondarycolor,
              ))
        ],
      ),
    );
  }

  Widget _createListView() {
    return FutureBuilder(
        future: getcirculars(startdate, enddate, context),
        builder: (BuildContext context, AsyncSnapshot platformData) {
          if (platformData.hasData) {
            return
              circulars.length>0?
              Flexible(
              child: ListView.builder(
                  itemCount: circulars.length,
                  itemBuilder: (BuildContext context, int index) {
                    DateTime date =
                    DateTime.parse("${circulars[index].noticedate}");
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){
                            String path = p.extension(circulars[index].filepath);
                            if(path == ".jpg" ||
                                path == ".jpeg" ||
                                path == ".tif" ||
                                path == ".gif" ||
                                path == ".tiff" ||
                                path == ".bmp" ||
                                path == ".png" ||
                                path == ".eps"){
                              SwipeImageGallery(
                                context: context,
                                children: [
                                  Image(
                                      image: NetworkImage(circulars[index].filepath))
                                ],
                                initialIndex: 0,
                              ).show();
                            }else if(path == ".doc" ||
                                path == ".docx" ||
                                path == ".pdf" ||
                                path == ".xls" ||
                                path == ".xlsx" ||
                                path == ".ppt" ||
                                path == ".pptx" ||
                                path == ".txt"){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PreveiwImage(
                                              url: circulars[index]
                                                  .filepath)));
                            }
                            else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          WebveiwUI(
                                              url: circulars[index]
                                                  .filepath)));
                            }
                          },
                          child: Ink(
                            color: Colors.white,
                            width: MediaQuery.of(context)
                                .size
                                .width,
                            child: Container(
                              margin: EdgeInsets.only(left: 10,right: 10),
                    width: MediaQuery.of(context)
                        .size.width,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('dd').format(date),
                                        style: const TextStyle(
                                            color: primarycolor, fontSize: 18),
                                      ),
                                      Text(
                                        DateFormat('MMM').format(date),
                                        style: const TextStyle(
                                            color: primarycolor, fontSize: 14),
                                      ),
                                      Text(
                                        DateFormat('yyyy').format(date),
                                        style: const TextStyle(
                                            color: primarycolor, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (circulars[index]
                                            .noticetitle
                                            .toString() !=
                                            "")
                                          Text(
                                            circulars[index].noticetitle,
                                            maxLines: null,
                                            softWrap: true,
                                            style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        if (circulars[index]
                                            .description
                                            .toString() !=
                                            "")
                                          Text(
                                            circulars[index].description,
                                            maxLines: null,
                                            softWrap: true,
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            if (circulars[index].fileext ==
                                                "xlsx" ||
                                                circulars[index].fileext == "pdf" ||
                                                circulars[index].fileext == "docx")
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: const Icon(
                                                  CupertinoIcons.doc_plaintext,
                                                  color: secondarycolor,
                                                ),
                                              ),
                                            if (circulars[index].fileext == "mp4")
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: const Icon(
                                                  CupertinoIcons.play_rectangle,
                                                  color: secondarycolor,
                                                ),
                                              ),
                                            if (circulars[index].fileext == "jpeg" ||
                                                circulars[index].fileext == "jpg" ||
                                                circulars[index].fileext == "png" ||
                                                circulars[index].fileext == "tif" ||
                                                circulars[index].fileext ==
                                                    "tiff" ||
                                                circulars[index].fileext == "gif" ||
                                                circulars[index].fileext == "bmp" ||
                                                circulars[index].fileext == "eps")
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: const Icon(
                                                  CupertinoIcons.photo,
                                                  color: secondarycolor,
                                                ),
                                              ),
                                            if (circulars[index].fileext != "jpeg" &&
                                                circulars[index].fileext != "jpg" &&
                                                circulars[index].fileext != "png" &&
                                                circulars[index].fileext != "tif" &&
                                                circulars[index].fileext !=
                                                    "tiff" &&
                                                circulars[index].fileext != "gif" &&
                                                circulars[index].fileext != "bmp" &&
                                                circulars[index].fileext != "eps" &&
                                                circulars[index].fileext != "mp4" &&
                                                circulars[index].fileext !=
                                                    "xlsx" &&
                                                circulars[index].fileext != "pdf" &&
                                                circulars[index].fileext != "docx")
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: const Icon(
                                                  CupertinoIcons.link,
                                                  color: secondarycolor,
                                                ),
                                              ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: const Divider(
                              color: grey,
                              thickness: 0.3,
                            ))
                      ],
                    );
                  }),
            ):
              Expanded(
                child: Center(
                    child: Image.asset("assets/urlnot.png")),
              );
          } else {
            return  Expanded(
              child: Center(
                  child: Image.asset("assets/volume-colorful.gif")),
            );
          }
        });
  }

  Widget _performSearch() {
    _filterList = [];
    for (int i = 0; i < titlelist.length; i++) {
      var item = titlelist[i];
      print("item : $item");
      if (item.toLowerCase().contains(_query.toLowerCase())) {
        _filterList.add(titlelist.indexOf("$item"));
      }
    }
    print("filterlist : $_filterList");
    return _createFilteredListView();
  }

  Widget _createFilteredListView() {
    return Flexible(
      child: ListView.builder(
          itemCount: _filterList.length,
          itemBuilder: (BuildContext context, int index) {
            DateTime date =
            DateTime.parse("${circulars[_filterList[index]].noticedate}");
            return Column(
              children: [
                GestureDetector(
                  onTap: (){
                    String path = p.extension(circulars[_filterList[index]].filepath);
                    if(path == ".jpg" ||
                        path == ".jpeg" ||
                        path == ".tif" ||
                        path == ".gif" ||
                        path == ".tiff" ||
                        path == ".bmp" ||
                        path == ".png" ||
                        path == ".eps"){
                      SwipeImageGallery(
                        context: context,
                        children: [
                          Image(
                              image: NetworkImage(circulars[_filterList[index]].filepath))
                        ],
                        initialIndex: 0,
                      ).show();
                    }else if(path == ".doc" ||
                        path == ".docx" ||
                        path == ".pdf" ||
                        path == ".xls" ||
                        path == ".xlsx" ||
                        path == ".ppt" ||
                        path == ".pptx" ||
                        path == ".txt"){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PreveiwImage(
                                      url: circulars[_filterList[index]]
                                          .filepath)));
                    }
                    else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WebveiwUI(
                                      url: circulars[_filterList[index]]
                                          .filepath)));
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('dd').format(date),
                            style: const TextStyle(color: primarycolor, fontSize: 18),
                          ),
                          Text(
                            DateFormat('MMM').format(date),
                            style: const TextStyle(color: primarycolor, fontSize: 14),
                          ),
                          Text(
                            DateFormat('yyyy').format(date),
                            style: const TextStyle(color: primarycolor, fontSize: 10),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (circulars[_filterList[index]]
                                .noticetitle
                                .toString() !=
                                "")
                              Text(
                                circulars[_filterList[index]].noticetitle,
                                maxLines: null,
                                softWrap: true,
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    color: secondarycolor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (circulars[_filterList[index]]
                                .description
                                .toString() !=
                                "")
                              Text(
                                circulars[_filterList[index]].description,
                                maxLines: null,
                                softWrap: true,
                                style: const TextStyle(fontSize: 15),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (circulars[_filterList[index]].fileext ==
                                    "xlsx" ||
                                    circulars[_filterList[index]].fileext ==
                                        "pdf" ||
                                    circulars[_filterList[index]].fileext ==
                                        "docx")
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: const Icon(
                                      CupertinoIcons.doc_plaintext,
                                      color: secondarycolor,
                                    ),
                                  ),
                                if (circulars[_filterList[index]].fileext ==
                                    "mp4")
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: const Icon(
                                      CupertinoIcons.play_rectangle,
                                      color: secondarycolor,
                                    ),
                                  ),
                                if (circulars[_filterList[index]].fileext ==
                                    "jpeg" ||
                                    circulars[_filterList[index]].fileext ==
                                        "jpg" ||
                                    circulars[_filterList[index]].fileext ==
                                        "png" ||
                                    circulars[
                                    _filterList[index]]
                                        .fileext ==
                                        "tif" ||
                                    circulars[_filterList[index]].fileext ==
                                        "tiff" ||
                                    circulars[_filterList[index]].fileext ==
                                        "gif" ||
                                    circulars[_filterList[index]].fileext ==
                                        "bmp" ||
                                    circulars[_filterList[index]].fileext ==
                                        "eps")
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: const Icon(
                                      CupertinoIcons.photo,
                                      color: secondarycolor,
                                    ),
                                  ),
                                if (circulars[_filterList[index]].fileext !=
                                    "jpeg" &&
                                    circulars[_filterList[index]].fileext !=
                                        "jpg" &&
                                    circulars[_filterList[index]].fileext !=
                                        "png" &&
                                    circulars[
                                    _filterList[index]]
                                        .fileext !=
                                        "tif" &&
                                    circulars[_filterList[index]].fileext !=
                                        "tiff" &&
                                    circulars[_filterList[index]].fileext !=
                                        "gif" &&
                                    circulars[_filterList[index]].fileext !=
                                        "bmp" &&
                                    circulars[_filterList[index]].fileext !=
                                        "eps" &&
                                    circulars[
                                    _filterList[index]]
                                        .fileext !=
                                        "mp4" &&
                                    circulars[_filterList[index]].fileext !=
                                        "xlsx" &&
                                    circulars[_filterList[index]].fileext !=
                                        "pdf" &&
                                    circulars[_filterList[index]].fileext !=
                                        "docx")
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: const Icon(
                                      CupertinoIcons.cloud,
                                      color: secondarycolor,
                                    ),
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // if(index == 1)
                // Container(
                //     margin: EdgeInsets.only(top:10),
                //     decoration: BoxDecoration(
                //       border: Border.all(color: borderyellow,width: 3.0),
                //       borderRadius: BorderRadius.circular(10.0),
                //     ),
                //     child: ClipRRect(
                //         borderRadius: BorderRadius.circular(10.0),
                //         child: Image.network("https://elfsight.com/wp-content/uploads/2019/08/pdf-embed_screenshot-1.jpg"))),
                // Container(
                //   height: 250,
                //   margin: EdgeInsets.only(top:10),
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     border: Border.all(color: secondarycolor.withOpacity(0.3),width: 3.0),
                //     borderRadius: BorderRadius.circular(10.0),
                //   ),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(10.0),
                //     child: SfPdfViewer.network(
                //         'https://juventudedesporto.cplp.org/files/sample-pdf_9359.pdf',
                //         canShowScrollHead:true,
                //       scrollDirection: PdfScrollDirection.vertical,
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: const Divider(
                      color: grey,
                      thickness: 0.3,
                    ))
              ],
            );
          }),
    );
  }
}

_appBar(context) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    leading: GestureDetector(
      onTap: () async{
        await getunreadcount();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            NewDashbBard(
              currentIndex: 0,
            )), (Route<dynamic> route) => false);
      },
      child: Icon(Icons.arrow_back_ios_sharp, color: secondarycolor),
    ),
    title: const Text(
      "Circulars",
      style: TextStyle(color: secondarycolor),
    ),
    centerTitle: true,
  );
}

String startdate;
String enddate;
// class DatePicker extends StatefulWidget {
//   @override
//   _DatePickerState createState() => _DatePickerState();
// }
//
// class _DatePickerState extends State<DatePicker> {
//
//   @override
//   Widget build(BuildContext context) {
//     return startdate != null && enddate != null
//         ? SfDateRangePicker(
//             rangeSelectionColor: secondarycolor,
//             rangeTextStyle: TextStyle(color: Colors.white),
//             onSelectionChanged: _onSelectionChanged,
//             selectionMode: DateRangePickerSelectionMode.range,
//           )
//         : SfDateRangePicker(
//             rangeSelectionColor: secondarycolor,
//             rangeTextStyle: TextStyle(color: Colors.white),
//             onSelectionChanged: _onSelectionChanged,
//             selectionMode: DateRangePickerSelectionMode.range,
//             initialSelectedRange: PickerDateRange(startdate, enddate),
//           );
//   }
// }

getfiletype(){

}
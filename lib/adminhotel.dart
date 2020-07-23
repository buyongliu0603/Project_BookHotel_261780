import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lin_261780/edithotel.dart';
import 'package:lin_261780/newhotel.dart';
import 'package:lin_261780/hotels.dart';
import 'package:lin_261780/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'cartscreen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:carousel_pro/carousel_pro.dart';

class AdminHotel extends StatefulWidget {
  final User user;

  const AdminHotel({Key key, this.user}) : super(key: key);

  @override
  _AdminHotelState createState() => _AdminHotelState();
}

class _AdminHotelState extends State<AdminHotel> {
  List hoteldata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "Recent";
  String cartquantity = "0";
  int quantity = 1;
  String titlecenter = "Loading Hotels List...";
  var _tapPosition;
  String server = "https://lintatt.com/bookhotels";
  String scanPrId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    Widget image_carousel = new Container(
      height: 200,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('assets/images/4.jpg'),
          AssetImage('assets/images/2.jpg'),
          AssetImage('assets/images/3.jpg'),
          AssetImage('assets/images/1.jpg'),
        ],
        autoplay: true,
        //animationCurve: Curves.fastOutSlowIn,
        // animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 2.0,
      ),
    );
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _prdController = new TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Your Hotel List',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: _visible
                ? new Icon(Icons.expand_more)
                : new Icon(Icons.expand_less),
            onPressed: () {
              setState(() {
                if (_visible) {
                  _visible = false;
                } else {
                  _visible = true;
                }
              });
            },
          ),

          //
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            image_carousel,
            Visibility(
              visible: _visible,
              child: Card(
                  elevation: 10,
                  child: Padding(
                      padding: EdgeInsets.all(5),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortItem("Recent"),
                                    color: Colors.green[300],
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.update,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Recent",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () =>
                                        _sortItem("Free Breakfast"),
                                    color: Colors.green[300],
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          Icons.free_breakfast,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Free Breakfast",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () =>
                                        _sortItem("Free Collection"),
                                    color: Colors.green[300],
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          Icons.collections,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Free Collection",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortItem("Pay at Hotel"),
                                    color: Colors.green[300],
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          Icons.payment,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Pay at Hotel",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortItem("Instant Book"),
                                    color: Colors.green[300],
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.book,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Instant Book",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortItem("Nothing"),
                                    color: Colors.green[300],
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          Icons.event_busy,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Nothing",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ))),
            ),
            Visibility(
                visible: _visible,
                child: Card(
                  elevation: 5,
                  child: Container(
                    height: screenHeight / 12.5,
                    margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Flexible(
                            child: Container(
                          height: 30,
                          child: TextField(
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              autofocus: false,
                              controller: _prdController,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.search),
                                  border: OutlineInputBorder())),
                        )),
                        Flexible(
                            child: MaterialButton(
                                color: Colors.green[300],
                                onPressed: () =>
                                    {_sortItembyName(_prdController.text)},
                                elevation: 5,
                                child: Text(
                                  "Search Hotel",
                                  style: TextStyle(color: Colors.white),
                                )))
                      ],
                    ),
                  ),
                )),
            Text(curtype,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            hoteldata == null
                ? Flexible(
                    child: Container(
                        child: Center(
                            child: Text(
                    titlecenter,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ))))
                : Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (screenWidth / screenHeight) / 0.65,
                        children: List.generate(hoteldata.length, (index) {
                          return Container(
                              child: InkWell(
                                  onTap: () => _showPopupMenu(index),
                                  onTapDown: _storePosition,
                                  child: Card(
                                      elevation: 10,
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: screenHeight / 5.9,
                                              width: screenWidth / 3.5,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  imageUrl: server +
                                                      "/images/${hoteldata[index]['id']}.jpg",
                                                  placeholder: (context, url) =>
                                                      new CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            Text(hoteldata[index]['name'],
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            Text(
                                              "Location: " +
                                                  hoteldata[index]['location'],
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              "Description: " +
                                                  hoteldata[index]
                                                      ['description'],
                                              maxLines: 1,
                                            ),
                                            Text(
                                              "RM:" +
                                                  hoteldata[index]['budget'],
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "Total Rooms:" +
                                                  hoteldata[index]['quantity'] +
                                                  "/" +
                                                  hoteldata[index]['sold'],
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))));
                        })))
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: Icon(Icons.new_releases),
              label: "New Hotel",
              labelBackgroundColor: Colors.white,
              onTap: createNewProduct),
          //SpeedDialChild(
          // child: Icon(MdiIcons.barcodeScan),
          // label: "Scan Hotel",
          // labelBackgroundColor: Colors.white, //_changeLocality()
          //onTap: () => scanProductDialog()),
          SpeedDialChild(
              child: Icon(Icons.report),
              label: "Hotel Report",
              labelBackgroundColor: Colors.white, //_changeLocality()
              onTap: () => null),
        ],
      ),
    );
  }

  void scanProductDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Select scan options:",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MaterialButton(
                  color: Color.fromRGBO(101, 255, 218, 50),
                  onPressed: scanBarcodeNormal,
                  elevation: 5,
                  child: Text(
                    "Bar Code",
                    style: TextStyle(color: Colors.black),
                  )),
              MaterialButton(
                  color: Color.fromRGBO(101, 255, 218, 50),
                  onPressed: scanQR,
                  elevation: 5,
                  child: Text(
                    "QR Code",
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          ),
        );
      },
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (barcodeScanRes == "-1") {
        scanPrId = "";
      } else {
        scanPrId = barcodeScanRes;
        Navigator.of(context).pop();
        _loadSingleProduct(scanPrId);
      }
    });
  }

  void _loadSingleProduct(String id) {
    String urlLoadJobs = server + "/php/load_hotels.php";
    http.post(urlLoadJobs, body: {
      "id": id,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        Toast.show("Not found", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          hoteldata = extractdata["hotels"];
          print(hoteldata);
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (barcodeScanRes == "-1") {
        scanPrId = "";
      } else {
        scanPrId = barcodeScanRes;
        Navigator.of(context).pop();
        _loadSingleProduct(scanPrId);
      }
    });
  }

  void _loadData() {
    String urlLoadJobs = server + "/php/load_hotels.php";
    http.post(urlLoadJobs, body: {}).then((res) {
      print(res.body);
      setState(() {
        var extractdata = json.decode(res.body);
        hoteldata = extractdata["hotels"];
        cartquantity = widget.user.quantity;
      });
    }).catchError((err) {
      print(err);
    });
  }

  void _sortItem(String type) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs = server + "/php/load_hotels.php";
      http.post(urlLoadJobs, body: {
        "description": type,
      }).then((res) {
        if (res.body == "nodata") {
          setState(() {
            curtype = type;
            titlecenter = "No hotel found";
            hoteldata = null;
          });
          pr.dismiss();
          return;
        } else {
          setState(() {
            curtype = type;
            var extractdata = json.decode(res.body);
            hoteldata = extractdata["hotels"];
            FocusScope.of(context).requestFocus(new FocusNode());
            pr.dismiss();
          });
        }
      }).catchError((err) {
        print(err);
        pr.dismiss();
      });
      pr.dismiss();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _sortItembyName(String prname) {
    try {
      print(prname);
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs = server + "/php/load_hotels.php";
      http
          .post(urlLoadJobs, body: {
            "name": prname.toString(),
          })
          .timeout(const Duration(seconds: 4))
          .then((res) {
            if (res.body == "nodata") {
              Toast.show("Hotels not found", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.dismiss();
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            }
            setState(() {
              var extractdata = json.decode(res.body);
              hoteldata = extractdata["hotels"];
              FocusScope.of(context).requestFocus(new FocusNode());
              curtype = prname;
              pr.dismiss();
            });
          })
          .catchError((err) {
            pr.dismiss();
          });
      pr.dismiss();
    } on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  gotoCart() {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CartScreen(
                    user: widget.user,
                  )));
    }
  }

  _onHotelDetail(int index) async {
    print(hoteldata[index]['name']);
    Hotel hotels = new Hotel(
        id: hoteldata[index]['id'],
        name: hoteldata[index]['name'],
        location: hoteldata[index]['location'],
        description: hoteldata[index]['description'],
        budget: hoteldata[index]['budget'],
        quantity: hoteldata[index]['quantity'],
        date: hoteldata[index]['date']);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EditHotel(
                  user: widget.user,
                  hotels: hotels,
                )));
    _loadData();
  }

  _showPopupMenu(int index) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      color: Colors.white,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        //onLongPress: () => _showPopupMenu(), //onLongTapCard(index),

        PopupMenuItem(
          child: GestureDetector(
              onTap: () => {Navigator.of(context).pop(), _onHotelDetail(index)},
              child: Text(
                "Update Hotel?",
                style: TextStyle(
                  color: Colors.green,
                ),
              )),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () =>
                  {Navigator.of(context).pop(), _deleteHotelDialog(index)},
              child: Text(
                "Delete Hotel?",
                style: TextStyle(color: Colors.green),
              )),
        ),
      ],
      elevation: 8.0,
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _deleteHotelDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Delete Hotel Id " + hoteldata[index]['id'],
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content:
              new Text("Are you sure?", style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct(index);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(int index) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting hotel...");
    pr.show();
    String bhotelid = hoteldata[index]['id'];
    print("bhotelid:" + bhotelid);
    http.post(server + "/php/delete_hotel.php", body: {
      "bhotelid": bhotelid,
    }).then((res) {
      print(res.body);
      pr.dismiss();
      if (res.body == "success") {
        Toast.show("Delete success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadData();
        Navigator.of(context).pop();
      } else {
        Toast.show("Delete failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }

  Future<void> createNewProduct() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => NewHotel()));
    _loadData();
  }
}

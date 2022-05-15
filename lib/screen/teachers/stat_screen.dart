import 'package:cloud/loadingscreens/loadingscreen.dart';
import 'package:cloud/screen/teachers/studentanswers_stat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class _graphData {
  _graphData(this.ques, this.count);

  final String ques;
  final double count;
}
class stat_screen extends StatefulWidget {
  final quizdetails,total;
  const stat_screen({Key? key,this.quizdetails,this.total}) : super(key: key);

  @override
  State<stat_screen> createState() => _stat_screenState();
}

class _stat_screenState extends State<stat_screen> {
  FirebaseFirestore store =FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
   return StreamBuilder<DocumentSnapshot>(stream:store.collection('stats').doc(widget.quizdetails.id).snapshots(),builder: (context, snapshot) {
     Map data= {};
     List <_graphData>listdata =[];
     List <_graphData>listdata2 =[];
     if(snapshot.connectionState==ConnectionState.waiting){
       return loadfadingcube();
     }
     if(snapshot.data?.data()!=null){
       data =snapshot.data?.data() as Map;
       data['answervec'].forEach((k,v){
         listdata.add(_graphData((int.parse(k)+1).toString(),double.parse(v.toString())));
       });
       data['correctvec'].forEach((k,v){
         listdata2.add(_graphData((int.parse(k)+1).toString(),double.parse(v.toString())));
       });
     }



     return Scaffold(
       backgroundColor: Colors.lightBlue[100],
       body: SafeArea(
         child: Container(
           width: MediaQuery.of(context).size.width,
           height: MediaQuery.of(context).size.height,
           child: Column(
             children: [
               Container(
                 width: MediaQuery.of(context).size.width,
                 padding: EdgeInsets.all(16),
                 decoration: BoxDecoration(
                   color: Colors.blue[500],


                 ),
                 child: Row(
                   children: [
                     IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(
                       Icons.arrow_back,size: 30,color: Colors.white,
                     )),
                     SizedBox(width: 10.0,),
                     Expanded(child: Container(

                       child: Text('${widget.quizdetails.get('title')}',overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                     ))
                   ],
                 ),
               ),

               (data!=null)?Container(
                 padding: EdgeInsets.all(16),
                 child: Container(
                   width: MediaQuery.of(context).size.width,
                   decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(10)
                   ),
                   padding: EdgeInsets.all(16),
                   child:Column(
                     children: [
                       Row(
                         children: [
                           Text('Answered'),
                           Expanded(child: SizedBox()),
                           Text('${widget.quizdetails.get('submitted').length}/${widget.total}')
                         ],
                       ),
                       SizedBox(height: 8,),
                       Row(
                         children: [
                           Text('Average'),
                           Expanded(child: SizedBox()),
                           (data['med']!=null)?Text('${data['med']}'):Text('-')
                         ],
                       )

                     ],
                   ) ,
                 ),
               ):Container(),
               Expanded(child: Container(
                 child: ListView(
                   children: [
                     Container(
                       padding: EdgeInsets.all(16),
                       child: Container(
                         decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.circular(10)
                         ),
                         child: SfCartesianChart(
                             primaryXAxis: CategoryAxis(),
                             // Chart title
                             title: ChartTitle(text: 'Questions Correctly answered'),
                             // Enable legend
                             // Enable tooltip
                             tooltipBehavior: TooltipBehavior(enable: true),
                             series: <ChartSeries<_graphData, String>>[
                               LineSeries<_graphData, String>(
                                   dataSource: listdata2,
                                   xValueMapper: (_graphData count, _) => count.ques,
                                   yValueMapper: (_graphData count, _) =>count.count,
                                   name: 'Answered',
                                   // Enable data label
                                   dataLabelSettings: DataLabelSettings(isVisible: true))
                             ]),
                       ),
                     ),
                     Container(
                       padding: EdgeInsets.all(16),
                       child: Container(
                         decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.circular(10)
                         ),
                         child: SfCartesianChart(
                             primaryXAxis: CategoryAxis(),
                             // Chart title
                             title: ChartTitle(text: 'Questions answered'),
                             // Enable legend
                             // Enable tooltip
                             tooltipBehavior: TooltipBehavior(enable: true),
                             series: <ChartSeries<_graphData, String>>[
                               LineSeries<_graphData, String>(
                                 color: Colors.red,
                                   dataSource: listdata,
                                   xValueMapper: (_graphData count, _) => count.ques,
                                   yValueMapper: (_graphData count, _) =>count.count,
                                   name: 'Answered',
                                   // Enable data label
                                   dataLabelSettings: DataLabelSettings(isVisible: true))
                             ]),
                       ),
                     ),
                   Container(
                     height: MediaQuery.of(context).size.height*0.3,
                     padding: EdgeInsets.all(16),
                     child: Container(
                       padding: EdgeInsets.all(10),
                       decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(10)
                       ),
                       child: FutureBuilder<DocumentSnapshot>(future:store.collection('assements').doc(widget.quizdetails.id).get(),builder: (context,snap){
                         List submitted =[];
                         submitted =widget.quizdetails.get('submitted');
                          return (submitted.length>0&&snap.data?.data()!=null)?ListView.builder(itemCount: submitted.length,itemBuilder: (context, index) {
                           return FutureBuilder<DocumentSnapshot>(future:store.collection('userdata').doc(submitted[index]).get(),builder: (context,snap1){
                             if(snap1.connectionState!=ConnectionState.waiting){
                               String name = snap1.data!.get('firstname')+' '+ snap1.data!.get('lastname');
                               String marks =snap.data!.get(submitted[index])['total'].toString();
                               return Column(
                                 children: [
                                   Container(
                                     decoration: BoxDecoration(
                                         color: Colors.blue[800],
                                         borderRadius: BorderRadius.circular(8)
                                     ),
                                     padding:EdgeInsets.all(8),
                                     child: Row(
                                       children: [
                                         Text(name,style: TextStyle(color: Colors.white),),
                                         Expanded(child: SizedBox()),
                                         Text(marks,style: TextStyle(color: Colors.white),),
                                         IconButton(onPressed: (){
                                           Navigator.push(context, MaterialPageRoute(builder: (context)=>studentans_stat(name: name,marks: snap.data!.get(submitted[index]),length: widget.quizdetails['Questions'].length,)));
                                         }, icon: Icon(Icons.view_list_sharp,color: Colors.white,))
                                       ],
                                     ),
                                   ),
                                   SizedBox(height: 8,)
                                 ],
                               );
                             }else{
                               return Container();
                             }
                           });
                         }):Center(
                          child: (snap.data?.data()==null)?Text('Not Evaluated'):Text('No submissions')
                         );
                       }),
                     )
                   )

                   ],
                 ),

               ))
             ],
           ),
         ),
       ),

     );
   });
  }
}

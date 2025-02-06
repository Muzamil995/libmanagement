import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: Column(

        children: [


          Center(
            child: Image.asset(
              "assets/images/smile.png",
              width: 150,
              height: 137,
              fit: BoxFit.cover,
            ),
          ),
           SizedBox(
             height:8,
           ),

          Text("Welcome Back",
          style:GoogleFonts.workSans(
            fontSize:30,
            fontWeight: FontWeight.normal,
            color: Colors.black
          )),
          SizedBox(
            height: 10,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            child: TextFormField(
                   decoration: InputDecoration(
                     hintText: "Email",
                     border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12)
                     )
                   ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: Icon(Icons.remove_red_eye),
                  suffixIconColor: Colors.grey,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)
                  )
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end
              ,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Forgot Password?",style: GoogleFonts.workSans(
                  fontSize: 16,
                  fontWeight: FontWeight.normal
                ),)
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            width: 390,
            height: 70,
            decoration: BoxDecoration(
              color: Color(0xff0098FF),
              borderRadius: BorderRadius.circular(18)

            ),
            child: Center(
              child:
              Text("Login",style: GoogleFonts.workSans(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold
              ),),
            ),
          ),
          SizedBox(height: 30,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Divider(
                color: Colors.grey,
                thickness: 2,
                height: 50,
              ),
              Text("or",style: TextStyle(fontSize: 14),),
              Divider(
                thickness: 2,
                height: 20,
                color: Colors.black,
              )
            ],
          ),
          SizedBox(
            height: 25,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),

                ),
                child: Image(image: AssetImage("assets/images/Facebook.png"),
                fit: BoxFit.cover,),
              ),
              SizedBox(
                width: 10,
              ),

              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),

                ),
                child: Image(image: AssetImage("assets/images/Google.png"),
                  fit: BoxFit.cover,),
              ),

              SizedBox(
                width: 10,
              ),
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),

                ),
                child: Image(image: AssetImage("assets/images/Apple.png"),
                  fit: BoxFit.cover,),
              ),




            ],
          ),

SizedBox(
  height: 38,
),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account?",style: GoogleFonts.workSans(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.black
              ),),
              Text("Sign up",style: GoogleFonts.workSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),)
            ],
          )


        ],
      ),
    );
  }
}
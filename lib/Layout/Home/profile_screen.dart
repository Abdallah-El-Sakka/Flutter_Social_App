import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermessenger/Cubit/home_bloc/home_cubit.dart';
import 'package:fluttermessenger/Cubit/home_bloc/home_states.dart';
import 'package:fluttermessenger/Layout/Home/edit_profile_screen.dart';
import 'package:fluttermessenger/Layout/Home/newpost_screen.dart';
import 'package:fluttermessenger/Layout/fixed_mat.dart';
import 'package:fluttermessenger/Layout/registration/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget
{

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<HomeCubit,HomeStates>(
      listener: (context,state){},
      builder: (context,state)
      {

        var cubit = HomeCubit.get(context);

        var userModel = cubit.userModel;

        return Scaffold(
          body: userModel != null ? SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  children:
                  [
                    Container(
                      height: 210,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              child: Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(userModel.cover.toString()),),
                              width: double.infinity,
                              height: 140,
                              margin: EdgeInsetsDirectional.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  topLeft: Radius.circular(15)
                                )
                              ),
                            ),
                          ),

                          CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.grey.shade100,
                            child: Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100)
                              ),
                              child: Image(
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                                image: NetworkImage(userModel.image.toString()),
                              ),
                            ),
                          )

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                          userModel!.name.toString(),
                        style: GoogleFonts.aBeeZee(
                          fontSize: 20,
                          fontWeight: FontWeight.w800
                        ),
                      ),
                    ),
                    Text(
                      userModel.bio.toString(),
                      style: Theme.of(context).textTheme.caption,
                    ),

                    SizedBox(height: 10,),


                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                        [
                          Expanded(
                            child: MaterialButton(

                              elevation: 0.0,
                              padding: EdgeInsetsDirectional.all(10),
                              focusElevation: 0.0,
                              highlightElevation: 0.0,
                              hoverElevation: 0.0,
                              disabledElevation: 0.0,
                              //shape: ,
                              color: Colors.white,
                                onPressed: ()
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewPostScreen()));
                                },
                                child: Text(
                                    'Add Posts',
                                  style: GoogleFonts.poppins(
                                    color: Colors.blue,
                                    fontSize: 15
                                  ),
                                )
                            ),
                          ),

                          SizedBox(width: 10,),

                          MaterialButton(

                            elevation: 0.0,
                            focusElevation: 0.0,
                            highlightElevation: 0.0,
                            hoverElevation: 0.0,
                            disabledElevation: 0.0,
                            padding: EdgeInsetsDirectional.all(10),
                            color: Colors.white,
                              onPressed: ()
                              {
                                Navigator.pushNamed(context, '/editProfileScreen').then((value)
                                {
                                  cubit.getUserData();
                                });
                              },
                              child: Icon(
                                  Iconsax.edit_2,
                                color: Colors.blue,
                              ),
                          ),

                          SizedBox(width: 10,),

                          MaterialButton(

                            elevation: 0.0,
                            focusElevation: 0.0,
                            highlightElevation: 0.0,
                            hoverElevation: 0.0,
                            disabledElevation: 0.0,
                            padding: EdgeInsetsDirectional.all(10),
                            color: Colors.white,
                            onPressed: ()
                            {
                              logOutUser(context);
                            },
                            child: Icon(
                              Iconsax.logout_1,
                              color: Colors.blue,
                            ),
                          )
                        ],
                      ),
                    )

                  ]
              ),
            ),
          ) : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  void logOutUser(context)
  {
    FirebaseAuth.instance.signOut().then((value)
    {
      UID = '';
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

}

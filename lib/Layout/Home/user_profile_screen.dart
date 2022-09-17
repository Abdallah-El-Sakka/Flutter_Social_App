import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermessenger/Cubit/home_bloc/home_cubit.dart';
import 'package:fluttermessenger/Cubit/home_bloc/home_states.dart';
import 'package:fluttermessenger/Layout/Home/edit_profile_screen.dart';
import 'package:fluttermessenger/Layout/fixed_mat.dart';
import 'package:fluttermessenger/Layout/registration/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class UserProfileScreen extends StatelessWidget
{

  UserData model;

  UserProfileScreen(this.model);

  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (context) => HomeCubit()..getAllUsers()..getUserData(),
      child: BlocConsumer<HomeCubit,HomeStates>(
        listener: (context,state){},
        builder: (context,state)
        {

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(icon : Icon(Iconsax.arrow_left_1,color: Colors.black,), onPressed: () { Navigator.pop(context); },),
              title: Text(
                model.name.toString(),
                style: GoogleFonts.aBeeZee(
                    fontSize: 15,
                    fontWeight: FontWeight.w600
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
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
                                  image: NetworkImage(model.cover.toString())
                                ),
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
                                  image: NetworkImage(model.image.toString()),
                                ),
                              ),
                            )

                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          model.name.toString(),
                          style: GoogleFonts.aBeeZee(
                              fontSize: 20,
                              fontWeight: FontWeight.w800
                          ),
                        ),
                      ),
                      Text(
                        model.bio.toString(),
                        style: Theme.of(context).textTheme.caption,
                      ),

                      SizedBox(height: 10,),

                    ]
                ),
              ),
            ),
          );
        },
      ),
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

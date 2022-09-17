import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermessenger/Cubit/home_bloc/home_cubit.dart';
import 'package:fluttermessenger/Layout/Home/user_profile_screen.dart';

import '../../Cubit/home_bloc/home_states.dart';

class UsersScreen extends StatelessWidget
{

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var cubit = HomeCubit.get(context);

        return Scaffold(
          body: cubit.users.isNotEmpty ? SafeArea(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => userCard(
                  context,
                  index,
                  cubit.users[index]
              ),
              itemCount: cubit.users.length,
            ),
          ) : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget userCard(context , index , UserData model) => InkWell(
    onTap: ()
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen(model)));
    },
    child: Container(
      margin: EdgeInsetsDirectional.only(
          start: 10,
          end: 10,
          top: 5,
          bottom: 5
      ),
      padding: EdgeInsetsDirectional.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white
      ),
      child: Column(
        children:
        [
          Row(
            children:
            [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blue
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image(image: NetworkImage(model.image.toString()), fit: BoxFit.cover,),
              ),
              SizedBox(width: 10,),
              Text(
                model.name.toString(),
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800
                ),
              ),
            ],
          ),

        ],
      ),
    ),
  );

}

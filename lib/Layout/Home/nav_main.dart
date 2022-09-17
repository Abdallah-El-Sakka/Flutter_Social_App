import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermessenger/Cubit/home_bloc/home_cubit.dart';
import 'package:fluttermessenger/Cubit/home_bloc/home_states.dart';
import 'package:fluttermessenger/Layout/Home/chats_screen.dart';
import 'package:fluttermessenger/Layout/Home/profile_screen.dart';
import 'package:fluttermessenger/Layout/Home/users_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'home_screen.dart';
import 'newpost_screen.dart';

class NavHome extends StatefulWidget
{
  @override
  State<NavHome> createState() => _NavHomeState();
}

class _NavHomeState extends State<NavHome>
{
  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (context) => HomeCubit()..getPosts()..getUserData(),
      child: BlocConsumer<HomeCubit,HomeStates>(
        listener: (context, state) {},
        builder: (context, state)
        {

          var cubit = HomeCubit.get(context);

          // int navIndex = 0;

          List<String> titles =
          [
            'Feed',
            'Chats',
            'Users',
            'Profile'
          ];

          List<Widget> screens =
          [
            HomeScreen(),
            ChatsScreen(),
            UsersScreen(),
            ProfileScreen(),
          ];

          return Scaffold(
            appBar: AppBar(

              automaticallyImplyLeading: false,

              title: Text(
                  titles[cubit.navIndex],
                style: GoogleFonts.aBeeZee(),
              ),
              actions:
              [
                IconButton(
                    onPressed: ()
                    {
                      Navigator.pushNamed(context, '/newPostScreen').then((value)
                      {
                        cubit.getPosts();
                      });
                    },
                    icon: Icon(Iconsax.add_square4 , color: Colors.red,)),
              ],

            ),
            body: screens[cubit.navIndex],
            bottomNavigationBar: SlidingClippedNavBar(
              selectedIndex: cubit.navIndex,
              onButtonPressed: (index)
              {
                cubit.changeScreen(index);

              },
              barItems:
              [
                BarItem(
                  icon: Iconsax.home_24,
                  title: 'Home',
                ),
                BarItem(
                  icon: Iconsax.bubble4,
                  title: 'Chats',
                ),

                BarItem(
                  icon: Iconsax.location_add,
                  title: 'Users',
                ),
                BarItem(
                  icon: Iconsax.user4,
                  title: 'Profile',
                ),
              ],
              activeColor: Colors.red,
              backgroundColor: Colors.white,
              iconSize: 20,
              fontSize: 15,
              inactiveColor: Colors.black.withOpacity(0.3),
            ),
          );
        },
      ),
    );
  }
}

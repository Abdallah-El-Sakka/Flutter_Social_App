import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermessenger/Cubit/home_bloc/home_cubit.dart';
import 'package:fluttermessenger/Cubit/home_bloc/home_states.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class EditProfileScreen extends StatefulWidget
{

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (context) => HomeCubit()..getUserData(),
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state)
        {

          var cubit = HomeCubit.get(context);

          var userModel = cubit.userModel;

          var profileImg = HomeCubit.get(context).profileImage;

          var coverImg = HomeCubit.get(context).coverImage;

          var nameController = TextEditingController(text: userModel != null ? userModel.name.toString() : '');

          var bioController  = TextEditingController(text: userModel != null ? userModel.bio.toString() : '');

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  color: Colors.black,
                  onPressed: ()
                  {
                    Navigator.pop(context);
                  },
                  icon : Icon(Iconsax.arrow_left_2)
              ),
              title: Text(
                'Edit Profile',
                style: GoogleFonts.aBeeZee(),
              ),
              centerTitle: true,
              actions:
              [
                !(state is UploadCoverImgLoadingState || state is UploadProfileImgLoadingState) ? IconButton(
                  onPressed: ()
                  {
                    cubit.updateUserData(
                        name: nameController.text.toString(),
                        bio: bioController.text.toString(),
                      image: cubit.profileImgUrl,
                      cover: cubit.coverImgUrl
                    ).then((value)
                    {
                      //Navigator.pop(context);
                    });

                  },

                  icon: Icon(Icons.check_rounded),
                  color: Colors.blue,
                ) : Center(child: CircularProgressIndicator()),
                SizedBox(width: 10,)
              ],
            ),
            body: userModel != null ? SingleChildScrollView(
              child: Column(
                  children:
                  [
                    Container(
                      height: 210,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children:
                        [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Stack(
                              alignment: Alignment.topRight,
                              children:
                              [
                                Container(
                                  clipBehavior: Clip.antiAlias,
                                  width: double.infinity,
                                  height: 140,
                                  margin: EdgeInsetsDirectional.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15)
                                      )
                                  ),
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: coverImg == null ? NetworkImage(userModel.cover.toString()) : FileImage(coverImg) as ImageProvider,
                                  ),
                                ),

                                ElevatedButton(
                                    onPressed: ()
                                    {
                                      cubit.getCoverImage();
                                    },
                                  child: Icon(Iconsax.camera4,color: Colors.black,size: 20,),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(5),
                                    elevation: 0.0,
                                    backgroundColor: Colors.white
                                  ),
                                )
                              ],
                            ),
                          ),

                          Stack(
                            alignment: Alignment.bottomRight,
                            children:
                            [
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
                                    image: profileImg == null ? NetworkImage(userModel.image.toString()) : FileImage(profileImg) as ImageProvider,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: ()
                                {
                                  cubit.getProfileImage();
                                },
                                child: Icon(Iconsax.camera4,color: Colors.black,size: 20,),
                                style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(5),
                                    elevation: 0.0,
                                    backgroundColor: Colors.white
                                ),
                              )
                            ],
                          )

                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        enabled: !(state is UploadCoverImgLoadingState || state is UploadProfileImgLoadingState),
                        controller: nameController,
                        decoration: InputDecoration(
                          label: Text('Name'),
                          prefixIcon: Icon(Iconsax.user4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                          )
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        controller: bioController,
                        autocorrect: true,
                        enabled: !(state is UploadCoverImgLoadingState || state is UploadProfileImgLoadingState),
                        maxLength: 30,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          label: Text('Bio'),
                          prefixIcon: Icon(Iconsax.info_circle4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),

                        ),
                      ),
                    ),


                  ]
              ),
            ) : Center(child: CircularProgressIndicator()),
          );

        },
      ),
    );
  }
}

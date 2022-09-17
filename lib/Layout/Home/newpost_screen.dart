import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermessenger/Cubit/home_bloc/home_cubit.dart';
import 'package:fluttermessenger/Cubit/home_bloc/home_states.dart';
import 'package:fluttermessenger/Layout/fixed_mat.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class NewPostScreen extends StatefulWidget
{

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (context) => HomeCubit()..getUserData(),
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state)
        {
          if(state is CreatePostSuccessState)
          {
            postText = '';
            Navigator.pop(context);
          }
        },
        builder: (context, state)
        {

          var cubit = HomeCubit.get(context);

          var postTextController = TextEditingController(text: postText);

          bool isLoading = (state is UploadPostPhotoLoadingState || state is CreatePostLoadingState);

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
                'Create Post',
                style: GoogleFonts.aBeeZee(),
              ),
              actions:
              [

                 isLoading
                    ?
                Container(
                  margin: EdgeInsetsDirectional.only(end: 10),
                    child: Center(child: CircularProgressIndicator())
                )
                    :
                IconButton(
                    onPressed: ()
                    {
                      if(postTextController.text.isNotEmpty)
                      {
                            String date = DateTime.now().toString();

                            if (cubit.postImage == null)
                            {
                              cubit
                                  .createPost(
                                      text: postTextController.text, date: date)
                                  .then((value) {
                                //Navigator.pop(context);
                              });
                            }
                            else
                            {
                              cubit
                                  .uploadPostImage(
                                      text: postTextController.text, date: date)
                                  .then((value) {
                                //Navigator.pop(context);
                              });
                            }
                          }
                        },
                    icon: Icon(Iconsax.send_2, color: Colors.blue,)
                )

              ],
            ),
            body: cubit.userModel != null ? Column(
                children:
                [
                  Row(
                    children:
                    [
                      Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsetsDirectional.all(20),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100)
                        ),
                        child: Image(
                          fit: BoxFit.cover,
                          height: 50,
                          width: 50,
                          image: NetworkImage(cubit.userModel!.image.toString()),
                        ),
                      ),

                      Text(
                          cubit.userModel!.name.toString(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700
                        ),
                      )
                    ],
                  ),

                  Expanded(
                    child: Container(
                      margin: EdgeInsetsDirectional.only(
                        start: 20,
                        end: 20,
                        bottom: 20
                      ),
                      child: TextFormField(
                        maxLines: null,
                        minLines: null,
                        expands: true,
                        controller: postTextController,
                        keyboardType: TextInputType.multiline,
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          hintText: "What's on your mind ?",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  if(cubit.postImage != null)

                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          margin: EdgeInsetsDirectional.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Image(
                              image: FileImage(cubit.postImage!),
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          margin: EdgeInsetsDirectional.all(10),
                          child: ElevatedButton(
                            onPressed: ()
                            {
                              cubit.removePostImage();
                            },
                            child: Icon(Icons.clear_rounded,color: Colors.black,size: 20,),
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(5),
                                elevation: 0.0,
                                backgroundColor: Colors.white
                            ),
                          ),
                        )
                      ],
                    ),

                  Container(
                    margin: EdgeInsetsDirectional.all(10),
                    child: Row(
                      children:
                      [
                        Expanded(
                          child: TextButton(
                              onPressed: ()
                              {
                                postText = postTextController.text;
                                cubit.getPostImage();
                              }
                              , child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children:
                            [
                              Icon(Iconsax.gallery),
                              SizedBox(width: 5,),
                              Text('Add Photo')
                            ],
                          ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: TextButton(
                              onPressed: (){}
                              , child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children:
                            [
                              Icon(Iconsax.emoji_happy),
                              SizedBox(width: 5,),
                              Text('Add Emojis')
                            ],
                          )
                          ),
                        ),
                      ],
                    ),
                  )

                ]
            ) : Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

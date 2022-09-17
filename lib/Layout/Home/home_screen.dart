import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermessenger/Cubit/home_bloc/home_cubit.dart';
import 'package:fluttermessenger/Cubit/home_bloc/home_states.dart';

import '../fixed_mat.dart';

class HomeScreen extends StatelessWidget
{

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<HomeCubit,HomeStates>(
        listener: (context,state) {},
        builder: (context,state)
        {

          var cubit = HomeCubit.get(context);

          return Scaffold(
            body: SafeArea(
              child: ListView.builder(
                  itemBuilder: (context, index) => postCard(context, cubit.posts[index], cubit , index),
                physics: BouncingScrollPhysics(),
                itemCount: cubit.posts.length,
              ),
            ),
          );
        },
    );
  }

  Widget postCard(context, PostModel model, cubit, index) => Container(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                Text(
                  model.name.toString(),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800
                  ),
                ),
                Text(
                  model.date.toString(),
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
            Spacer(),
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.more_horiz_rounded),
              padding: EdgeInsets.zero,
              hoverColor: Colors.grey.shade200,
              focusColor: Colors.grey.shade200,
            )
          ],
        ),

        Container(
          height: 1,
          width: double.infinity,
          color: Colors.black.withOpacity(0.05),
          margin: EdgeInsetsDirectional.only(
              start: 50,
              end: 50,
              top: 20,
              bottom: 20
          ),
        ),

        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsetsDirectional.only(
              start: 10,
              end: 10
          ),
          child: Text(
            model.text.toString()
          ),
        ),

        if(model.postImage != null)
          Container(
          height: 200,
          width: double.infinity,
          margin: EdgeInsetsDirectional.only(
              top: 20,
              bottom: 10
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image(image: NetworkImage(model.postImage.toString()) ,fit: BoxFit.cover, ),
        ),

        if(model.postImage == null)
          Container(
          height: 1,
          width: double.infinity,
          color: Colors.black.withOpacity(0.05),
          margin: EdgeInsetsDirectional.only(
              start: 50,
              end: 50,
              top: 20,
              bottom: 5
          ),
        ),

        Row(
          children:
          [
            IconButton(
              onPressed: ()
              {
                cubit.likePost(cubit.postsIds[index]);
              },
                icon: Icon(
                  find(cubit.likes[cubit.postsIds[index]]??[] , UID) ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                  color: find(cubit.likes[cubit.postsIds[index]]??[] , UID) ? Colors.red : Colors.grey,
                  size: 20,
                )
            ),
            SizedBox(width: 5,),
            Text(
              cubit.likes[cubit.postsIds[index]] != null
                  ?
              (cubit.likes[cubit.postsIds[index]].length - 1).toString()
              :
              '0'
              ,
              style: TextStyle(
                  color: Colors.grey
              ),
            ),

            SizedBox(width: 10,),

            IconButton(
                icon: Icon(Icons.chat_bubble_outline_rounded,color: Colors.grey,size: 20,),
              onPressed: (){},
            ),
            SizedBox(width: 5,),
            Text(
              '0',
              style: TextStyle(
                  color: Colors.grey
              ),
            ),
          ],
        ),

      ],
    ),
  );

}

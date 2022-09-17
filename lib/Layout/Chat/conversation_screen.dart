import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermessenger/Cubit/chats_bloc/chats_cubit.dart';
import 'package:fluttermessenger/Cubit/home_bloc/home_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../Cubit/chats_bloc/chats_states.dart';
import '../fixed_mat.dart';

class ConversationScreen extends StatelessWidget
{

  UserData model;

  var messageController = TextEditingController();

  var listViewController = ScrollController();

  ConversationScreen({required this.model});

  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (context) => ChatsCubit()..getMessages(receiverId: model.uid!),
      child: BlocConsumer<ChatsCubit, ChatsStates>(
        listener: (context, state){},
        builder: (context, state)
        {

          var cubit = ChatsCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(icon : Icon(Iconsax.arrow_left_1,color: Colors.black,), onPressed: () { Navigator.pop(context); },),
              title: Row(
                children:
                [
                  Container(
                    width: 40,
                    height: 40,
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
                    style: GoogleFonts.aBeeZee(
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
            ),
            body:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [

                  Expanded(
                      child:ListView.builder(
                        controller: listViewController,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index)
                          {
                            bool isMyMsg = cubit.messages[index].senderID == UID;
                            return messageBuilder(isMyMsg, cubit.messages[index]);
                          },
                        itemCount: cubit.messages.length,
                      )
                  ),

                  Container(
                    height: 60,
                    margin: EdgeInsetsDirectional.all(10),

                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1.0
                      ),
                      borderRadius: BorderRadiusDirectional.circular(20),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: TextFormField(
                              controller: messageController,
                              decoration: InputDecoration(
                                hintText: 'Enter yout message.',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none
                                )
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 10,),

                        MaterialButton(
                          minWidth: 1.0,
                            height: double.infinity,
                            color: Colors.blue,
                            onPressed: () async
                            {
                              if(messageController.text.isNotEmpty)
                              {
                                cubit.sendMessage(
                                    receiverID: model.uid!,
                                    date: DateTime.now().toString(),
                                    text: messageController.text.trim()
                                ).then((value)
                                {
                                  listViewController.animateTo(
                                      listViewController.position.maxScrollExtent,
                                      duration: Duration(milliseconds: 150),
                                      curve: Curves.easeOut
                                  );
                                  messageController.text = '';
                                });

                              }
                            },
                          child: Icon(Iconsax.send_1, color: Colors.white,),
                        )
                      ],
                    ),
                  )
                ]
            ),
          );
        },

      ),
    );
  }

  Widget messageBuilder(bool isMyMsg, MessageModel message) =>
      Align(
        alignment: isMyMsg ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd ,
        child: Container(

          margin: EdgeInsetsDirectional.all(10),
          padding: EdgeInsetsDirectional.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(20),
              topEnd: isMyMsg ? Radius.circular(20) : Radius.circular(0),
              topStart: isMyMsg ? Radius.circular(0) : Radius.circular(20),
              bottomStart: Radius.circular(20),

            ),
            color: isMyMsg? Colors.blue.withOpacity(0.3) : Colors.black.withOpacity(0.1),
          ),
          child: Text(
              message.text!.trim(),
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600
            ),
          ),
  ),
      );


}

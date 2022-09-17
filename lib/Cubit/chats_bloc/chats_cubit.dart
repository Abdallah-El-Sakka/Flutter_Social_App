import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Layout/fixed_mat.dart';
import 'chats_states.dart';

class ChatsCubit extends Cubit<ChatsStates>
{

  ChatsCubit() : super(ChatsInitialState());

  static ChatsCubit get(context) => BlocProvider.of(context);

  Future<void> sendMessage({
    required String receiverID,
    required String date,
    required String text
  }) async
  {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(UID)
        .collection('chats')
        .doc(receiverID)
        .collection('messages')
        .add(
        {
          'text' : text,
          'senderID' : UID,
          'receiverID' : receiverID,
          'date' : date
        })
        .then((value)
    {
      emit(SendMessageSuccessState());
    })
        .catchError((onError)
    {
      emit(SendMessageErrorState());
    });


    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverID)
        .collection('chats')
        .doc(UID)
        .collection('messages')
        .add(
        {
          'text' : text,
          'senderID' : UID,
          'receiverID' : receiverID,
          'date' : date
        })
        .then((value)
    {
      emit(SendMessageSuccessState());
    })
        .catchError((onError)
    {
      emit(SendMessageErrorState());
    });

  }

  List<MessageModel> messages = [];
  
  void getMessages({
    required String receiverId,
  })
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(UID)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('date')
        .snapshots()
        .listen((event)
    {

      messages.clear();

      event.docs.forEach((element)
      {
        messages.add(MessageModel.fromFire(element.data()));
      });

      emit(GetMessageSuccessState());
    });
  }

}

class MessageModel
{
  String? receiverID;
  String? senderID;
  String? dateTime;
  String? text;

  MessageModel(
  {
    required this.text,
    required this.receiverID,
    required this.senderID,
    required this.dateTime,
  });

  MessageModel.fromFire(Map<String, dynamic> fireBase)
  {
    text = fireBase['text'];
    receiverID = fireBase['receiverID'];
    senderID = fireBase['senderID'];
    dateTime = fireBase['date'];
  }

}
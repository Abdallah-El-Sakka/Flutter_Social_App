import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermessenger/Cubit/register_bloc/register_states.dart';
import 'package:fluttermessenger/cache/shared_pref.dart';

class RegisterCubit extends Cubit<RegisterStates>
{
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void changeVisibility()
  {
    emit(UpdatePassVisibility());
  }

  void registerNewUser({
    required name,
    required email,
    required password,
    required phone,
  })
  {
    emit(RegisterNewUserLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value)
    {
      print('Registered Successfully');

      userSaveData(
          name: name,
          email: email,
          phone: phone,
          UID: value.user!.uid ,
          password: password,
          image : 'https://firebasestorage.googleapis.com/v0/b/flutter-messenger-935da.appspot.com/o/profile.png?alt=media&token=0268f38d-140c-465f-8eaf-f930cd6546ec',
          cover : 'https://firebasestorage.googleapis.com/v0/b/flutter-messenger-935da.appspot.com/o/cover.png?alt=media&token=624801dc-099f-4da5-979c-4ccebe676dcb',
          bio : 'Enter your bio here',
          isVerified: false,
      );

      CacheHelper.saveValue(key: 'UID', value: value.user!.uid);

      emit(RegisterNewUserSuccessState());

    }).catchError((onError)
    {
      print(onError.toString());

      print(onError.toString());

      emit(RegisterNewUserErrorState());

    });
  }
  
  void loginUser({
    required email,
    required password
  })
  {
    emit(LoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((value)
    {

      print('Logged in Successfully');

      CacheHelper.saveValue(key: 'UID', value: value.user!.uid);

      emit(LoginSuccessState());

    }).catchError((onError)
    {
      print(onError.toString());

      print(onError.toString());

      emit(LoginErrorState());
    });
  }


  void userSaveData({
    required String name,
    required String email,
    required String phone,
    required String UID,
    required String password,
    required String image,
    required String cover,
    required String bio,
    required bool isVerified
  })
  {
    FirebaseFirestore.instance.collection('users').doc(UID).set(
        {
          'name'     : name,
          'email'    : email,
          'phone'    : phone,
          'password' : password,
          'isVerified' : isVerified,
          'image' : image,
          'cover' : cover,
          'bio' : bio,
          'uid' : UID
        }).then((value)
        {
          emit(SaveDataSuccessState());
        }).catchError((onError)
        {

          print(onError.toString());

          emit(SaveDataErrorState());
        });
  }

}
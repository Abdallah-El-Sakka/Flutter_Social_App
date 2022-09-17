import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermessenger/Cubit/home_bloc/home_states.dart';
import 'package:image_picker/image_picker.dart';
import '../../Layout/fixed_mat.dart';
import '../../cache/shared_pref.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomeCubit extends Cubit<HomeStates>
{
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  UserData? userModel;

  void getUserData() async
  {
    emit(HomeGetUserDataLoadingState());

    UID = await CacheHelper.getValue(key: 'UID') ?? UID;

    FirebaseFirestore.instance.collection('users').doc(UID).get().then((value)
    {

      userModel = UserData.fromFire(value.data()!);
      emit(HomeGetUserDataSuccessState());

    }).catchError((onError) {
      print(onError.toString());
      emit(HomeGetUserDataErrorState());
    });
  }

  Future<void> updateUserData({
    required name,
    required bio,
    required image,
    required cover
  }) async {
    emit(UpdateUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(UID).update({
      'name': name,
      'bio': bio,
      'image' : image ?? userModel!.image,
      'cover' : cover ?? userModel!.cover
    }).then((value) {
      getUserData();
      emit(UpdateUserSuccessState());
    }).catchError((error)
    {
      print(error);
      emit(UpdateUserErrorState());
    });
  }

  int navIndex = 0;

  void changeScreen(int index)
  {

    if(index == 1)
    {
      getAllUsers();
    }

    navIndex = index;
    emit(ChangeBottomNavState());

  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async
  {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null)
    {
      profileImage = File(pickedFile.path);
      emit(ChangeProfileImgSuccessState());
      uploadProfileImg();
    }
    else
    {
      print('No image selected.');
      emit(ChangeProfileImgErrorState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async
  {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null)
    {
      coverImage = File(pickedFile.path);
      emit(ChangeCoverImgSuccessState());
      uploadCoverImg();
    }
    else
    {
      print('No image selected.');
      emit(ChangeCoverImgErrorState());
    }
  }

  final storage = FirebaseStorage.instance;

  String? profileImgUrl;

  String? coverImgUrl;

  Future<void> uploadProfileImg() async
  {
    emit(UploadProfileImgLoadingState());

    storage
        .ref()
        .child('UsersProfileImages/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) async
    {
      emit(UploadProfileImgSuccessState());

      profileImgUrl = await value.ref.getDownloadURL();

    }
    ).catchError((onError)
    {
      print(onError.toString());
      emit(UploadProfileImgErrorState());
    }
    );
  }

  Future<void> uploadCoverImg() async
  {

    emit(UploadCoverImgLoadingState());

    storage
        .ref()
        .child('UsersCoverImages/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) async
    {
      emit(UploadProfileImgSuccessState());

      coverImgUrl = await value.ref.getDownloadURL();

    }
    ).catchError((onError)
    {
      print(onError.toString());
      emit(UploadProfileImgErrorState());
    }
    );
  }

  String? uId;
  String? name;
  String? image;
  String? postPhoto;
  String? text;
  String? date;

  File? postImage;

  void removePostImage()
  {
    postImage = null;
    emit(RemovePostImageState());
  }

  Future<void> getPostImage() async
  {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null)
    {
      postImage = File(pickedFile.path);
      emit(GetPostPhotoSuccessState());
    }
    else
    {
      print('No image selected.');
      emit(GetPostPhotoErrorState());
    }
  }

  Future<void> uploadPostImage({text , date})
  async {
    emit(UploadPostPhotoLoadingState());

    FirebaseStorage.instance.ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!).then((value)
    {
      emit(UploadPostPhotoSuccessState());

      value.ref.getDownloadURL().then((value)
      {
        createPost(postImage: value, text: text, date: date);
      });

    }
    ).catchError((onError)
    {
      emit(UploadPostPhotoErrorState());
    });

  }


  Future<void> createPost(
  {
    String? postImage,
    required String? text,
    required String? date,
  }) async
  {
    emit(CreatePostLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .add(
        {
          'name'      : userModel!.name,
          'image'     : userModel!.image,
          'uid'       : UID,
          'text'      : text,
          'date'      : date,
          'postImage' : postImage
        })
        .then((value)
    {

      value
          .collection('likes')
          .doc(UID)
          .set(
          {
            'like' : false
          });

      emit(CreatePostSuccessState());
    }
    )
        .catchError((onError)
    {
      emit(CreatePostErrorState());
    });

  }


  List<PostModel> posts  = [];
  List<String> postsIds  = [];
  Map<String, List<String>> likes = {};

  void getPosts() async
  {

    emit(GetPostsLoadingState());

    await FirebaseFirestore.instance.collection('posts').get()
        .then((value) async
    {

      posts.clear();
      postsIds.clear();

      value.docs.forEach((element)
      {
        posts.add(PostModel.fromFire(element.data()));
        postsIds.add(element.id);
      }

      );

      getPostsLikes();

      emit(GetPostsSuccessState());

    }).catchError((onError)
    {
      emit(GetPostsErrorState());
    });

  }

  void likePost(String postId) async
  {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(UID)
        .set(
        {
          'like' : true
        }
        )
        .then((value)
    {
      emit(LikePostSuccessState());
      getPosts();
    }
    )
        .catchError((onError)
    {
      emit(LikePostErrorState());
    }
    );
  }

  void getPostsLikes() async
  {

    emit(GetLikesLoadingState());

    await FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value)
    {

      value.docs.forEach((element) async
      {

        List<String> tempList = [];

        await FirebaseFirestore.instance.collection('posts').doc(element.id).collection('likes').get()
            .then((value) async
        {
          value.docs.forEach((element)
          {
            tempList.add(element.id);
          });
        }
        );

        likes.addAll(
            {
              element.id : tempList
            }
            );
      });

      emit(GetLikesSuccessState());

    }).catchError((onError)
    {
      print('Error : ' + onError.toString());
      emit(GetLikesErrorState());
    }
    );

  }

  List<UserData> users = [];

  void getAllUsers()
  {
    users.clear();
    emit(GetAllUsersLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value)
    {
      value.docs.forEach((element)
      {
        if(element.data()['uid'] != UID)
          users.add(UserData.fromFire(element.data()));
      });
      emit(GetLikesSuccessState());
    }).catchError((onError)
    {
      emit(GetAllUsersErrorState());
    });
  }

}

class UserData
{
  String? name;
  String? email;
  String? password;
  String? phone;
  String? image;
  String? cover;
  String? bio;
  bool? isVerified;
  String? uid;

  UserData({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.isVerified,
    required this.image,
    required this.bio,
    required this.cover,
    required this.uid,
  });

  UserData.fromFire(Map<String, dynamic> fire) {
    name = fire['name'];
    email = fire['email'];
    password = fire['password'];
    phone = fire['phone'];
    isVerified = fire['isVerified'];
    image = fire['image'];
    bio = fire['bio'];
    cover = fire['cover'];
    uid = fire['uid'];
  }
}

class PostModel
{
  String? uid;
  String? name;
  String? image;
  String? postImage;
  String? text;
  String? date;

  PostModel(
  {
    required this.text,
    required this.uid,
    required this.name,
    required this.image,
    required this.postImage,
    required this.date,
  });

  PostModel.fromFire(Map<String, dynamic> fire)
  {
    name = fire['name'];
    image = fire['image'];
    text = fire['text'];
    uid = fire['uid'];
    postImage = fire['postImage'];
    date = fire['date'];
  }

}

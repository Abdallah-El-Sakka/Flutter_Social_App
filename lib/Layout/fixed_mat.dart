import 'package:cloud_firestore/cloud_firestore.dart';

String UID = '';

String postText = '';

bool emailVerify (String email)
{

  int checker = 0;

  int indexOfAt = email.length;

  for(int i = 0 ; i < email.length ; i++)
  {

    if(email[i] == '@')
    {
      checker++;
      indexOfAt = i;
    }
    else if(email[i] == '.' && i > indexOfAt)
    {
      checker++;
    }
  }

  return checker >= 2 ? true : false;

}

bool find(List<dynamic> list, finder)
{

  for(int i = 0 ; i < list.length ; i++)
  {
    if(list[i] == finder)
    {
      return true;
    }
  }

  return false;
}

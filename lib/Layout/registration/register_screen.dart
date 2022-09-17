import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermessenger/Layout/Home/home_screen.dart';
import 'package:fluttermessenger/Layout/Home/nav_main.dart';
import '../../Cubit/register_bloc/register_states.dart';
import '../../Cubit/register_bloc/registring_cubit.dart';
import '../fixed_mat.dart';

class RegisterScreen extends StatelessWidget
{

  @override
  Widget build(BuildContext context)
  {

    var formKey = GlobalKey<FormState>();

    var emailController    = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();

    var passHidden = true;

    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        builder: (context, state)
        {

          var cubit = RegisterCubit.get(context);

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsetsDirectional.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:
                      [

                        Container(
                          margin: EdgeInsetsDirectional.all(20),
                          child: Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsetsDirectional.all(20),
                          child: TextFormField(
                            validator: (value)
                            {
                              if(value!.isEmpty) return 'Enter your name';
                            },
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                label: Text('Name'),
                                prefixIcon: Icon(Icons.person_outline_rounded),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)
                                )
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsetsDirectional.all(20),
                          child: TextFormField(
                            validator: (value)
                            {
                              if(!emailVerify(value!) || value.isEmpty) return 'Enter a valid email';
                            },
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                label: Text('Email'),
                                prefixIcon: Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)
                                )
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsetsDirectional.all(20),
                          child: TextFormField(
                            controller: passwordController,
                            validator: (value)
                            {
                              if(value!.isEmpty) return 'Password is empty';
                            },

                            obscureText: passHidden,

                            keyboardType: TextInputType.visiblePassword,

                            decoration: InputDecoration(
                                label: Text('Password'),
                                prefixIcon: Icon(Icons.lock_outline_rounded),
                                suffixIcon: IconButton(
                                    onPressed: ()
                                    {
                                      passHidden = !passHidden;
                                      cubit.changeVisibility();
                                    },
                                    icon : Icon(Icons.remove_red_eye)
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)
                                )
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsetsDirectional.all(20),
                          child: TextFormField(
                            validator: (value)
                            {
                              if(value!.isEmpty) return 'Enter your phone';
                            },
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                label: Text('Phone'),
                                prefixIcon: Icon(Icons.phone_outlined),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)
                                )
                            ),
                          ),
                        ),

                        state is RegisterNewUserLoadingState
                        ?
                        Container(
                          margin: EdgeInsetsDirectional.all(22),
                            child: CircularProgressIndicator()
                        )
                        :
                        Container(
                          margin: EdgeInsetsDirectional.all(20),
                          child: MaterialButton(
                            padding: EdgeInsetsDirectional.all(20),
                            elevation: 0.0,
                            onPressed: ()
                            {
                              if(formKey.currentState!.validate())
                              {
                                cubit.registerNewUser(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text
                                );
                              }

                            },
                            child: Text('Register'),
                            textColor: Colors.white,
                            color: Colors.blue,
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                          [
                            Text("Already have an account ?"),
                            TextButton(
                                onPressed: ()
                                {
                                  Navigator.pop(context);
                                },
                                child: Text('Login now.')
                            )
                          ],
                        )

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, Object? state)
        {
          if(state is SaveDataSuccessState)
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavHome()));
          }
        },

      ),
    );
  }
}

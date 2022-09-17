import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermessenger/Cubit/register_bloc/register_states.dart';
import 'package:fluttermessenger/Cubit/register_bloc/registring_cubit.dart';
import 'package:fluttermessenger/Layout/Home/nav_main.dart';
import 'package:fluttermessenger/Layout/fixed_mat.dart';
import 'package:fluttermessenger/Layout/registration/register_screen.dart';

class LoginScreen extends StatelessWidget
{

  @override
  Widget build(BuildContext context)
  {

    var formKey = GlobalKey<FormState>();

    var emailController    = TextEditingController();
    var passwordController = TextEditingController();

    var passHidden = true;

    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        builder: (context, state)
        {

          var cubit = RegisterCubit.get(context);

          return Scaffold(
            body: SafeArea(
              child: Center(
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
                              'Login',
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
                                if(!emailVerify(value!) || value.isEmpty) return 'Enter a valid email';
                              },
                              controller: emailController,
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

                          state is LoginLoadingState
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
                                  cubit.loginUser(
                                      email: emailController.text,
                                      password: passwordController.text
                                  );
                                }
                              },
                              child: Text('Login'),
                              textColor: Colors.white,
                              color: Colors.blue,
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                            [
                              Text("Doesn't have an account ?"),
                              TextButton(
                                  onPressed: ()
                                  {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                                  },
                                  child: Text('Register now.')
                              )
                            ],
                          )

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, Object? state)
        {
          if(state is LoginSuccessState)
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavHome()));
          }
        },

      ),
    );
  }
}


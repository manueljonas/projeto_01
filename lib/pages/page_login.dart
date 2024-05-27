import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/page_register.dart';
import '../pages/page_forget_password.dart';
import '../utils/app_routes.dart';

class LoginPage extends StatefulWidget with ChangeNotifier {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => FirebaseAuth.instance.currentUser;

  void _loginUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Navegue para a tela de pedidos após o login
      Navigator.of(context).pushNamed(
        AppRoutes.HOME_PAGE,
      );
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Usuário não encontrado.');
      } else if (e.code == 'wrong-password') {
        print('Senha incorreta.');
      } else {
        print('Erro desconhecido: ${e.code}');
      }
    }
  }

  void _logoutUser(BuildContext context) async {
    await _auth.signOut();
    notifyListeners();
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    //final providerLogin = Provider.of<LoginPage>(context);
    final providerLogin = Provider.of<LoginPage>(
      context,
      //listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: providerLogin.emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                ),
              ),
              TextField(
                controller: providerLogin.passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Text(
                    'Status do Acesso do Usuário: ',
                  ),
                  Icon(
                    providerLogin._auth.currentUser == null
                        ? Icons.check_box_outline_blank
                        : Icons.check_box_outlined,
                    color: providerLogin._auth.currentUser == null
                        ? Colors.red
                        : Colors.green,
                  ),
/*                  Icon(
                    providerLogin.user == null
                        ? Icons.check_box_outline_blank
                        : Icons.check_box_outlined,
                    color: providerLogin.user == null ? Colors.red : Colors.green,
                  ),
                  Consumer<LoginPage>(
                    builder: (context, userLogin, child) => Icon(
                      userLogin.user == null
                          ? Icons.check_box_outline_blank
                          : Icons.check_box_outlined,
                      color: userLogin.user == null ? Colors.red : Colors.green,
                    ),
                  ), */
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => providerLogin._loginUser(context),
                    child: const Text('Login'),
                  ),
                  //const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () => providerLogin._logoutUser(context),
                    child: const Text('Logout'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: const Text("Você ainda não tem uma conta?"),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgetPasswordPage()),
                  );
                },
                child: const Text('Esqueceu sua senha?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

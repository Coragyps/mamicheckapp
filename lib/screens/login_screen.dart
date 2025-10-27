import 'package:flutter/material.dart';
import 'package:mamicheckapp/screens.dart';
import 'package:mamicheckapp/services/authentication_service.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image(image: AssetImage('assets/img/logo.png'), fit: BoxFit.contain, height: 54),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('Mamicheck', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontFamily: 'caveat', color: Color(0xffCA3E7F), height: 0.8)),
//                 Text('Tu Aliado en el Embarazo', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimaryFixed)),
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: _body(context),
//       bottomNavigationBar: _navbar(context),
//     );
//   }

//   Widget _body(BuildContext context) {
//     return SafeArea(
//       child: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 12),
//                       child: Icon(Icons.mail_outline),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           TextFormField(
//                             controller: _emailController,
//                             decoration: const InputDecoration(
//                               border: OutlineInputBorder(),
//                               labelText: 'Correo Electronico',
//                             ),
//                             keyboardType: TextInputType.emailAddress,
//                             validator: (value) =>  value == null || value.isEmpty ? 'El correo no puede estar en blanco' : null,
//                           ),
//                           const SizedBox(height: 16),
//                           TextFormField(
//                             controller: _passwordController,
//                             obscureText: _obscurePassword,
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(),
//                               labelText: 'Contraseña',
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   _obscurePassword
//                                       ? Icons.visibility_off
//                                       : Icons.visibility,
//                                 ),
//                                 onPressed: () {
//                                   setState(() {_obscurePassword = !_obscurePassword;});
//                                 },
//                               ),
//                             ),
//                             validator: (value) => value == null || value.isEmpty ? 'La contraseña no puede estar en blanco' : null,
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//                 FilledButton(
//                   onPressed: () {
//                     showModalBottomSheet(
//                       context: context,
//                       isScrollControlled: true,
//                       builder: (context) {
//                         return DraggableScrollableSheet(
//                           expand: false,
//                           maxChildSize: 0.9,
//                           builder: (context, scrollController) {
//                             return UserPasswordEditSheet();
//                           }
//                         );
//                       },
//                     );
//                   },
//                   child: const Text("Olvide mi Contraseña"),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _navbar(BuildContext context) {
//     return BottomAppBar(
//       child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             FilledButton.icon(
//               icon: const Icon(Icons.login),
//               onPressed: () => _handleSignin(context),
//               label: const Text('Ingresar'),
//             ),
//             OutlinedButton.icon(
//               icon: const Icon(Icons.account_circle),
//               onPressed: () {
//                 _formKey.currentState?.reset();
//                 //Navigator.pushNamed(context, 'RegisterDialog');
//                 Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterDialog(), fullscreenDialog: true));
//               },
//               label: const Text('Registrarse'),
//             )
//           ],
//         ),
//     );
//   }

//   Future <void> _handleSignin(BuildContext context) async {
//     if (_formKey.currentState!.validate()) {
//       final messenger = ScaffoldMessenger.of(context);

//       final error = await AuthService().signin(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//       if (error != null) {
//         messenger.showSnackBar(SnackBar(content: Text(error)));
//       }
//     }
//   }
// }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentOrientation = MediaQuery.of(context).orientation;
    
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          // padding: EdgeInsets.symmetric(
          //   horizontal: currentOrientation == Orientation.portrait ? 8 : 150,
          //   vertical: 24,
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: currentOrientation == Orientation.portrait ? 0 : 32),
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image(image: AssetImage('assets/img/logo.png'), fit: BoxFit.contain, height: 75),
                    Column(
                      children: [
                        Text('Mamicheck', style: theme.textTheme.displayLarge?.copyWith(fontFamily: 'caveat', color: Color(0xffCA3E7F), height: 0.8)),
                        Text('Tu Aliado en el Embarazo', style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onPrimaryFixed)),           
                      ],
                    ),
                    const SizedBox(width: 20), 
                  ]
                ),
              ),
              SizedBox(height: currentOrientation == Orientation.portrait ? 48 : 0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: currentOrientation == Orientation.portrait ? 20 : 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Iniciar Sesión',style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimaryFixed)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: currentOrientation == Orientation.portrait ? 12 : 112),
                child: Material(
                  elevation: 0,
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surfaceContainerHigh,             
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 20, top: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 0,
                            children: [
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Correo Electronico',
                                  hintText: 'ejemplo@correo.com',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {return 'El correo no puede estar en blanco';}
                                  if (!value.contains('@') || !value.contains('.')) {return 'Ingresa un correo válido';}
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Contraseña',
                                  hintText: 'Mínimo 6 caracteres',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                    onPressed: () {setState(() {_obscurePassword = !_obscurePassword;});},
                                  ),
                                ),
                                textInputAction: TextInputAction.done,  
                                validator: (value) {
                                  if (value == null || value.isEmpty) {return 'La contraseña no puede estar en blanco';}
                                  if (value.length < 6) {return 'La contraseña debe tener al menos 6 caracteres';}
                                  return null;
                                },
                              ),
                              Align(
                                alignment: AlignmentGeometry.bottomRight,
                                child: TextButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return DraggableScrollableSheet(
                                        initialChildSize: 0.7,
                                        minChildSize: 0.4,
                                        expand: false,
                                        builder: (context, scrollController) {
                                          return Center(child: UserPasswordEditSheet());
                                        },
                                      );
                                    },
                                  );
                                },
                                  child: const Text('¿Olvido su Contraseña?')
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: currentOrientation == Orientation.portrait ? 20 : 120),
                child: Row(
                  children: [
                    FilledButton.icon(
                      onPressed: _isLoading ? null : () => _handleSignin(context),
                      icon: _isLoading
                      ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator())
                      : const Icon(Icons.login),
                      label: Text(_isLoading ? 'Ingresando...' : 'Ingresar')
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: _isLoading ? null : () {
                        _formKey.currentState?.reset();
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterDialog(), fullscreenDialog: true));
                      },
                      icon: const Icon(Icons.person_add_outlined),
                      label: const Text('Registrarse'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: currentOrientation == Orientation.portrait ? 0 : 32),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final messenger = ScaffoldMessenger.of(context);

      try {
        final error = await AuthService().signin(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (!mounted) return;
        if (error != null) {
          messenger.showSnackBar(SnackBar(content: Text(error), action: SnackBarAction(label: 'OK', onPressed: () {},)));
        }
      } finally {
        if (mounted) {setState(() => _isLoading = false);}
      }
    }
  }
}
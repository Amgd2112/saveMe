import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'modules/save_me/screens/profile/cubit/profile_cubit.dart';
import 'widgets/app_bar.dart';
import 'core/on_boarding/on_boarding.dart';
import 'modules/layout/layout.dart';
import 'modules/save_me/repositories/user_repository.dart';
import 'utils/app_bloc_observer.dart';
import 'config/themes/app_theme.dart';
import 'core/auth/blocs/auth_bloc.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final UserRepository _userRepository = UserRepository(
    firebaseAuth: FirebaseAuth.instance,
  );

  runApp(BlocProvider(
    create: (context) =>
        AuthBloc(userRepository: _userRepository)..add(AuthStarted()),
    child: MyApp(userRepository: _userRepository),
  ));
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;
  MyApp({UserRepository userRepository}) : _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileCubit()),
      ],
      child: MaterialApp(
        title: 'save me',
        debugShowCheckedModeBanner: false,
        // onGenerateRoute: _router.generateRoute,
        themeMode: ThemeMode.dark,
        darkTheme: appTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthFailure)
              return OnboardingScreen(userRepository: _userRepository);

            if (state is AuthSucess) return AppLayout();

            return Scaffold(
              appBar: appBar(context, isAppTitle: true, disableBack: false),
              body: Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}

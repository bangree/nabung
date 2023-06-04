import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/cubit/authenticationDataCubit.dart';
import 'package:nabung/cubit/transactionCubit.dart';
import 'package:nabung/cubit/walletCubit.dart';
import 'package:nabung/mainPages/SplashPage.dart';
import 'package:nabung/repository/authenticationRepository.dart';
import 'package:nabung/repository/transactionRepository.dart';
import 'package:nabung/repository/walletRepository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthenticationRepository authenticationRepository;
  late WalletRepository walletRepository;
  late TransactionRepository transactionRepository;

  @override
  void initState() {
    authenticationRepository = AuthenticationRepository();
    walletRepository = WalletRepository();
    transactionRepository = TransactionRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => authenticationRepository,
        ),
        RepositoryProvider(
          create: (context) => walletRepository,
        ),
        RepositoryProvider(
          create: (context) => transactionRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationDataCubit(
              authenticationRepository: authenticationRepository,
            )..init(),
          ),
          BlocProvider(
            create: (context) => WalletCubit(
              walletRepository: walletRepository,
            ),
          ),
          BlocProvider(
            create: (context) => TransactionCubit(
              transactionRepository: transactionRepository,
            ),
          ),
        ],
        child: Builder(builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.indigo,
              fontFamily: 'Montserrat',
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0,
              ),
            ),
            home: const SplashPage(),
          );
        }),
      ),
    );
  }
}

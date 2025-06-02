import 'package:chat/auth/domain/auth_use_case.dart';
import 'package:chat/chat_room_list_use_case.dart';
import 'package:chat/chat_room_list_view.dart';
import 'package:chat/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/presentation/auth_view.dart';
import 'auth/presentation/auth_view_model.dart';
import 'auth/data/auth_repository.dart';
import 'chat_room_list_view_model.dart';
import 'chat_repository.dart';
import 'chat_use_case.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth 계층 의존성 주입
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            AuthUseCase(AuthRepository()),
          ),
        ),
        // 채팅방 목록 계층
        ChangeNotifierProvider(
          create: (_) => ChatRoomListViewModel(
            ChatRoomListUseCase(ChatRepository()),
          ),
        ),
        // 채팅 화면 UseCase (필요시)
        Provider(
          create: (_) => ChatUseCase(ChatRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthStateWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthStateWrapper extends StatelessWidget {
  const AuthStateWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    return StreamBuilder<User?>(
      stream: authViewModel.authStateChanges,
      builder: (context, snapshot) {
        // 인증 상태 확인
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user != null) {
          return ChatRoomListView(currentUserId: user.uid);
        } else {
          return AuthView();
        }

      },
    );
  }
}

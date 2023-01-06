import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth authInstance = FirebaseAuth.instance;
final User? userAuth = authInstance.currentUser;
final uid = userAuth!.uid;

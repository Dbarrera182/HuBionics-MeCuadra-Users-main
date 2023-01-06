// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:mailjet/mailjet.dart';

String apiKey = "c4698526eed5798a8cd6ebccea94ca41";
String secretKey = "37effea06fe994ae9dd0070833d31cea";
//An email registered to your mailjet account
String myEmail = "jhohanhernandez@humanbionics.com.co";

Future NotificationMailjet(
    {required List<Recipient> recipients, message}) async {
  MailJet mailJet = MailJet(
    apiKey: apiKey,
    secretKey: secretKey,
  );
//Display the response after trying to send the email
  try {
    await mailJet.sendEmail(
      subject: "My first Mailjet email",
      sender: Sender(
        email: myEmail,
        name: "My name",
      ),
      reciepients: recipients,
      htmlEmail:
          "<h3>$message <a href='https://www.mailjet.com/'>Mailjet</a>!</h3><br />May the delivery force be with you!",
    );
  } catch (e) {
    print('An error has ocurred: $e');
  }
}

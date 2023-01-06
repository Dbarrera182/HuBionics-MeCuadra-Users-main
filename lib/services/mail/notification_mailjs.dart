// import 'dart:convert';

// import 'package:http/http.dart' as http;

// Future NotificationMail(
//     {message, date, adminNames, adminEmails, userName, userEmail}) async {
//   const serviceId = 'service_enxyllc';
//   const templateId = 'template_ysqng6a';
//   const userId = '12f4MYj5TwdPaoC4d';
//   var url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
//   try {
//     var response = await http.post(url,
//         headers: {
//           //important line to send mail phone devie:
//           'origin': 'http://localhost',
//           'Content-Type': 'application/json'
//         },
//         body: json.encode({
//           //required params to send mail
//           'service_id': serviceId,
//           'template_id': templateId,
//           'user_id': userId,
//           //Dynamic params in mail message
//           'template_params': {
//             'message': message,
//             'to_name': adminNames,
//             'to_emails': adminEmails,
//             'from_name': userName,
//             'reply_to': userEmail
//           }
//         }));
//     print('[Feed back response] ${response.body}');
//   } catch (e) {
//     print('Feedback error: $e');
//   }
// }


//EmailJS Service
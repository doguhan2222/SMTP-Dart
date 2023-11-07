import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


/*
*  path_provider: ^2.0.15   IMPORT PATHPROVIDER TO PUBSPEC.YAML FOR GET EXCEL FILE PATH ON YOUR DEVICE.
*
*   final excelFilePath = '${uygulamaYolu.path}/excelDosyalari/deneme_excel.xlsx';
*   I CREATED 'excelDosyalari` FOLDER in com.example.example / app_flutter / excelDosyalari / deneme_excel.xlsx
*   AND CREATED MY 'deneme_excel.xlsx' EXCEL FILE THERE. GETTING PATH AND CONVERT BASE64  .
*
*/

class SmtpExcelAndText{


  // Email with text content and Excel file
  static void SMTPEmailAndText() async {
    final username = 'YOURMAIL@YOURDOMAINADRESS';// its your email adress , created on hosting.
    final password = 'PASSWROD';        // its passworf of your email adress , created on domain
    Directory appPath = await getApplicationDocumentsDirectory();
    final excelFilePath = '${appPath.path}/excelDosyalari/deneme_excel.xlsx';

                        // MAIL.YOURDOMAINADRESS
    SecureSocket.connect('mail.YOURDOMAINADRESS', 465).then((socket) {
                        // MAIL.YOURDOMAINADRESS
      socket.writeln("EHLO mail.YOURDOMAINADRESS");
      socket.writeln("AUTH LOGIN " + base64.encode(utf8.encode(username)));//CONVERT YOUR USERNAME TO BASE64
      socket.writeln(base64.encode(utf8.encode(password)));//CONVERT YOUR PASSWROD TO BASE64

      socket.listen((event) async {
        String response = String.fromCharCodes(event);
        if (response.startsWith('235 ')) {// 235 = YOU HAVE LOGIN WITH SUCCESS
          socket.writeln('MAIL FROM: <$username>'); // YOUR MAIL ADRESS.
          socket.writeln('RCPT TO: <destination@gmail.com>'); //DESTINATION MAIL ADDRESS
          socket.writeln('DATA');
          socket.writeln('Subject: Test E-posta'); // EMAIL SUBJECT. ITS 'TEST EPOSTA' NOW
          socket.writeln('From: $username'); // YOUR MAIL ADRESS.
          socket.writeln('To: destination@gmail.com'); //DESTINATION MAIL ADDRESS
          socket.writeln('Content-Type: multipart/mixed; boundary="abc123"');//To separate the contents from each other  - Excel and Text
          socket.writeln('');
          socket.writeln('--abc123');//To separate the contents from each other - Excel and Text
          socket.writeln('Content-Type: text/plain; charset=utf-8');
          socket.writeln('Hi.It is text content.'); // YOUR EMAIL TEXT CONTENT
          socket.writeln('');
          final excelFile = File(excelFilePath);
          final excelData = await excelFile.readAsBytes();
          final base64ExcelData = base64.encode(excelData);
          socket.writeln('--abc123');//To separate the contents from each other - Excel and Text
          socket.writeln('Content-Type: application/vnd.ms-excel; name="deneme_excel.xlsx"');
          socket.writeln('Content-Transfer-Encoding: base64');
          socket.writeln('Content-Disposition: attachment; filename="deneme_excel.xlsx"');
          socket.writeln('');
          socket.writeln(base64ExcelData);
          socket.writeln('--abc123--');//To separate the contents from each other - Excel and Text. Finish.
          socket.writeln('.');
          socket.writeln('QUIT');
          await socket.flush();
        }
        print(response);
      }, onError: (error) {// If an error occurs while sending an e-mail.(internet connection loss etc.)
        print('ERROR');
        print(error);
      }, onDone: () { // process completed.
        print("socket closed");
      });
    });
  }

}
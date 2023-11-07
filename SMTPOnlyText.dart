
import 'dart:convert';
import 'dart:io';

class SMTPOnlyText {


  void SmtpOnlyText() async {

    final username = 'YOURMAIL@YOURDOMAINADRESS';// its your email adress , created on hosting.
    final password = 'PASSWROD';        // its passworf of your email adress , created on domain

    SecureSocket.connect('mail.YOURDOMAINADRESS',
      465,// its port number . Check your Secure SSL/TLS Settings on hosting panel.
    ).then((socket) {
      socket.writeln("EHLO mail.YOURDOMAINADRESS");
      socket.writeln("AUTH LOGIN " + base64.encode(utf8.encode(username)));
      socket.writeln(base64.encode(utf8.encode(password)));
      socket.writeln('MAIL FROM: <$username>');// YOUR MAIL ADRESS.
      socket.writeln('RCPT TO: destination@gmail.com');//DESTINATION MAIL ADDRESS

      socket.listen((event) async {
        String gelenKod = String.fromCharCodes(event);
        if (gelenKod.startsWith('235 ')) { // AUTH successful

          socket.writeln('MAIL FROM: <$username>');// YOUR MAIL ADRESS.
          socket.writeln('RCPT TO: <destination@gmail.com>');//DESTINATION MAIL ADDRESS
          socket.writeln('DATA');
          socket.writeln('Subject: Test E-posta');
          socket.writeln('From: $username');
          socket.writeln('To: destination@gmail.com'); // Alıcı e-posta adresi burada olmalı
          socket.writeln('Content-Type: text/plain; charset=utf-8');
          socket.writeln('Hi.its text content.');
          socket.writeln('.'); // MAIL BITIRIKEN BNU YAZ
          socket.writeln('QUIT');
          await socket.flush();
        }


      }, onError: (error) {
        print('error');
        print(error);
      }, onDone: () {
        print("SOCKET CLOSED");
      });
    });
  }

}

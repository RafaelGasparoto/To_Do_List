import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Home.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runApp(MaterialApp(
    theme: ThemeData(textTheme: GoogleFonts.indieFlowerTextTheme()),
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}
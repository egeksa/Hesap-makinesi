import 'package:flutter/material.dart';

void main() {
  runApp(const HesapMakinesiApp());
}

class HesapMakinesiApp extends StatefulWidget {
  const HesapMakinesiApp({super.key});

  @override
  State<HesapMakinesiApp> createState() => _HesapMakinesiAppState();
}

class _HesapMakinesiAppState extends State<HesapMakinesiApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[150],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black87,
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: AnaSayfa(
        isDarkMode: isDarkMode,
        onThemeChanged: (val) {
          setState(() {
            isDarkMode = val;
          });
        },
      ),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const AnaSayfa({super.key, required this.isDarkMode, required this.onThemeChanged});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  String output = "0";
  String userInput = "";
  List<String> gecmisListesi = [];

  // Butona basıldığında çalışacak mantık
  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        output = "0";
        userInput = "";
      } else if (buttonText == "=") {
        try {
          String sonuc = hesapla(userInput);
          gecmisListesi.add("$userInput = $sonuc");
          output = sonuc;
          userInput = sonuc;
        } catch (e) {
          output = "HATA";
          userInput = "";
        }
      } else {
        if (output == "0" || output == "HATA") {
          userInput = buttonText;
        } else {
          userInput = userInput + buttonText;
        }
        output = userInput;
      }
    });
  }
  // Basit hesaplama motoru (Hata korumalı)
  String hesapla(String expression) {
    try {
      expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
      if (expression.contains('/0')) {
        return "HATA";
      }
      // Basit toplama çıkarma parsing örneği
      if (expression.contains('+')) {
        List<String> parcalar = expression.split('+');
        double toplam = 0;
        for (var p in parcalar) {
          toplam += double.parse(p);
        }
        return toplam.toString();
      } else if (expression.contains('-')) {
        List<String> parcalar = expression.split('-');
        double sonuc = double.parse(parcalar[0]) - double.parse(parcalar[1]);
        return sonuc.toString();
      } else if (expression.contains('*')) {
        List<String> parcalar = expression.split('*');
        double sonuc = double.parse(parcalar[0]) * double.parse(parcalar[1]);
        return sonuc.toString();
      } else if (expression.contains('/')) {
        List<String> parcalar = expression.split('/');
        if (double.parse(parcalar[1]) == 0) return "HATA";
        double sonuc = double.parse(parcalar[0]) / double.parse(parcalar[1]);
        return sonuc.toString();
      }
      return expression;
    } catch (e) {
      return "HATA";
    }
  }

  // Öğrenme Penceresi
  void ogrenmeDialogGoster(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Matematik İşaretleri Öğren"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("+ (Toplama): İki sayıyı birleştirir."),
            Text("- (Çıkarma): Eksiltme yapar."),
            Text("× (Çarpma): Katları hesaplar."),
            Text("÷ (Bölme): Eşit parçalara ayırır."),
            Text("Not: Sıfıra bölme hatası 'HATA' döndürür."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Kapat"),
          ),
        ],
      ),
    );
  }

  // İnternetsiz Para Birimi Çevirici (Sabit Kurlar)
  void paraBirimiDialogGoster(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("İnternetsiz Para Çevirici"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Sabit Baz Kurlar (Offline):"),
            Text("1 USD = 34.00 TL"),
            Text("1 EUR = 37.00 TL"),
            Text("1 GBP = 43.00 TL"),
            Text("\n(İstediğiniz kuru koda ekleyip ayrı butonlar yapabilirsiniz.)"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tamam"),
          ),
        ],
      ),
    );
  }

  Widget buildButton(String buttonText, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.all(22.0),
          ),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gelişmiş Hesap Makinesi"),
        actions: [
          // Tema Değiştirme Butonu
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () => widget.onThemeChanged(!widget.isDarkMode),
          ),
          // Öğrenme Butonu
          IconButton(
            icon: const Icon(Icons.school),
            onPressed: () => ogrenmeDialogGoster(context),
            tooltip: "Öğren",
          ),
          // Para Birimi Butonu
          IconButton(
            icon: const Icon(Icons.货币_exchange ?? Icons.monetization_on),
            onPressed: () => paraBirimiDialogGoster(context),
            tooltip: "Para Birimi",
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // Ekran / Display
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Text(
              output,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          // Geçmiş Alanı
          Expanded(
            child: ListView.builder(
              itemCount: gecmisListesi.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(gecmisListesi[index], textAlign: TextAlign.right),
                );
              },
            ),
          ),
          const Divider(),
          // Tuş Takımı
          Row(children: [buildButton("7", Colors.grey), buildButton("8", Colors.grey), buildButton("9", Colors.grey), buildButton("÷", Colors.orange)]),
          Row(children: [buildButton("4", Colors.grey), buildButton("5", Colors.grey), buildButton("6", Colors.grey), buildButton("×", Colors.orange)]),
          Row(children: [buildButton("1", Colors.grey), buildButton("2", Colors.grey), buildButton("3", Colors.grey), buildButton("-", Colors.orange)]),
          Row(children: [buildButton("C", Colors.red), buildButton("0", Colors.grey), buildButton("=", Colors.green), buildButton("+", Colors.orange)]),
        ],
      ),
    );
  }
}

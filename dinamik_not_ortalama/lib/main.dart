import 'package:flutter/material.dart';

import 'Derslerdao.dart'; // Veri tabanı bağlantı dosyası
import 'Notlar.dart'; // Model dosyası

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dinamik Ortalama Hesapla",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  Future<List<Notlar>> tumNotlariGetir() async {
    return Derslerdao().dersleriGetir();
  }

  Future<void> NotEkle(String ders_ad, String not_harf, int not_kredi) async {
    await Derslerdao().dersEkle(ders_ad, not_harf, not_kredi);
    setState(() {}); // Listeyi ve ortalamayı yenilemek için
  }

  Future<void> NotSil(int not_id) async {
    await Derslerdao().DersSil(not_id);
    setState(() {}); // Listeyi ve ortalamayı yenilemek için
  }

  double genelOrtalama = 0.0;
  int secilenKredi = 1;
  var krediListe = List.generate(10, (index) => index + 1);
  var secilenNot = "FF";
  var notListe = [
    "AA",
    "BA",
    "BB",
    "CB",
    "CC",
    "DC",
    "DD",
    "FD",
    "FF"
  ];

  var formKey = GlobalKey<FormState>();
  var tfders = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Klavye açıldığında listeyi hareket ettirme
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Ortalama Hesapla",style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<Notlar>>(
            future: tumNotlariGetir(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                var notListesi = snapshot.data!;
                genelOrtalama = ortalamaHesapla(notListesi);
                return Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(child: Row(
                        children: [
                          // Sol sütun (Form alanı)
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // TextFormField üstte
                                    TextFormField(
                                      controller: tfders,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.indigo[100],
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        hintText: "Ders adı giriniz",
                                        hintStyle: TextStyle(color: Colors.black),
                                      ),
                                      validator: (tfgirdisi) {
                                        if (tfgirdisi!.isEmpty) {
                                          return "Ders adı giriniz.";
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 16),
                                    // DropdownButton ve IconButton alt sırada
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: DropdownButtonFormField<String>(
                                            value: secilenNot,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.indigo[100],
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                            items: notListe.map((String value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                secilenNot = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          flex: 2,
                                          child: DropdownButtonFormField<int>(
                                            value: secilenKredi,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.indigo[100],
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(20),

                                              ),
                                            ),
                                            items: krediListe.map((int value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(value.toString(),style: TextStyle(color: Colors.black87),),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                secilenKredi = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        SizedBox(
                                          width: 15,

                                          child: IconButton(
                                            onPressed: () {
                                              if (formKey.currentState!.validate()) {
                                                NotEkle(tfders.text, secilenNot, secilenKredi);
                                                tfders.clear(); // Text alanını temizler
                                              }
                                            },
                                            icon: Icon(Icons.keyboard_arrow_right_rounded),
                                            color: Colors.deepPurple,
                                            iconSize: 32,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Sağ sütun (Genel ortalama veya metin alanı)
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(

                                child: Column(
                                  children: [
                                    Text("${notListesi.length} Ders Girildi",style: TextStyle(color:Colors.indigo ,fontSize: 20,fontWeight: FontWeight.bold),),
                                    Text(
                                      "${genelOrtalama.toStringAsFixed(2)}",
                                      style: TextStyle(fontSize:35, fontWeight: FontWeight.bold,color: Colors.indigo),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text("Ortalama",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.indigo),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ),


                      Expanded(
                        flex:3,
                        child: ListView.builder(
                          itemCount: notListesi.length,
                          itemBuilder: (context, indeks) {
                            var not = notListesi[indeks];
                            return Dismissible(
                              key: Key(not.not_id.toString()),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding:
                                EdgeInsets.symmetric(horizontal: 20),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              onDismissed: (direction) async {
                                await NotSil(not.not_id);
                                setState(() {});
                              },
                              child: SizedBox(
                                height: 90,
                                child: Card(
                                  child: ListTile(
                                    title: Text(not.ders_ad,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),),
                                    subtitle: Text(
                                      "${not.not_kredi} Kredili, Not Değeri ${not.not_harf}",style: TextStyle(fontSize: 17),),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.indigo,
                                      foregroundColor: Colors.white,
                                      child: Text(not.not_id.toString()),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Expanded(
                  child: Center(child: Text("Ders bulunamadı.")),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  double ortalamaHesapla(List<Notlar> notlar) {
    double toplamNot = 0.0;
    int toplamKredi = 0;

    for (var not in notlar) {
      toplamNot += degerBulma(not.not_harf) * not.not_kredi;
      toplamKredi += not.not_kredi;
    }

    return toplamKredi == 0 ? 0.0 : toplamNot / toplamKredi;
  }

  double degerBulma(String harfnotu) {
    switch (harfnotu) {
      case 'AA':
        return 4.0;
      case 'BA':
        return 3.5;
      case 'BB':
        return 3.0;
      case 'CB':
        return 2.5;
      case 'CC':
        return 2.0;
      case 'DC':
        return 1.5;
      case 'DD':
        return 1.0;
      case 'FD':
        return 0.5;
      case 'FF':
        return 0.0;
      default:
        return 0.0;
    }
  }
}

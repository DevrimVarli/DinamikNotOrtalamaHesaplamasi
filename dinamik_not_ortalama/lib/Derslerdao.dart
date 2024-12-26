import 'package:dinamiknotortalama/Notlar.dart';
import 'package:dinamiknotortalama/VeritabaniYardimcisi.dart';

class Derslerdao{
  Future<List<Notlar>> dersleriGetir() async{
    var db=await VeritabaniYardimcisi.veritabaniErisim();
    List<Map<String,dynamic>> maps=await db.rawQuery("SELECT * FROM dersler ");
    return List.generate(maps.length, (i){
      var satir=maps[i];
      return Notlar(not_id: satir["not_id"], ders_ad:  satir["ders_ad"], not_harf:  satir["not_harf"], not_kredi:  satir["not_kredi"]);

    });

  }
  Future<void> DersSil(int not_id) async{
    var db=await VeritabaniYardimcisi.veritabaniErisim();
    await db.delete("dersler",where: "not_id=?",whereArgs: [not_id]);

  }
  Future<void> DersGuncelle(int not_id,String ders_ad,String not_harf,int not_kredi) async{
    var db=await VeritabaniYardimcisi.veritabaniErisim();
    var bilgiler=Map<String,dynamic>();
    bilgiler["not_id"]=not_id;
    bilgiler["ders_ad"]=ders_ad;
    bilgiler["not_harf"]=not_harf;
    bilgiler["not_kredi"]=not_kredi;
    await db.update("dersler", bilgiler,where: "not_id=?",whereArgs: [not_id]);


  }
  Future<void> dersEkle(String ders_ad,String not_harf,int not_kredi) async{
    var db=await VeritabaniYardimcisi.veritabaniErisim();
    var bilgiler=Map<String,dynamic>();
    bilgiler["ders_ad"]=ders_ad;
    bilgiler["not_harf"]=not_harf;
    bilgiler["not_kredi"]=not_kredi;


    await db.insert("dersler", bilgiler);



  }




}
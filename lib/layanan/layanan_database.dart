import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mytimses/models/kecamatan.dart';
import 'package:mytimses/models/kelurahan.dart';
import 'package:mytimses/models/timses.dart';
import 'package:mytimses/models/anggota.dart';

class LayananDatabase {

  // properti
  final String? uid;
  final String? dapil;
  final String? kecamatan;
  final String? kelurahan;
  final String? timsesID;

  // konstruktor
  LayananDatabase({
    this.uid,
    this.dapil,
    this.kecamatan,
    this.kelurahan,
    this.timsesID
  });

  // collection reference
  final CollectionReference anggotaCollection = FirebaseFirestore
      .instanceFor(app: Firebase.app())
      .collection("ketuatimses");

  final CollectionReference timsesCollection = FirebaseFirestore
      .instanceFor(app: Firebase.app())
      .collection("ketuatimses");
  
  final CollectionReference kecamatanCollection = FirebaseFirestore
      .instanceFor(app: Firebase.app())
      .collection("kecamatan");

  final CollectionReference kelurahanCollection = FirebaseFirestore
      .instanceFor(app: Firebase.app())
      .collection("kelurahan");

  final CollectionReference calegCollection = FirebaseFirestore
      .instanceFor(app: Firebase.app())
      .collection("caleg");

  // getters (single) stream
  Stream<TimSes> get timses {
    return timsesCollection
        .doc(timsesID)
        .snapshots()
        .map(singleTimsesFromSnapshot);
  }

  /*Stream<Caleg> get caleg {
    return calegCollection
        .doc(uid)
        .snapshots()
        .map((event) => null);
  }*/

  // getters (iterable) stream
  Stream<Iterable<Kecamatan>> get kecamatans {
    return kecamatanCollection
        .snapshots()
        .map(kecamatanListFromSnapshot);
  }

  Stream<Iterable<Kelurahan>> get kelurahans {
    return kelurahanCollection
        .where("namakecamatan", isEqualTo: kecamatan)
        .snapshots()
        .map(kelurahanListFromSnapshot);
  }

  Stream<Iterable<Anggota>> get anggotas {
    return anggotaCollection
        .doc(uid)
        .collection("anggota")
        .snapshots()
        .map(anggotaListFromSnapshot);
  }

  // create (single) object from (json format) snapshot above
  TimSes singleTimsesFromSnapshot(DocumentSnapshot documentSnapshot) {
    return TimSes(
      timsesID: timsesID,
      namaKetuaTimses: documentSnapshot["namaKetuaTimses"],
      namaCaleg: documentSnapshot["namaCaleg"],
      namaKecamatan: documentSnapshot["kecamatan"],
      namaKelurahan: documentSnapshot["kelurahan"]
    );
  }

  // create (iterable) object from (json format) snapshot above
  Iterable<Anggota> anggotaListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return Anggota(
        timsesID: doc["timsesID"],
        namaKetuaTimses: doc["namaKetuaTimses"],
        nomorKTP: doc["nomorKTP"],
        namaAnggota: doc["namaAnggota"],
        jenisKelamin: doc["jenisKelamin"],
        tempatLahir: doc["tempatLahir"],
        tanggalLahir: doc["tanggalLahir"],
        alamat: doc["alamat"],
        kelurahan: doc["kelurahan"],
        kecamatan: doc["kecamatan"],
        nomorTelepon: doc["nomorTelepon"]
      );
    });
  }

  Iterable<Kecamatan> kecamatanListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return Kecamatan(
          dapil: doc["dapil"],
          namaKecamatan: doc["nama"]
      );
    });
  }

  Iterable<Kelurahan> kelurahanListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return Kelurahan(
          namaKecamatan: doc["namakecamatan"],
          namaKelurahan: doc["namakelurahan"]
      );
    });
  }

  // operate data crud (create update delete) and select
  Future<dynamic> setTimsesData(
      String timsesID,
      String namaKetuaTimses,
      String namaCaleg,
      String kecamatan,
      String kelurahan,
      int jumlahAnggota
      ) async {
    return await timsesCollection.doc(uid).set({
      "timsesID": timsesID,
      "namaKetuaTimses": namaKetuaTimses,
      "namaCaleg": namaCaleg,
      "kecamatan": kecamatan,
      "kelurahan": kelurahan,
      "jumlahanggota": 0
    });
  }

  Future<dynamic> setAnggotaData(
      String timsesID,
      String namaKetuaTimses,
      String nomorKTP,
      String namaAnggota,
      String jenisKelamin,
      String tempatLahir,
      String tanggalLahir,
      String alamat,
      String kelurahan,
      String kecamatan,
      String nomorTelepon
      ) async {
    return await anggotaCollection
        .doc(uid)
        .collection("anggota")
        .doc()
        .set({
      "timsesID": timsesID,
      "namaKetuaTimses": namaKetuaTimses,
      "nomorKTP": nomorKTP,
      "namaAnggota": namaAnggota,
      "jenisKelamin": jenisKelamin,
      "tempatLahir": tempatLahir,
      "tanggalLahir": tanggalLahir,
      "alamat": alamat,
      "kelurahan": kelurahan,
      "kecamatan": kecamatan,
      "nomorTelepon": nomorTelepon
    });
  }

  Future<QuerySnapshot<Object?>> getTimses(String namaKetuaTimses) async {
    return await timsesCollection.where("namaKetuaTimses", isEqualTo: namaKetuaTimses).get();
  }

  Future<void> setAnggotaTimses(String timsesID, int jumlahAnggota) async {
    return await timsesCollection.doc(timsesID).set({
      "jumlahanggota": jumlahAnggota = jumlahAnggota + 1
    }, SetOptions(merge: true));
  }

  Future<QuerySnapshot> getKelurahan(String namaKelurahan) async {
    return await kelurahanCollection.where("namakelurahan", isEqualTo: namaKelurahan).get();
  }

  Future<dynamic> setAnggotaKelurahan(String kelurahanID, int jumlahAnggota) async {
    return await kelurahanCollection.doc(kelurahanID).set({
      "jumlahanggota": jumlahAnggota = jumlahAnggota + 1
    }, SetOptions(merge: true));
  }
  
  Future<QuerySnapshot> getKecamatan(String namaKecamatan) async {
    return await kecamatanCollection.where("nama", isEqualTo: namaKecamatan).get();
  }
  
  Future<dynamic> setAnggotaKecamatan(String kecamatanID, int jumlahAnggota) async {
    return await kecamatanCollection.doc(kecamatanID).set({
      "jumlahanggota": jumlahAnggota = jumlahAnggota + 1
    }, SetOptions(merge: true));
  }

}
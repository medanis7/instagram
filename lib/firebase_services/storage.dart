import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
getImgUrl({required imgName, required imgPath})async{
  // Upload image to firebase storage
      final storageRef = FirebaseStorage.instance.ref(imgName);
      // use this code if u are using flutter web
 UploadTask uploadTask = storageRef.putData(imgPath);
 TaskSnapshot snap = await uploadTask;

// Get img url
      // String url = await storageRef.getDownloadURL();
      String url = await snap.ref.getDownloadURL();

// Store img url in firestore[database]
      //  users.doc(credential!.uid).set({"imgURL": url,});
return url;
}
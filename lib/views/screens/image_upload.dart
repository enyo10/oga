import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  ImageUploadState createState() => ImageUploadState();
}

class ImageUploadState extends State<ImageUpload> {
  String imageUrl = "";

  @override
  Widget build(BuildContext context) {
    /*backgroundColor:
    Colors.white;*/
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload Image',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  border: Border.all(color: Colors.white),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(2, 2),
                      spreadRadius: 2,
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: (imageUrl.isNotEmpty)
                    ? Image.file(File(imageUrl))
                    : Image.network('https://i.imgur.com/sUFH1Aq.png')),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () {
                print(" Adriano, bonjour");
                _upLoadImage();
              },
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.red)),
              ),
              child: const Text(
                "Choose file",
                style: TextStyle(fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _upLoadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      print(" file a file ${file.path}");
      setState(() {
        imageUrl = file.path;
      });
      

      // Create the file metadata
      final metadata = SettableMetadata(contentType: "image/jpeg");

// Create a reference to the Firebase Storage bucket
      final storageRef = FirebaseStorage.instance.ref();
      String fileName = basename(file.path);
      final imageRef =storageRef.child("images/$fileName");

// Upload file and metadata to the path 'images/mountains.jpg'

      final uploadTask =
          storageRef.child("images/$fileName").putFile(file, metadata);

// Listen for state changes, errors, and completion of the upload.
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            if (kDebugMode) {
              print("Upload is $progress% complete.");
            }
            String url = await imageRef.getDownloadURL();
            if (kDebugMode) {
              print(" Url ....$url");
            }
            // urls.add(url.split("%2F")[2]);
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
            // Handle successful uploads on complete
            // ...
            break;
        }
      });
    } else {
      // User canceled the picker
    }
  }

  _downloadFile() async {
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();

// Create a reference with an initial file path and name
    final pathReference = storageRef.child("images/stars.jpg");

// Create a reference to a file from a Google Cloud Storage URI
    final gsReference = FirebaseStorage.instance
        .refFromURL("gs://YOUR_BUCKET/images/stars.jpg");

// Create a reference from an HTTPS URL
// Note that in the URL, characters are URL escaped!
    final httpsReference = FirebaseStorage.instance.refFromURL(
        "https://firebasestorage.googleapis.com/b/YOUR_BUCKET/o/images%20stars.jpg");
    final islandRef = storageRef.child("images/island.jpg");

    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = "${appDocDir.absolute}/images/island.jpg";
    final file = File(filePath);

    final downloadTask = islandRef.writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          // TODO: Handle this case.
          break;
        case TaskState.paused:
          // TODO: Handle this case.
          break;
        case TaskState.success:
          // TODO: Handle this case.
          break;
        case TaskState.canceled:
          // TODO: Handle this case.
          break;
        case TaskState.error:
          // TODO: Handle this case.
          break;
      }
    });
  }

  /*Future<void> addArticle(
      {required Map article, required List<File> files}) async {
    */ /*   var id = article['id'] ??=
        ref.doc("${category.id}").collection("articles").doc().id;*/ /*
    List<String> urls = [];

    for (File file in files) {
      var imageName = "${DateTime.now().hashCode}.jpg";

      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('${category.name}')
          .child('$id')
          .child('/$imageName');
      try {
        await storageRef.putFile(file);

        String url = await storageRef.getDownloadURL();
        urls.add(url.split("%2F")[2]);
      } on firebase_core.FirebaseException catch (e) {
        print(e);
      }
    }
    article['imageUrls'] = jsonEncode(urls);
    var articleToBeAdd = Article.fromMap(article, article['id']);
    dataProvider.setArticle(articleToBeAdd);
    category.addArticle(articleToBeAdd);

    updateDocument(category);
  }*/

  /* uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path)).toList();
    } else {
      // User canceled the picker
    }
    PickedFile image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted){
      //Select Image
      image = await _imagePicker.getImage(source: ImageSource.gallery);
      var file = File(image.path);

      if (image != null){
        //Upload to Firebase
        var snapshot = await _firebaseStorage.ref()
            .child('images/imageName')
            .putFile(file).onComplete;
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }*/
}

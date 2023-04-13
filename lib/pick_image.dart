import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
}

pickVideo(ImageSource source) async {
  final ImagePicker _videoPicker = ImagePicker();
  XFile? _file = await _videoPicker.pickVideo(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
}




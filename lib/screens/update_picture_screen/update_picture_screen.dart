import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/screens/update_picture_screen/update_pic_manger.dart';
import 'package:social_media_app/shared/colors.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/widgets/loading_widget.dart';

enum PicType { profile, cover }

class UpdatePictureScreen extends StatefulWidget {
  const UpdatePictureScreen({Key? key, required this.type}) : super(key: key);
  final PicType type;
  @override
  _UpdatePictureScreenState createState() => _UpdatePictureScreenState();
}

class _UpdatePictureScreenState extends State<UpdatePictureScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UpdatePicManger(widget.type),
      builder: (context, child) => Consumer<UpdatePicManger>(
        builder: (context, model, child) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(
                    'Update ${widget.type == PicType.profile ? 'Profile' : 'Cover'} Picture',
                    style: logoTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        model.update(context);
                      },
                      child: const Text('Done'),
                    )
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: MyColor.blue,
                  child: const Icon(
                    Icons.add,
                  ),
                ),
              ),
              if (model.isLoading) loadingWidget(),
            ],
          );
        },
      ),
    );
  }
}

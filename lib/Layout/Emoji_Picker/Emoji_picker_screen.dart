import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../Home/newpost_screen.dart';

class EmojiPickerScreen extends StatefulWidget
{

  @override
  State<EmojiPickerScreen> createState() => _EmojiPickerState();
}

class _EmojiPickerState extends State<EmojiPickerScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon : Icon(Iconsax.arrow_left_1,color: Colors.black,), onPressed: () { Navigator.pop(context); },),
        centerTitle: true,
      ),
      body: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          // Do something when emoji is tapped (optional)
        },
        onBackspacePressed: () {
          // Do something when the user taps the backspace button (optional)
        },
        textEditingController: postTextController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
        config: Config(
          columns: 7,
          emojiSizeMax: 32 * (1.0), // Issue: https://github.com/flutter/flutter/issues/28894
          verticalSpacing: 0,
          horizontalSpacing: 0,
          gridPadding: EdgeInsets.zero,
          initCategory: Category.RECENT,
          bgColor: Color(0xFFF2F2F2),
          indicatorColor: Colors.blue,
          iconColor: Colors.grey,
          iconColorSelected: Colors.blue,
          progressIndicatorColor: Colors.blue,
          backspaceColor: Colors.blue,
          skinToneDialogBgColor: Colors.white,
          skinToneIndicatorColor: Colors.grey,
          enableSkinTones: true,
          showRecentsTab: true,
          recentsLimit: 28,
          noRecents: const Text(
            'No Recents',
            style: TextStyle(fontSize: 20, color: Colors.black26),
            textAlign: TextAlign.center,
          ),
          tabIndicatorAnimDuration: kTabScrollDuration,
          categoryIcons: const CategoryIcons(),
          buttonMode: ButtonMode.MATERIAL,
        ),
      ),
    );
  }
}

import 'package:contact_book/core/colors.dart';
import 'package:contact_book/helpers/sddb_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IconTextTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool noCopy;
  const IconTextTile({super.key, required this.icon, required this.text, this.noCopy = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: context.width(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: ColorCode.colorList(context).middleSecondary!,
          ),
        ),
        height: 55,
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          leading: Icon(icon, color: ColorCode.colorList(context).middlePrimary, size: 20),
          title: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorCode.colorList(context).customTextColor, fontSize: 15, fontWeight: FontWeight.w500),
          ),
          trailing: noCopy
              ? null
              : IconButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied to clipboard!')));
                  },
                  icon: Icon(Icons.copy_rounded, color: ColorCode.colorList(context).middlePrimary, size: 20)),
        ));
  }
}
